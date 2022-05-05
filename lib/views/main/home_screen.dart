import 'package:cloud_contact/res/dimmentions.dart';
import 'package:cloud_contact/view_model/contact_view_model.dart';
import 'package:cloud_contact/views/main/input_contact.dart';
import 'package:cloud_contact/widgets/contact_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isInit = true;

  @override
  void didChangeDependencies() {
    if (isInit == true) {
      Provider.of<ContactViewModel>(context, listen: false)
          .fetchAndSetContacts();
      isInit = false;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final contacts = Provider.of<ContactViewModel>(context).contacts;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cloud Contact'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(InputContact.routName);
            },
            icon: const Icon(
              Icons.add_rounded,
            ),
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.only(top: small),
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
        child: ListView.separated(
          itemBuilder: (context, index) => ContactItem(
            contacts[index],
            key: Key(
              contacts[index].id.toString(),
            ),
          ),
          separatorBuilder: (context, index) => const Divider(
            indent: large,
            endIndent: large,
          ),
          itemCount: contacts.length,
        ),
      ),
    );
  }
}
