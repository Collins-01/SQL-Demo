import 'dart:async';
import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:sql_demo/core/models/message_model.dart';
import 'package:sql_demo/core/storage/db_keys.dart';
import 'package:sqlbrite/sqlbrite.dart';

Future<Database> _init() async {
  BriteDatabase? _briteDb;
  final Database db = await openDatabase(
    'messages_database.db',
    onCreate: (db, version) => db.execute(
      'CREATE TABLE ${DbKeys.messages}(id INTEGER PRIMARY KEY, msg TEXT, recieverID INTEGER, senderID INTEGER)',
    ),
    version: 1,
  );
  _briteDb = BriteDatabase(
    db,
    logger: (v) {
      log("....DB<Messages>: $v");
    },
  );
  return _briteDb;
}

class MessagesDB {
  MessagesDB._();
  static final MessagesDB _instance = MessagesDB._();
  factory MessagesDB() => _instance;
  final _dbFuture = _init()
      .then((db) => BriteDatabase(db, logger: kReleaseMode ? null : print));

  Stream<List<Message>> getAllMessages() async* {
    final db = await _dbFuture;
    yield* db
        .createQuery(DbKeys.messages)
        .asBroadcastStream()
        .mapToList((json) => Message.fromJson(json));
    // .map((items) =>
    //     items.where((i) => i.id != null).toList(growable: false));
  }

  final StreamController<Message?> _lastMessageStreamController =
      StreamController.broadcast();
  StreamController<Message?> get lastMessageStreamController =>
      _lastMessageStreamController;
  Stream<Message?> getMessageForUser(int recieverID) async* {
    final db = await _dbFuture;
    var res = db.createQuery(
      DbKeys.messages,
      where: 'recieverID = ?',
      whereArgs: [recieverID],
    );

    if (await res.isEmpty) {
      yield null;
    } else {
      // yield db.createQuery(
      //   DbKeys.messages,
      //   where: 'recieverID = ?',
      //   whereArgs: [recieverID],
      // ).mapToList(
      //   (json) => Message.fromJson(json),
      // ).last.asStream();
      var a = res.asBroadcastStream().mapToOne((row) => Message.fromJson(row));

      a.listen((event) {
        log(event.msg);
      });
      yield* a;
    }

    // .map((items) =>
    //     items.where((i) => i.id != null).toList(growable: false));
  }

  getLastMessage(int id) async {
    final db = await _dbFuture;
    var res = db.createQuery(
      DbKeys.messages,
      where: 'recieverID = ?',
      whereArgs: [id],
    );
    if (await res.isEmpty) {
      _lastMessageStreamController.sink.add(null);
    } else {
      var a = res.asBroadcastStream().mapToOne((row) => Message.fromJson(row));
      _lastMessageStreamController.sink.addStream(a);
    }
  }

  Future<bool> sendMessage(Message message) async {
    // if (message.id != null) {
    //   throw StateError('Message.id must be null');
    // }

    final db = await _dbFuture;
    final id = await db.insert(
      DbKeys.messages,
      message.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return id != -1;
  }
}
//  final String msg;
//   final String from;
//   final String to;
//   final String id;    


