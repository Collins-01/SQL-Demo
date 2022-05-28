import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:sql_demo/core/models/dog_model.dart';
import 'package:sql_demo/core/storage/dog_db.dart';

class DogView extends StatelessWidget {
  DogView({Key? key}) : super(key: key);
  final DogDB _dogDB = DogDB();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () async {
                await _dogDB.insertDog(Dog(age: 34, id: 2, name: "Jeff"));
              },
              child: const Text("add"),
            ),
            TextButton(
              onPressed: () async {
                var dogs = await _dogDB.getDogs();
                log("Dogs -> $dogs");
              },
              child: const Text("fetch"),
            ),
            TextButton(
              onPressed: () async {
                await _dogDB.deleteDog(1);
                var dogs = await _dogDB.getDogs();
                log("Dogs -> $dogs");
              },
              child: const Text("delete"),
            ),
            TextButton(
              onPressed: () async {
                await _dogDB.updateDogs(
                  Dog(age: 5, id: 1, name: "Jack"),
                );
                var dogs = await _dogDB.getDogs();
                log("Dogs -> $dogs");
              },
              child: const Text("update"),
            ),
          ],
        ),
      ),
    );
  }
}
