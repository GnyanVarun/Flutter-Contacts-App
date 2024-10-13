import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myapp/ui/model/contacts_model.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:myapp/data/contact.dart'; // Make sure this path is correct

class ContactForm extends StatefulWidget {
  const ContactForm({super.key, this.editedContact, this.editedContactIndex});

  final Contact? editedContact;
  final int? editedContactIndex;

  @override
  _ContactFormState createState() => _ContactFormState();
}

class _ContactFormState extends State<ContactForm> {
  final _formKey = GlobalKey<FormState>();

  late String _name;
  late String _email;
  late String _phoneNumber;
  File? _contactImageFile;

  @override
  void initState() {
    super.initState();
    if (widget.editedContact != null) {
      _name = widget.editedContact!.name;
      _email = widget.editedContact!.email;
      _phoneNumber = widget.editedContact!.phoneNumber;
      _contactImageFile = widget.editedContact!.imageFile;
    } else {
      _name = '';
      _email = '';
      _phoneNumber = '';
      _contactImageFile = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildContactPicture(),
          const SizedBox(height: 10),
          const SizedBox(height: 20),
          TextFormField(
            initialValue: _name,
            decoration: InputDecoration(
              labelText: 'Name',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.grey, width: 2.0),
                borderRadius: BorderRadius.circular(5.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.green, width: 2.0),
                borderRadius: BorderRadius.circular(5.0),
              ),
            ),
            onSaved: (value) => _name = value!,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your name';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          TextFormField(
            initialValue: _email,
            decoration: InputDecoration(
              labelText: 'Email',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.grey, width: 2.0),
                borderRadius: BorderRadius.circular(5.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.green, width: 2.0),
                borderRadius: BorderRadius.circular(5.0),
              ),
            ),
            onSaved: (value) => _email = value!,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              } else if (!_validateEmail(value)) {
                return 'Please enter a valid email address';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          TextFormField(
            initialValue: _phoneNumber,
            decoration: InputDecoration(
              labelText: 'Phone Number',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.grey, width: 2.0),
                borderRadius: BorderRadius.circular(5.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.green, width: 2.0),
                borderRadius: BorderRadius.circular(5.0),
              ),
            ),
            onSaved: (value) => _phoneNumber = value!,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your phone number';
              } else if (!_validatePhoneNumber(value)) {
                return 'Please enter a valid phone number';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _onSaveContactButtonPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Save Contact',
                  style: TextStyle(color: Colors.black),
                ),
                SizedBox(width: 8),
                Icon(Icons.person, size: 18, color: Colors.black),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _onSaveContactButtonPressed() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final neworEditedContact = Contact(
        id: widget.editedContact?.id,
        name: _name,
        email: _email,
        phoneNumber: _phoneNumber,
        isFavorite: widget.editedContact?.isFavorite ?? false,
        imageFile: _contactImageFile,
      );

      var contactsModel =
          ScopedModel.of<ContactsModel>(context, rebuildOnChange: false);
      if (widget.editedContact != null && widget.editedContactIndex != null) {
        contactsModel.updateContact(neworEditedContact, widget.editedContactIndex!);
      } else {
        contactsModel.addContact(neworEditedContact);
      }

      Navigator.of(context).pop();
    }
  }

  Widget _buildContactPicture() {
    final halfScreenDiameter = MediaQuery.of(context).size.width / 2;
    return Hero(
      tag: widget.editedContact?.hashCode ?? 0,
      child: GestureDetector(
        onTap: _onContactPictureTapped,
        child: CircleAvatar(
          radius: halfScreenDiameter / 2,
          backgroundColor: Colors.green,
          child: _buildCircleAvatarContent(halfScreenDiameter),
        ),
      ),
    );
  }

  void _onContactPictureTapped() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _contactImageFile = File(image.path);
      });
    }
  }

  Widget _buildCircleAvatarContent(double halfScreenDiameter) {
    if (widget.editedContact != null && _contactImageFile == null) {
      return Text(
        widget.editedContact!.name[0].toUpperCase(),
        style: TextStyle(
          fontSize: halfScreenDiameter / 2.5,
          color: Colors.black,
        ),
      );
    } else if (_contactImageFile != null) {
      return ClipOval(
        child: Image.file(
          _contactImageFile!,
          fit: BoxFit.cover,
          width: halfScreenDiameter,
          height: halfScreenDiameter,
        ),
      );
    } else {
      return Icon(
        Icons.person,
        size: halfScreenDiameter / 2.5,
        color: Colors.black,
      );
    }
  }

  bool _validateEmail(String value) {
    final emailRegex =
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return emailRegex.hasMatch(value);
  }

  bool _validatePhoneNumber(String value) {
    final phoneRegex = RegExp(r'^[0-9]{10}$');
    return phoneRegex.hasMatch(value);
  }
}
