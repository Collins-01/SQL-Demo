import 'dart:async';
import 'dart:developer';

import 'package:sql_demo/core/models/dog_model.dart';
import 'package:sqlbrite/sqlbrite.dart';

late BriteDatabase _briteDb;
final StreamController<List<Dog>> _dogsController =
    StreamController<List<Dog>>();

class DogBriteDB {
  final Stream<List<Dog>> _dogsList = _dogsController.stream;
  Stream<List<Dog>> get dogsList => _dogsList;
  Future<void> init() async {
    final Database db = await openDatabase(
      'dogs',
    );
    _briteDb = BriteDatabase(
      db,
      logger: (v) {
        log("....DB: $v");
      },
    );
    _briteDb
        .createQuery('dogs')
        .mapToList((row) => Dog.fromJson(row))
        .asBroadcastStream(
      onCancel: (value) {
        log("Stream has cancelled .... $value");
      },
      onListen: (val) {
        val.onData((data) {
          _dogsController.sink.add(data);
        });
      },
    );
  }

  Future<void> insertDog(Dog dog) async {
    await _briteDb.insert('dogs', dog.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> deletDog(int id) async {
    await _briteDb.delete(
      'dogs',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> updateDog(int id) async {
    await _briteDb.delete(
      'dogs',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
