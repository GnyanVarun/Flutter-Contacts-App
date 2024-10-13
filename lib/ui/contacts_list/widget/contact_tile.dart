// ignore_for_file: deprecated_member_use, duplicate_ignore

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:myapp/data/contact.dart';
import 'package:myapp/ui/contact/contact_edit_page.dart';
import 'package:myapp/ui/model/contacts_model.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactTile extends StatelessWidget {
  final int contactIndex;

  const ContactTile({
    super.key,
    required this.contactIndex,
  });

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<ContactsModel>(
      builder: (context, child, model) {
        final displayedContact = model.contacts[contactIndex];
        return Slidable(
          key: ValueKey(displayedContact.id),
          startActionPane: ActionPane(
            motion: const ScrollMotion(),
            children: [
              SlidableAction(
                onPressed: (context) {
                  _callPhoneNumber(context, displayedContact.phoneNumber);
                },
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                icon: Icons.phone,
                label: 'Call',
              ),
              SlidableAction(
                onPressed: (context) {
                  // Uncomment and implement the email action if needed
                  _sendEmail(context, displayedContact.email);
                },
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                icon: Icons.mail,
                label: 'Email',
              ),
            ],
          ),
          endActionPane: ActionPane(
            motion: const ScrollMotion(),
            children: [
              SlidableAction(
                onPressed: (context) {
                  model.removeContact(contactIndex);
                },
                backgroundColor: Colors.red,
                foregroundColor: Colors.black,
                icon: Icons.delete,
                label: 'Delete',
              ),
            ],
          ),
          child: ListTile(
            title: Text(displayedContact.name),
            subtitle: Text(displayedContact.email),
            leading: _buildCircleAvatar(displayedContact),
            trailing: IconButton(
              icon: Icon(
                displayedContact.isFavorite ? Icons.star : Icons.star_border,
                color: displayedContact.isFavorite ? Colors.green : null,
              ),
              onPressed: () {
                model.changeFavoriteStatus(contactIndex);
              },
            ),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => ContactEditPage(
                    editedContact: displayedContact,
                    editedContactIndex: contactIndex,
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Hero _buildCircleAvatar(Contact displayedContact) {
    return Hero(
      tag: displayedContact.hashCode,
      child: CircleAvatar(
        backgroundColor: Colors.green,
        child: _buildCircleAvatarContent(displayedContact),
      ),
    );
  }

  Widget _buildCircleAvatarContent(Contact displayedContact) {
    if (displayedContact.imageFile == null) {
      return Text(
        displayedContact.name[0].toUpperCase(),
        style: const TextStyle(
          fontSize: 20,
          color: Colors.black,
        ),
      );
    } else {
      return ClipOval(
        child: Image.file(
          displayedContact.imageFile!,
          fit: BoxFit.cover,
          width: 40,
          height: 40,
        ),
      );
    }
  }

  Future _callPhoneNumber(BuildContext context, String number) async {
    final url = 'tel:$number';
    // ignore: deprecated_member_use
    if (await canLaunch(url)) {
      // ignore: deprecated_member_use
      await launch(url);
    } else {
      final snackbar = SnackBar(
        content: const Text('Cannot make a call'),
        action: SnackBarAction(
          label: 'Ok',
          onPressed: () {},
        ),
        duration: const Duration(seconds: 3),
      );
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
    }
  }

  // Uncomment and implement the email action if needed

  Future _sendEmail(BuildContext context, String email) async {
    final url = 'mailto:$email';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      final snackbar = SnackBar(
        content: const Text('Cannot send email'),
        action: SnackBarAction(
          label: 'Ok',
          onPressed: () {},
        ),
        duration: const Duration(seconds: 3),
      );
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
    }
  }
}
