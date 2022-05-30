import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart';
import 'package:sql_demo/core/models/contact_model.dart';
import 'package:sql_demo/core/models/message_model.dart';
import 'package:sql_demo/core/storage/db_keys.dart';
import 'package:sql_demo/core/storage/storage_mixins/chats_db_mixins.dart';
import 'package:sql_demo/core/storage/storage_mixins/contacts_db_mixin.dart';
import 'package:sqlbrite/sqlbrite.dart';

BriteDatabase? _briteDb;

class ChatsDB extends ChangeNotifier with ChatsDBMixin, ContactsDBMixin {
  ChatsDB._();
  static final ChatsDB _instance = ChatsDB._();
  factory ChatsDB() => _instance;
  Stream<List<Contact>> _contacts = _briteDb == null
      ? const Stream.empty()
      : _briteDb!
          .createQuery(DbKeys.contacts)
          .mapToList((row) => Contact.fromJson(row))
          .asBroadcastStream();
  Stream<List<Contact>> get contacts => _contacts;
  Stream<List<Message>> _messages = const Stream.empty();
  Stream<List<Message>> get messages => _messages;

  Future<void> init() async {
    final db = await openDatabase(
      join(await getDatabasesPath(), "contacts_database.db"),
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
    _contacts = _briteDb!
        .createQuery(DbKeys.contacts)
        .mapToList((row) => Contact.fromJson(row))
        .asBroadcastStream();
    notifyListeners();
    // _briteDb
    //     .createQuery(DbKeys.contacts)
    //     .mapToList((row) => Contact.fromJson(row))
    //     .asBroadcastStream()
    //     .listen((event) {
    //   log("Changed Contacts : ${event.toList().toString()}");
    // });
    log("Initialised: ${_briteDb?.isOpen.toString()}");
  }

  Future<void> createContactI() async {
    Contact contact = Contact(
      name: getRandomString(8),
      id: DateTime.now().microsecondsSinceEpoch,
    );
    log(contact.toJson().toString());
    await _briteDb?.insert(
      DbKeys.contacts,
      contact.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}

final chatsDb = Provider((ref) => ChatsDB());


// *Tables
// contacts
// messages