import 'dart:developer';
import 'package:sql_demo/core/storage/db_keys.dart';
import 'package:sqlbrite/sqlbrite.dart';

late BriteDatabase _briteDb;

class MessagesDB {
  MessagesDB._();
  static final MessagesDB _instance = MessagesDB._();
  factory MessagesDB() => _instance;
  init() async {
    final Database db = await openDatabase(
      'dogs',
      onCreate: (db, version) => db.execute(
        'CREATE TABLE ${DbKeys.messages}(id INTEGER PRIMARY KEY, msg TEXT, to INTEGER)',
      ),
      version: 1,
    );
    _briteDb = BriteDatabase(
      db,
      logger: (v) {
        log("....DB<Messages>: $v");
      },
    );
  }
}
//  final String msg;
//   final String from;
//   final String to;
//   final String id;    


