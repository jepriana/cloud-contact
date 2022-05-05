import 'package:cloud_contact/models/contact.dart';
import 'package:cloud_contact/res/colors.dart';
import 'package:cloud_contact/view_model/contact_view_model.dart';
import 'package:cloud_contact/views/main/input_contact.dart';
import 'package:cloud_contact/widgets/message_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ContactItem extends StatelessWidget {
  final Contact data;
  const ContactItem(this.data, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        child: Text(
          data.firstName.toString()[0].toUpperCase(),
        ),
        backgroundColor: primaryColor,
        foregroundColor: primaryBackgroundColor,
      ),
      title: Text(
        data.getFullName(),
      ),
      subtitle: Text(data.phone.toString()),
      trailing: IconButton(
        icon: data.isFavorite
            ? const Icon(
                Icons.favorite_rounded,
                color: Colors.red,
              )
            : const Icon(Icons.favorite_outline_rounded),
        onPressed: () {
          data.isFavorite = !data.isFavorite;
          Provider.of<ContactViewModel>(context, listen: false)
              .updateContact(data);
        },
      ),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (ctx) => InputContact(
              contact: data,
            ),
          ),
        );
      },
      onLongPress: () {
        MessageDialog.showMessageDialog(context, 'Delete Contact',
            'Are you sure to delete contact?', 'Sure', () {
          Provider.of<ContactViewModel>(
            context,
            listen: false,
          ).deleteContact(
            data.id.toString(),
          );
        });
      },
    );
  }
}
