import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:sql_demo/core/models/contact_model.dart';
import 'package:sql_demo/core/models/message_model.dart';
import 'package:sql_demo/core/storage/db_keys.dart';
import 'package:sqlbrite/sqlbrite.dart';

Future<Database> _init() async {
  BriteDatabase? _briteDb;
  final Database db = await openDatabase(
    'contacts_database.db',
    onCreate: (db, version) => db.execute(
      'CREATE TABLE ${DbKeys.contacts}(id INTEGER PRIMARY KEY, name TEXT)',
    ),
    version: 1,
  );
  _briteDb = BriteDatabase(
    db,
    logger: (v) {
      log("....DB<Contacts>: $v");
    },
  );
  return _briteDb;
}

class ContactsDB {
  ContactsDB._();
  static final ContactsDB _instance = ContactsDB._();
  factory ContactsDB() => _instance;
  final _dbFuture = _init()
      .then((db) => BriteDatabase(db, logger: kReleaseMode ? null : print));

  Stream<List<Contact>> getAllContacts() async* {
    final db = await _dbFuture;
    yield* db
        .createQuery(DbKeys.contacts)
        .asBroadcastStream()
        .mapToList((json) => Contact.fromJson(json));
  }

  Future<bool> addContact(Contact contact) async {
    final db = await _dbFuture;
    final id = await db.insert(
      DbKeys.contacts,
      contact.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return id != -1;
  }
}
//  final String msg;
//   final String from;
//   final String to;
//   final String id;    


