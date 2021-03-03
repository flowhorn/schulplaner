//@dart=2.11
import 'package:schulplaner_addons/chat/chat_room.dart';
import 'package:schulplaner_addons/chat/chat_thread.dart';
import 'package:schulplaner_addons/chat/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:bloc/bloc_base.dart';
import 'package:bloc/bloc_provider.dart';

class ChatPageBloc extends BlocBase {
  final String chatRoomID;

  ChatPageBloc(this.chatRoomID);

  Stream<ChatRoom> streamChatRoom() {
    return FirebaseFirestore.instance
        .collection('chatRooms')
        .doc(chatRoomID)
        .snapshots()
        .map((snapshot) {
      if (snapshot.exists) {
        return ChatRoomConverter.fromJson(snapshot.data);
      } else {
        return null;
      }
    });
  }

  Stream<List<Message>> streamMessages() {
    return FirebaseFirestore.instance
        .collection('chatRooms')
        .doc(chatRoomID)
        .collection('messages')
        .orderBy('createdOn', descending: false)
        .snapshots()
        .map((querySnapshot) {
      return querySnapshot.docs
          .map((it) => MessageConverter.fromJson(it))
          .toList();
    });
  }

  void loadMoreMessages() {}

  @override
  void dispose() {}
}

class ChatPage extends StatelessWidget {
  final String chatRoomID;
  final ChatPageBloc bloc;
  ChatPage({Key key, this.chatRoomID})
      : bloc = ChatPageBloc(chatRoomID),
        super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      bloc: bloc,
      child: StreamBuilder(
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          ChatRoom chatRoom = snapshot.data;
          return ChatThread(
            chatRoom: chatRoom,
          );
        },
      ),
    );
  }
}
