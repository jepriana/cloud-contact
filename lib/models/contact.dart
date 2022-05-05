import 'dart:convert';

import 'package:cloud_contact/models/user.dart';

class Contact extends User {
  bool isFavorite;

  Contact({
    String? id,
    required firstName,
    required lastName,
    required phone,
    required email,
    this.isFavorite = false,
    DateTime? created,
    DateTime? updated,
  }) : super(
          id: id,
          firstName: firstName,
          lastName: lastName,
          email: email,
          phone: phone,
          created: created,
          updated: updated,
        );

  factory Contact.fromJson(Map<String, dynamic> map) {
    return Contact(
      id: map["id"].toString(),
      firstName: map["first_name"].toString(),
      lastName: map["last_name"].toString(),
      phone: map["phone"].toString(),
      email: map["email"].toString(),
      isFavorite: map["is_favorite"] ?? false,
      created: DateTime.parse(
        map["created"].toString(),
      ),
      updated: DateTime.parse(
        map["updated"].toString(),
      ),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "first_name": firstName,
      "last_name": lastName,
      "email": email,
      "phone": phone,
      "is_favorite": isFavorite,
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
    return 'Contact{id : $id, firstName : $firstName, lastName : $lastName, phone : $phone, email : $email, isFavorite : $isFavorite, created : $created, updated : $updated}';
  }

  String getFullName() {
    return firstName != null && lastName != null
        ? firstName.toString() + ' ' + lastName.toString()
        : '';
  }

  static List<Contact> contactFromJson(String jsonData) {
    final data = jsonDecode(jsonData);
    return List<Contact>.from(
      data["values"].map(
        (item) => Contact.fromJson(item),
      ),
    );
  }

  static String contactToJson(Contact data) {
    final jsonData = data.toJson();
    return jsonEncode(jsonData);
  }
}
