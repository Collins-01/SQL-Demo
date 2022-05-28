import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sql_demo/core/models/dog_model.dart';

class DogDB {
  DogDB._();
  static final DogDB _intsance = DogDB._();
  factory DogDB() => _intsance;
  late Database _database;
  Database get database => _database;
  init() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), "doggie_database.db"),
      onCreate: (db, version) => db.execute(
        'CREATE TABLE dogs(id INTEGER PRIMARY KEY, name TEXT, age INTEGER)',
      ),
      version: 1,
    );
  }

  Future<void> insertDog(Dog dog) async {
    await _database.insert(
      "dogs",
      dog.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Dog>> getDogs() async {
    final List<Map<String, dynamic>> data = await _database.query('dogs');
    return data.map((e) => Dog.fromJson(e)).toList();
  }

  Future<void> updateDogs(Dog dog) async {
    await _database.update(
      'dogs',
      dog.toJson(),
      where: 'id = ?',
      whereArgs: [
        dog.id,
      ],
    );
  }

  Future<void> deleteDog(int id) async {
    await _database.delete(
      'dogs',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
