import 'package:flutter/material.dart';
import 'package:sql_demo/core/models/dog_model.dart';
import 'package:sql_demo/core/models/message_model.dart';
import 'package:sql_demo/core/storage/dog_brite_db.dart';
import 'package:sql_demo/core/storage/messages_db.dart';

// ignore: use_key_in_widget_constructors
class MessagesView extends StatefulWidget {
  @override
  State<MessagesView> createState() => _MessagesViewState();
}

class _MessagesViewState extends State<MessagesView> {
  final DogBriteDB _dogBriteDB = DogBriteDB();
  @override
  void initState() {
    MessagesDB().getAllMessages();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
                child: StreamBuilder<List<Message>>(
              initialData: [],
              stream: MessagesDB().getAllMessages(),
              builder: (_, snapshot) {
                return snapshot.data == null
                    ? const Text("Null Data")
                    : ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          if (snapshot.hasData) {
                            return Center(
                              child: Text(snapshot.data![index].msg +
                                  "  " +
                                  snapshot.data![index].id.toString() +
                                  "  "),
                            );
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
                    await MessagesDB().sendMessage(
                      Message(
                        id: 3,
                        msg: "Trust your night was good cuz?",
                        recieverID: 1,
                        senderID: 2,
                      ),
                    );
                  },
                  child: const Text("Send"),
                ),
                TextButton(
                  onPressed: () async {
                    await _dogBriteDB
                        .updateDog(Dog(age: 10, id: 2, name: "Jeff"));
                  },
                  child: const Text("Edit"),
                ),
                TextButton(
                  onPressed: () async {
                    await _dogBriteDB.deletDog(3);
                  },
                  child: const Text("Delete"),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
