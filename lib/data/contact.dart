import 'dart:io';

class Contact {
  int? id;
  late String name;
  late String email;
  late String phoneNumber;
  bool isFavorite;
  File? imageFile;

  Contact({
    this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
    this.isFavorite = false,
    this.imageFile,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'isFavorite': isFavorite ? 1 : 0,
      'imageFilePath': imageFile?.path,
    };
  }

  static Contact fromMap(Map<String, dynamic> map) {
    return Contact(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      phoneNumber: map['phoneNumber'],
      isFavorite: map['isFavorite'] == 1 ? true : false,
      imageFile: map['imageFilePath'] != null ? File(map['imageFilePath']) : null,
    );
  }
}
