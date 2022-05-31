import 'package:sql_demo/core/models/user_model.dart';

class AuthService {
  static User _user = User(id: 21, name: "Oriakhi Collind");
  static User get user => _user;
}
