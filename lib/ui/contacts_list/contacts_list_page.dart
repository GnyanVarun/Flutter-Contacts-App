// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:myapp/ui/contact/contact_create_page.dart';
//import 'package:faker/faker.dart';
//import 'package:myapp/data/contact.dart';
import 'package:myapp/ui/contacts_list/widget/contact_tile.dart';
import 'package:scoped_model/scoped_model.dart';

import '../model/contacts_model.dart';

class ContactsListPage extends StatefulWidget {
  const ContactsListPage({super.key});

  @override
  State<ContactsListPage> createState() => _ContactsListPageState();
}

class _ContactsListPageState extends State<ContactsListPage> {
  /* void _sortContacts() {
    setState(() {
      _contacts.sort((a, b) {
        if (a.isFavorite && !b.isFavorite) {
          return -1;
        } else if (!a.isFavorite && b.isFavorite) {
          return 1;
        } else {
          return 0;
        }
      });
    });
  } */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contacts'),
        backgroundColor: Colors.green,
        /* actions: [
          IconButton(
            icon: const Icon(Icons.sort),
            onPressed: _sortContacts,
          ),
        ],
      ),*/
      ),
      body: ScopedModelDescendant<ContactsModel>(
          builder: (context, child, model) {
        if (model.isLoading) {
          return Center(child: CircularProgressIndicator(),
           );
        }
        else {
            return ListView.builder(
          itemCount: model.contacts.length,
          itemBuilder: (context, index) {
            // final contact = _contacts[index];
            return ContactTile(
              contactIndex: index,
            );
          },
        );
        }
        
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => const ContactCreatePage(),
            ),
          );
        },
        backgroundColor: Colors.green,
        child: const Icon(Icons.person_add),
      ),
    );
  }
}
