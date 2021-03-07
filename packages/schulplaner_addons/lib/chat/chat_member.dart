//@dart=2.11
import 'package:schulplaner_addons/common/model.dart';

class ChatMember {
  final String uID, name;
  final List<String> pushKeys;

  ChatMember({this.uID, this.name, this.pushKeys});
}

class ChatMemberConverter {
  static ChatMember fromJson(String key, dynamic data) {
    return ChatMember(
      uID: key,
      name: data['name'],
      pushKeys: decodeList(data['pushKeys'], (value) => value),
    );
  }

  static Map<String, dynamic> toJson(ChatMember chatMember) {
    return {
      'name': chatMember.name,
      'pushKeys': chatMember.pushKeys,
    };
  }
}
