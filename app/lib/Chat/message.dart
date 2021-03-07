import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String id, uid;
  final Timestamp timestamp;
  final dynamic type, content;
  const Message({
    required this.id,
    required this.uid,
    required this.timestamp,
    required this.type,
    required this.content,
  });

  factory Message.fromData(dynamic data) {
    return Message(
      id: data['id'],
      uid: data['uid'],
      type: data['type'],
      content: data['content'],
      timestamp: Timestamp.fromMillisecondsSinceEpoch((data['timestamp'])),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'uid': uid,
      'type': type,
      'content': content,
      'timestamp': timestamp.millisecondsSinceEpoch,
    };
  }
}
