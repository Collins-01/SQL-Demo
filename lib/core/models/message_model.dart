class Message {
  final String msg;
  final int recieverID;
  final int senderID;
  final int id;
  Message({
    required this.id,
    required this.msg,
    required this.recieverID,
    required this.senderID,
  });

  Map<String, dynamic> toJson() => {
        'msg': msg,
        'id': id,
        'senderID': senderID,
        'recieverID': recieverID,
      };

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        id: json['id'],
        msg: json['msg'],
        recieverID: json['recieverID'],
        senderID: json['senderID'],
      );
}
