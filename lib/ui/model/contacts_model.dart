import 'package:scoped_model/scoped_model.dart';
import 'package:myapp/data/contact.dart';
import 'package:myapp/data/db/contact_dao.dart';

class ContactsModel extends Model {
  final ContactDao _contactDao = ContactDao();
  List<Contact> _contacts = [];
  bool _isLoading = true;

  bool get isLoading => _isLoading;
  List<Contact> get contacts => List.unmodifiable(_contacts);

  void addContact(Contact contact) async {
    await _contactDao.insert(contact);
    _contacts = await _contactDao.getAllInSortedOrder();
    notifyListeners();
  }

  void updateContact(Contact contact, int contactIndex) async {
    await _contactDao.update(contact);
    _contacts = await _contactDao.getAllInSortedOrder();
    notifyListeners();
  }

  void changeFavoriteStatus(int index) async {
    _contacts[index].isFavorite = !_contacts[index].isFavorite;
    await _contactDao.update(_contacts[index]);
    _contacts = await _contactDao.getAllInSortedOrder();
    notifyListeners();
  }

  Future<void> loadContacts() async {
    _isLoading = true;
    notifyListeners();
    _contacts = await _contactDao.getAllInSortedOrder();
    _isLoading = false;
    notifyListeners();
  }

  void removeContact(int contactIndex) async {
    final contact = _contacts[contactIndex];
    await _contactDao.delete(contact.id!);
    _contacts = await _contactDao.getAllInSortedOrder();
    notifyListeners();
  }
}
