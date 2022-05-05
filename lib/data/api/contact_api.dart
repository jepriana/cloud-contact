import 'dart:convert';

import 'package:cloud_contact/constants.dart';
import 'package:cloud_contact/models/contact.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ContactApi {
  static Future<List<Contact>> getAllContacts() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return [];
    }

    final extractedUserData =
        jsonDecode(prefs.getString('userData').toString());
    String userId = extractedUserData['userId'];
    String token = extractedUserData['token'];
    List<Contact> data = [];
    try {
      var url = Uri.parse('$apiUrl/contacts/$userId.json?auth=$token');
      final response = await Dio().getUri(url);
      if (response.data != null && response.data.isNotEmpty) {
        final extractedData = response.data as Map<String, dynamic>;
        if (extractedData.isEmpty) {
          return [];
        }
        extractedData.forEach((key, value) {
          data.add(
            Contact(
              id: key.toString(),
              firstName: value['first_name'].toString(),
              lastName: value['last_name'].toString(),
              phone: value['phone'].toString(),
              email: value['email'].toString(),
              isFavorite: value["is_favorite"] ?? false,
              created: DateTime.parse(
                value["created"].toString(),
              ),
              updated: DateTime.parse(
                value["updated"].toString(),
              ),
            ),
          );
        });
      }
    } catch (e) {
      rethrow;
    }
    return data;
  }

  static Future<Contact?> addContact(Contact contact) async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return null;
    }

    final extractedUserData = jsonDecode(
      prefs.getString('userData').toString(),
    );
    String token = extractedUserData['token'];
    String userId = extractedUserData['userId'];

    final url = Uri.parse('$apiUrl/contacts/$userId.json?auth=$token');
    try {
      final response = await Dio().postUri(
        url,
        data: jsonEncode(
          {
            'first_name': contact.firstName,
            'last_name': contact.lastName,
            'email': contact.email,
            'phone': contact.phone,
            'is_favorite': contact.isFavorite,
            'created': contact.created != null
                ? contact.created!.toIso8601String()
                : DateTime.now().toIso8601String(),
            'updated': contact.updated != null
                ? contact.updated!.toIso8601String()
                : DateTime.now().toIso8601String(),
          },
        ),
      );
      final newContact = Contact(
        id: response.data['name'],
        firstName: contact.firstName,
        lastName: contact.lastName,
        email: contact.email,
        phone: contact.phone,
        isFavorite: contact.isFavorite,
        created: contact.created != null ? contact.created! : DateTime.now(),
        updated: contact.updated != null ? contact.updated! : DateTime.now(),
      );
      return newContact;
    } catch (error) {
      rethrow;
    }
  }

  static Future<bool> updateContact(Contact newContact) async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }

    final extractedUserData = jsonDecode(
      prefs.getString('userData').toString(),
    );
    String token = extractedUserData['token'];
    String userId = extractedUserData['userId'];

    final url =
        Uri.parse('$apiUrl/contacts/$userId/${newContact.id}.json?auth=$token');

    try {
      await Dio().patchUri(
        url,
        data: jsonEncode(
          {
            'first_name': newContact.firstName,
            'last_name': newContact.lastName,
            'email': newContact.email,
            'phone': newContact.phone,
            'is_favorite': newContact.isFavorite,
            'updated': DateTime.now().toIso8601String(),
          },
        ),
      );
      return true;
    } catch (error) {
      rethrow;
    }
  }

  static Future<bool> deleteContact(String id) async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }

    final extractedUserData = jsonDecode(
      prefs.getString('userData').toString(),
    );
    String token = extractedUserData['token'];
    String userId = extractedUserData['userId'];

    final url = Uri.parse('$apiUrl/contacts/$userId/$id.json?auth=$token');

    try {
      await Dio().deleteUri(url);
      return true;
    } catch (error) {
      rethrow;
    }
  }
}
