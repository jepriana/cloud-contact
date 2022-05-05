import 'package:cloud_contact/data/api/contact_api.dart';
import 'package:cloud_contact/models/contact.dart';
import 'package:flutter/foundation.dart';

class ContactViewModel with ChangeNotifier {
  List<Contact> _contacts = [];

  List<Contact> get contacts {
    return [..._contacts];
  }

  Future<void> fetchAndSetContacts() async {
    try {
      final result = await ContactApi.getAllContacts();
      result.sort(
        (a, b) => a.firstName.toString().compareTo(
              b.firstName.toString(),
            ),
      );
      _contacts = result;
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addContact(Contact newContact) async {
    try {
      final result = await ContactApi.addContact(newContact);
      if (result != null) {
        _contacts.add(result);
        _contacts.sort(
          (a, b) => a.firstName.toString().compareTo(
                b.firstName.toString(),
              ),
        );
        notifyListeners();
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateContact(Contact newContact) async {
    final contactIndex =
        _contacts.indexWhere((contact) => contact.id == newContact.id);
    if (contactIndex >= 0) {
      try {
        final result = await ContactApi.updateContact(newContact);
        if (result == true) {
          _contacts[contactIndex] = newContact;
          _contacts.sort(
            (a, b) => a.firstName.toString().compareTo(
                  b.firstName.toString(),
                ),
          );
          notifyListeners();
        }
      } catch (e) {
        rethrow;
      }
    }
  }

  Future<void> deleteContact(String id) async {
    final contactIndex = _contacts.indexWhere((contact) => contact.id == id);
    if (contactIndex >= 0) {
      try {
        final result = await ContactApi.deleteContact(id);
        if (result == true) {
          _contacts.removeAt(contactIndex);
          notifyListeners();
        }
      } catch (e) {
        rethrow;
      }
    }
  }
}
