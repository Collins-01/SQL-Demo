import 'package:sql_demo/core/models/message_model.dart';

class Contact {
  final String name;
  final int id;
  // final List<Message> messages;
  Contact({
    required this.name,
    required this.id,
    // this.messages = const [],
  });
  factory Contact.fromJson(Map<String, dynamic> json) => Contact(
        name: json['name'],
        id: json['id'],
        // messages: json['messages'].map((e) => Message.fromJson(e)).toList(),
      );
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        // 'messages': messages.map((e) => e.toJson()).toList(),
      };
}
