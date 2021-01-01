import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  String id, uid;
  Timestamp timestamp;
  dynamic type, content;
  Message({this.id, this.uid, this.timestamp, this.type, this.content});

  Message.fromData(dynamic data) {
    id = data['id'];
    uid = data['uid'];
    type = data['type'];
    content = data['content'];
    timestamp = Timestamp.fromMillisecondsSinceEpoch((data['timestamp']));
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
