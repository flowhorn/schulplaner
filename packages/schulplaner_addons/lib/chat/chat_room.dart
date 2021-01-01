import 'package:schulplaner_addons/chat/chat_member.dart';
import 'package:schulplaner_addons/common/model.dart';

class ChatRoom {
  final String id, name;
  final Map<String, ChatMember> members;
  final bool isSingleChat;
  final dynamic settings;

  ChatRoom(
      {this.id, this.name, this.members, this.settings, this.isSingleChat});
}

class ChatRoomConverter {
  static ChatRoom fromJson(dynamic data) {
    return ChatRoom(
      id: data['id'],
      name: data['name'],
      members: decodeMap(data['members'],
          (key, value) => ChatMemberConverter.fromJson(key, value)),
      settings: data['settings'],
      isSingleChat: data['isSingleChat'],
    );
  }

  static Map<String, dynamic> toJson(ChatRoom chatRoom) {
    return {
      'id': chatRoom.id,
      'name': chatRoom.name,
      'settings': chatRoom.settings,
      'isSingleChat': chatRoom.isSingleChat,
      'members':
          encodeMap(chatRoom.members, (it) => ChatMemberConverter.toJson(it)),
    };
  }
}
