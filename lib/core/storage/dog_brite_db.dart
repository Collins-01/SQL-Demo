import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:sql_demo/core/models/dog_model.dart';
import 'package:sqlbrite/sqlbrite.dart';

late BriteDatabase _briteDb;

class DogBriteDB extends ChangeNotifier {
  DogBriteDB._();
  static final DogBriteDB _instance = DogBriteDB._();
  factory DogBriteDB() => _instance;
  Stream<List<Dog>> _dogsList = const Stream.empty();
  Stream<List<Dog>> get dogsList => _dogsList;
  Future<void> init() async {
    final Database db = await openDatabase(
      'dogs',
      onCreate: (db, version) => db.execute(
        'CREATE TABLE dogs(id INTEGER PRIMARY KEY, name TEXT, age INTEGER)',
      ),
      version: 1,
    );
    _briteDb = BriteDatabase(
      db,
      logger: (v) {
        log("....DB: $v");
      },
    );
    _dogsList = _briteDb
        .createQuery('dogs')
        .mapToList((row) => Dog.fromJson(row))
        .asBroadcastStream();

    notifyListeners();
  }

  Future<void> insertDog(Dog dog) async {
    await _briteDb.insert(
      'dogs',
      dog.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deletDog(int id) async {
    await _briteDb.delete(
      'dogs',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> updateDog(Dog dog) async {
    await _briteDb
        .update('dogs', dog.toJson(), where: 'id = ?', whereArgs: [dog.id]);
  }

  Future<void> getSingleDog(int id) async {
    var res = _briteDb
        .createQuery(
          'dogs',
          limit: 1,
          where: 'id = ?',
          whereArgs: [id],
        )
        .asBroadcastStream()
        .mapToOne(
          (row) => Dog.fromJson(row),
        );
    res.listen((e) {
      log("Single Item : $e");
    });
  }
}
