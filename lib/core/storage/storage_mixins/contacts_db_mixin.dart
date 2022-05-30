import 'package:sqlbrite/sqlbrite.dart';

mixin ContactsDBMixin {
  late Database _database;
  onInitContacts(Database db) async {
    this._database = db;
    _database = await openDatabase(
      'dogs',
      onCreate: (db, version) => db.execute(
        'CREATE TABLE contacts(id INTEGER PRIMARY KEY, name TEXT)',
      ),
      version: 1,
    );
  }
}
