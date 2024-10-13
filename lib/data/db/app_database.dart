import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';

class AppDatabase {
  Completer<Database>? _dbOpenCompleter;

  // A private constructor.
  AppDatabase._();

  // Singleton instance
  static final AppDatabase _singleton = AppDatabase._();

  // Factory constructor
  static AppDatabase get instance => _singleton;

  // Database getter
  Future<Database> get database async {
    // If completer is null, then database is not yet opened.
    if (_dbOpenCompleter == null) {
      _dbOpenCompleter = Completer();
      // Calling _openDatabase will also complete the completer with database instance.
      await _openDatabase();
    }
    // If the database is already opened, return immediately.
    // Otherwise, wait until complete() is called on the Completer in _openDatabase()
    return _dbOpenCompleter!.future;
  }

  // Open database and complete the completer.
  Future<void> _openDatabase() async {
    // Get a platform-specific directory where persistent app data can be stored
    final appDocumentDir = await getApplicationDocumentsDirectory();
    // Path with the form: /platform-specific-directory/contacts.db
    final dbPath = join(appDocumentDir.path, 'contacts.db');
    final database = await databaseFactoryIo.openDatabase(dbPath);
    _dbOpenCompleter!.complete(database);
  }
}
