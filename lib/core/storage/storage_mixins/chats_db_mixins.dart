import 'package:sql_demo/core/models/contact_model.dart';
import 'package:sqlbrite/sqlbrite.dart';
import 'dart:math';

mixin ChatsDBMixin {
  final _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  final Random _rnd = Random();

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  // Future<void> createContact(BriteDatabase db) async {
  //   Contact contact = Contact(name: _getRandomString(8), id: 03);
  //   await db.insert(
  //     'contacts',
  //     contact.toJson(),
  //     conflictAlgorithm: ConflictAlgorithm.replace,
  //   );
  // }
}
