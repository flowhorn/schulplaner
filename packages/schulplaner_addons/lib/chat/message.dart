//
import 'package:schulplaner_addons/common/model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

enum ContentType { none, imageURL, documentURL }

class Message {
  final String id, uID;
  final Timestamp createdOn;
  final String text;
  final String content;
  final ContentType contentType;
  final Map<String, bool> readBy;
  Message({
    required this.id,
    required this.uID,
    required this.text,
    required this.createdOn,
    required this.contentType,
    required this.content,
    required this.readBy,
  });
}

class MessageConverter {
  static Message fromJson(dynamic data) {
    return Message(
      id: data['id'],
      uID: data['uID'],
      createdOn: data['createdOn'],
      text: data['text'],
      content: data['content'],
      contentType: enumFromString(
        ContentType.values,
        data['contentType'],
        orElse: ContentType.none,
      )!,
      readBy: decodeMap(data['readBy'], (key, value) => value),
    );
  }

  static Map<String, dynamic> toJson(Message message) {
    return {
      'id': message.id,
      'uID': message.uID,
      'createdOn': message.createdOn,
      'text': message.text,
      'content': message.content,
      'contentType': enumToString(message.contentType),
      'readBy': encodeMap(message.readBy, (it) => it),
    };
  }
}
