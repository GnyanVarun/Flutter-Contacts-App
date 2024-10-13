import 'package:sembast/sembast.dart';
import 'package:myapp/data/contact.dart';
import 'package:myapp/data/db/app_database.dart';

class ContactDao {
  // ignore: constant_identifier_names
  static const String CONTACT_STORE_NAME = 'contacts';
  final _contactStore = intMapStoreFactory.store(CONTACT_STORE_NAME);

  Future<List<Contact>> getAllInSortedOrder() async {
    final finder = Finder(
      sortOrders: [
        SortOrder('isFavorite', false), // false for descending order
        SortOrder('name', true), // true for ascending order
      ],
    );
    final recordSnapshots = await _contactStore.find(
      await AppDatabase.instance.database,
      finder: finder,
    );

    return recordSnapshots.map((snapshot) {
      final contact = Contact.fromMap(snapshot.value);
      contact.id = snapshot.key;
      return contact;
    }).toList();
  }

  Future insert(Contact contact) async {
    await _contactStore.add(
      await AppDatabase.instance.database,
      contact.toMap(),
    );
  }

  Future update(Contact contact) async {
    final finder = Finder(filter: Filter.byKey(contact.id));
    await _contactStore.update(
      await AppDatabase.instance.database,
      contact.toMap(),
      finder: finder,
    );
  }

  Future delete(int id) async {
    final finder = Finder(filter: Filter.byKey(id));
    await _contactStore.delete(
      await AppDatabase.instance.database,
      finder: finder,
    );
  }
}
