import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:sql_demo/core/models/contact_model.dart';
import 'package:sql_demo/core/models/message_model.dart';
import 'package:sql_demo/core/services/auth_service.dart';
import 'package:sql_demo/core/storage/messages_db.dart';

class ChatView extends StatefulWidget {
  final Contact contact;
  const ChatView({Key? key, required this.contact}) : super(key: key);

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  final controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.contact.name),
        actions: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              widget.contact.id.toString(),
            ),
          ),
        ],
      ),
      body: StreamBuilder<List<Message>>(
          stream: MessagesDB().getMessageForUser(widget.contact.id),
          builder: (_, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.isNotEmpty) {
                return Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(snapshot.data![index].msg),
                            subtitle: Text(
                              snapshot.data![index].senderID.toString(),
                            ),
                          );
                        },
                      ),
                    ),
                    SafeArea(
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: controller,
                            ),
                          ),
                          IconButton(
                              onPressed: () async {
                                if (controller.text.isEmpty) {
                                  return;
                                }
                                Message message = Message(
                                  id: DateTime.now().millisecondsSinceEpoch,
                                  msg: controller.text,
                                  recieverID: AuthService.user.id,
                                  senderID: widget.contact.id,
                                );
                                await MessagesDB().sendMessage(message);
                                controller.clear();
                              },
                              icon: const Icon(Icons.send))
                        ],
                      ),
                    )
                  ],
                );
              } else {
                return Column(
                  children: [
                    const Expanded(
                      child: Center(
                        child: Text("Empty List"),
                      ),
                    ),
                    SafeArea(
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: controller,
                            ),
                          ),
                          IconButton(
                              onPressed: () async {
                                if (controller.text.isEmpty) {
                                  return;
                                }
                                Message message = Message(
                                    id: DateTime.now().millisecondsSinceEpoch,
                                    msg: controller.text,
                                    recieverID: 1,
                                    senderID: widget.contact.id);
                                await MessagesDB().sendMessage(message);
                              },
                              icon: const Icon(Icons.send))
                        ],
                      ),
                    )
                  ],
                );
              }
            } else {
              return const Center(
                child: Text("No messages"),
              );
            }
          }),
    );
  }
}
