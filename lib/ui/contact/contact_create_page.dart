import 'package:flutter/material.dart';
import 'package:myapp/ui/contact/widget/contact_form.dart';


class ContactCreatePage extends StatelessWidget {
  const ContactCreatePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create'),
      backgroundColor: Colors.green,
      ),
      body: const ContactForm(),
    );
  }
}