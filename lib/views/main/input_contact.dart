import 'package:cloud_contact/models/contact.dart';
import 'package:cloud_contact/res/dimmentions.dart';
import 'package:cloud_contact/res/strings.dart';
import 'package:cloud_contact/view_model/contact_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InputContact extends StatefulWidget {
  static const String routName = '/contact/add';
  final Contact? contact;
  const InputContact({
    Key? key,
    this.contact,
  }) : super(key: key);

  @override
  State<InputContact> createState() => _InputContactState();
}

class _InputContactState extends State<InputContact> {
  final _ctrlFirstName = TextEditingController();
  final _ctrlLastName = TextEditingController();
  final _ctrlEmail = TextEditingController();
  final _ctrlPhone = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.contact != null) {
      final data = widget.contact!;
      _ctrlFirstName.text = data.firstName ?? '';
      _ctrlLastName.text = data.lastName ?? '';
      _ctrlEmail.text = data.email ?? '';
      _ctrlPhone.text = data.phone ?? '';
    }
  }

  Future<void> _submitData() async {
    if (_ctrlFirstName.text.isEmpty ||
        _ctrlLastName.text.isEmpty ||
        _ctrlEmail.text.isEmpty ||
        _ctrlPhone.text.isEmpty) {
      return;
    }

    final firstName = _ctrlFirstName.text;
    final lastName = _ctrlLastName.text;
    final email = _ctrlEmail.text;
    final phone = _ctrlPhone.text;

    try {
      if (widget.contact != null) {
        final data = widget.contact!;
        final updatedContact = Contact(
          id: data.id,
          firstName: firstName,
          lastName: lastName,
          phone: phone,
          email: email,
          isFavorite: data.isFavorite,
          created: data.created,
          updated: DateTime.now(),
        );

        await Provider.of<ContactViewModel>(context, listen: false)
            .updateContact(updatedContact);
      } else {
        final newContact = Contact(
            firstName: firstName,
            lastName: lastName,
            phone: phone,
            email: email);

        await Provider.of<ContactViewModel>(context, listen: false)
            .addContact(newContact);
      }
    } catch (error) {
      await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('An error occurred!'),
          content: Text(
            'Something went wrong. ${error.toString()}',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Close'),
            ),
          ],
        ),
      );
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Contact'),
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(
            Icons.arrow_back_ios_new,
          ),
        ),
        actions: [
          IconButton(
            onPressed: _submitData,
            icon: const Icon(
              Icons.save_rounded,
            ),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(
              extraLarge,
            ),
            topRight: Radius.circular(
              extraLarge,
            ),
          ),
        ),
        width: double.infinity,
        padding: const EdgeInsets.only(
          top: 20,
          left: large,
          right: large,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.max,
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'First Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(large),
                  ),
                ),
                prefixIcon: Icon(Icons.person_add),
              ),
              controller: _ctrlFirstName,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(
              height: large,
            ),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Last Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(large),
                  ),
                ),
                prefixIcon: Icon(Icons.person_add_alt_rounded),
              ),
              controller: _ctrlLastName,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(
              height: large,
            ),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Email address',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(large),
                  ),
                ),
                prefixIcon: Icon(Icons.email_rounded),
              ),
              controller: _ctrlEmail,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(
              height: large,
            ),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Phone number',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(large),
                  ),
                ),
                prefixIcon: Icon(Icons.phone_android_rounded),
              ),
              controller: _ctrlPhone,
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _submitData(),
            ),
            const SizedBox(
              height: large,
            ),
          ],
        ),
      ),
    );
  }
}
