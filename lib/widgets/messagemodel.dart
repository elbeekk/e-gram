
class MessageChat {
  String idFrom;
  String idTo;
  String timestamp;
  String content;

  MessageChat({
    required this.idFrom,
    required this.idTo,
    required this.timestamp,
    required this.content,
  });
  Map<String, dynamic> tojson(){
    return {
      'idFrom':idFrom,
      'idTo':idTo,
      'timestamp':timestamp,
      'content':content,
    };
  }
  factory MessageChat.fromDocument(doc){
    String idFrom = doc.getProperty('idFrom');
    String idTo = doc.getProperty('idTo ');
    String timestamp = doc.getProperty('timestamp');
    String content = doc.getProperty('content');
    return MessageChat(idFrom: idFrom, idTo: idTo, timestamp: timestamp, content: content);
  }

}