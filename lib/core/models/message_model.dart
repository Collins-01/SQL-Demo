class Message {
  final String msg;
  final String from;
  final String to;
  final int id;
  Message({
    required this.id,
    required this.msg,
    required this.to,
    required this.from,
  });

  Map<String, dynamic> toJson() => {
        'msg': msg,
        'id': id,
        'from': from,
        'to': to,
      };

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        id: json['id'],
        msg: json['msg'],
        to: json['to'],
        from: json['from'],
      );
}
