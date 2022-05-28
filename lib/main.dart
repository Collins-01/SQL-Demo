import 'package:flutter/material.dart';
import 'package:sql_demo/UIs/dog_view.dart';
import 'package:sql_demo/core/storage/dog_db.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  DogDB().init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: DogView());
  }
}
