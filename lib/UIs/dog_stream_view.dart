import 'package:flutter/material.dart';
import 'package:sql_demo/core/models/dog_model.dart';
import 'package:sql_demo/core/storage/dog_brite_db.dart';

// ignore: use_key_in_widget_constructors
class DogStreamView extends StatelessWidget {
  final DogBriteDB _dogBriteDB = DogBriteDB();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
                child: StreamBuilder<List<Dog>>(
              stream: _dogBriteDB.dogsList,
              builder: (_, snapshot) {
                return snapshot.data == null
                    ? const Text("Null Data")
                    : ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          if (snapshot.hasData) {
                            return Text(snapshot.data![index].name +
                                "  " +
                                snapshot.data![index].age.toString() +
                                "  " +
                                snapshot.data![index].id.toString());
                          }
                          return Text(snapshot.connectionState.toString());
                        });
              },
            )),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () async {
                    await _dogBriteDB
                        .insertDog(Dog(age: 2, id: 002, name: "Milo"));
                  },
                  child: const Text("Add Dog"),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text("Update Dog"),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text("Delete Dog"),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
