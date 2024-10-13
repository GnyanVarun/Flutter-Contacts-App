import 'package:flutter/material.dart';
import 'package:myapp/ui/contacts_list/contacts_list_page.dart';
//import 'package:myapp/ui/contacts_list/contacts_list_page.dart';
import 'package:myapp/ui/model/contacts_model.dart';
import 'package:scoped_model/scoped_model.dart';

//import 'ui/contact/contact_create_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScopedModel(
      model: ContactsModel()..loadContacts(),
      child: MaterialApp(
        title: 'Contacts',
        theme: ThemeData(
          primaryColor: Colors.green,
        ),
// Suggested code may be subject to a license. Learn more: ~LicenseLog:1500547453.
        home: const ContactsListPage(),
      ),
    );
  }
}
