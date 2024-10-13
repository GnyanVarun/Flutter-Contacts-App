import 'package:flutter/material.dart';
import 'package:myapp/data/contact.dart';
import 'package:myapp/ui/contact/widget/contact_form.dart';

class ContactEditPage extends StatelessWidget {
  const ContactEditPage({
    super.key,
    required this.editedContact, required this.editedContactIndex,
    //required this.editedContactIndex,
  });

  final Contact editedContact;
  final int editedContactIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Contact'),
        backgroundColor: Colors.green,
      ),
      body: ContactForm(
        editedContact: editedContact,
        editedContactIndex: editedContactIndex,
      ),
    );
  }
} 