import 'dart:convert';

class User {
  final String? id;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? phone;
  final DateTime? created;
  final DateTime? updated;

  User({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.phone,
    this.created,
    this.updated,
  });

  factory User.fromJson(Map<String, dynamic> map) {
    return User(
      id: map["id"].toString(),
      firstName: map["first_name"].toString(),
      lastName: map["last_name"].toString(),
      email: map["email"].toString(),
      phone: map["phone"].toString(),
      created: DateTime.parse(
        map["created"].toString(),
      ),
      updated: DateTime.parse(
        map["updated"].toString(),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "first_name": firstName,
      "last_name": lastName,
      "email": email,
      "phone": phone,
      'created': created != null
          ? created!.toIso8601String()
          : DateTime.now().toIso8601String(),
      'updated': updated != null
          ? updated!.toIso8601String()
          : DateTime.now().toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'User{id : $id, firstName : $firstName, lastName : $lastName, email : $email, phone : $phone, created : $created, updated : $updated}';
  }

  static List<User> userFromJson(String jsonData) {
    final data = jsonDecode(jsonData);
    return List<User>.from(
      data["values"].map(
        (item) => User.fromJson(item),
      ),
    );
  }

  static String userToJson(User data) {
    final jsonData = data.toJson();
    return jsonEncode(jsonData);
  }
}
