import 'dart:developer';

import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:sql_demo/UIs/chat_view.dart';
import 'package:sql_demo/core/models/contact_model.dart';

import 'package:sql_demo/core/models/message_model.dart';
import 'package:sql_demo/core/storage/contacts_db.dart';

import 'package:sql_demo/core/storage/messages_db.dart';

// ignore: use_key_in_widget_constructors
class ContactsView extends StatefulWidget {
  @override
  State<ContactsView> createState() => _ContactsViewState();
}

class _ContactsViewState extends State<ContactsView> {
  @override
  void initState() {
    ContactsDB().getAllContacts();
    // MessagesDB().getAllMessages();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Contacts"),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
                child: StreamBuilder<List<Contact>>(
              initialData: [],
              stream: ContactsDB().getAllContacts(),
              builder: (_, snapshot) {
                return snapshot.data == null
                    ? const Text("Null Data")
                    : ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          if (snapshot.hasData) {
                            return ListTile(
                              onTap: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => ChatView(
                                    contact: snapshot.data![index],
                                  ),
                                ),
                              ),
                              leading:
                                  Text(snapshot.data![index].id.toString()),
                              title: Text(snapshot.data![index].name),
                              subtitle: BuildMessageText(
                                  recieverID: snapshot.data![index].id),
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
                    Faker faker = Faker();
                    Message message = Message(
                        id: 4,
                        msg: faker.lorem.word(),
                        recieverID: 2,
                        senderID: 1);
                    await MessagesDB().sendMessage(message);
                    log(message.toJson().toString());
                  },
                  child: const Text("Msg"),
                ),
                TextButton(
                  onPressed: () async {
                    Faker faker = Faker();
                    Contact contact = Contact(name: faker.person.name(), id: 5);
                    await ContactsDB().addContact(contact);
                  },
                  child: const Text("Add"),
                ),
                TextButton(
                  onPressed: () async {},
                  child: const Text("Edit"),
                ),
                TextButton(
                  onPressed: () async {},
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

class BuildMessageText extends StatefulWidget {
  final int recieverID;
  const BuildMessageText({Key? key, required this.recieverID})
      : super(key: key);

  @override
  State<BuildMessageText> createState() => _BuildMessageTextState();
}

class _BuildMessageTextState extends State<BuildMessageText> {
  @override
  void initState() {
    // MessagesDB().getLastMessage(widget.recieverID);
    // MessagesDB().lastMessageStreamController.stream.listen((event) {
    //   log("Data ---------${event?.msg} ");
    // });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Text("No Msg");
    // return StreamBuilder<Message?>(
    //   stream: MessagesDB().getMessageForUser(widget.recieverID),
    //   builder: (_, snapshot) {
    //     log("Build Method ");
    //     if (snapshot.data == null) {
    //       return Text("No Last Message");
    //     }
    //     return Text(snapshot.data!.msg);
    //   },
    // );
  }
}
