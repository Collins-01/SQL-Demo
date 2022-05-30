import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sql_demo/core/models/contact_model.dart';
import 'package:sql_demo/core/storage/chats_db.dart';

class ContactsView extends ConsumerWidget {
  const ContactsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var model = ref.watch(chatsDb);
    log(model.contacts.toString());
    return Scaffold(
      appBar: AppBar(
        title: const Text("Contacts"),
      ),
      body: StreamBuilder(
          stream: model.contacts,
          builder: (_, AsyncSnapshot<List<Contact>> snapshot) {
            if (snapshot.hasData) {
              //
              if (snapshot.data != null) {
                return snapshot.data!.isNotEmpty
                    ? ListView.builder(
                        itemCount: snapshot.data?.length ?? 0,
                        itemBuilder: (_, index) => Center(
                            child: ListTile(
                          title: Text(
                            // snapshot.data![index].id.toString() +
                            //     " " +
                            snapshot.data![index].name,
                          ),
                        )),
                      )
                    : const Center(
                        child: Text("Contacts list is Empty"),
                      );
              } else {
                return const Center(
                  child: Text("Snapshot Data is Null"),
                );
              }
            } else {
              return Center(
                child: Text(
                  snapshot.data.toString(),
                ),
              );
            }
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ChatsDB().createContactI();
        },
      ),
    );
  }
}
