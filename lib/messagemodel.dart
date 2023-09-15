class Message {
  final String toUid;
  final String msg;
  final String read;
  final String fromUid;
  final String sent;
  final Type type;

  Message({
    required this.toUid,
    required this.msg,
    required this.read,
    required this.fromUid,
    required this.sent,
    required this.type,
  });
  Map<String, dynamic> toJson() => {
    "toUid": toUid,
    "msg": msg,
    "read": read,
    "type": type.name,
    "fromUid": fromUid,
    "sent": sent,
  };
  factory Message.fromJson(json) => Message(
    toUid: json["toUid"].toString(),
    msg: json["msg"].toString(),
    read: json["read"].toString(),
    type: json["type"].toString()==Type.image.name?Type.image:Type.text,
    fromUid: json["fromUid"].toString(),
    sent: json["sent"].toString(),
  );


}

enum Type{text,image}