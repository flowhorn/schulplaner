import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:schulplaner_addons/chat/chat_attachment.dart';
import 'package:schulplaner_addons/chat/chat_bubble.dart';
import 'package:schulplaner_addons/chat/chat_thread.dart';
import 'package:schulplaner_addons/chat/chat_threadlist.dart';
import 'package:schulplaner_addons/schulplaner_utils.dart';
import 'package:schulplaner8/Chat/message.dart';
import 'package:schulplaner8/Data/Planner/File.dart';
import 'package:schulplaner8/Data/planner_database/planner_database.dart';
import 'package:schulplaner_addons/chat/message.dart' as message2;

class ChatThread extends StatefulWidget {
  final String groupid;
  final String uid;
  final PlannerDatabase database;

  ChatThread(
      {Key? key,
      required this.groupid,
      required this.database,
      required this.uid})
      : super(key: key);

  @override
  State createState() => ChatThreadState(groupid: groupid, uid: uid);
}

class ChatThreadState extends State<ChatThread> {
  ChatThreadState({Key? key, required this.groupid, required this.uid});

  final String uid;
  final String groupid;

  List<Message> listMessage = [];

  bool isLoading = false;

  final TextEditingController textEditingController = TextEditingController();
  final ScrollController listScrollController = ScrollController();
  final FocusNode focusNode = FocusNode();
  final Map<String, String> nameDatabase = {};

  @override
  void initState() {
    super.initState();
    focusNode.addListener(onFocusChange);

    isLoading = false;
  }

  void onFocusChange() {
    if (focusNode.hasFocus) {
      // Hide sticker when keyboard appear
      setState(() {});
    }
  }

  Future getAttachment() async {
    final ChatAttachment? attachment = await selectChatAttachment(context);
    if (attachment != null) {
      switch (attachment.type) {
        case ChatAttachmentType.image:
          {
            if (attachment.file != null) {
              setState(() {
                isLoading = true;
              });
              await uploadImage(attachment.file!.file);
            }
            break;
          }
        case ChatAttachmentType.document:
          {
            if (attachment.file != null) {
              setState(() {
                isLoading = true;
              });
              await uploadFile(attachment.file!.file);
            }
            break;
          }
        case ChatAttachmentType.text:
          {
            return '';
          }
      }
    }
  }

  Future uploadImage(File imageFile) async {
    final fileName = DateTime.now().millisecondsSinceEpoch.toString();
    final reference =
        FirebaseStorage.instance.ref().child('chat').child(fileName);
    final uploadTask = reference.putFile(imageFile);
    final storageTaskSnapshot = await uploadTask;
    try {
      final downloadUrl = await storageTaskSnapshot.ref.getDownloadURL();
      final imageUrl = downloadUrl;
      setState(() {
        isLoading = false;
        onSendMessage(imageUrl, 1);
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      await showToastMessage(msg: 'This file is not an image');
    }
  }

  Future uploadFile(File documentFile) async {
    final fileName = DateTime.now().millisecondsSinceEpoch.toString();
    final reference =
        FirebaseStorage.instance.ref().child('chat').child(fileName);
    final uploadTask = reference.putFile(documentFile);
    final storageTaskSnapshot = await uploadTask;
    try {
      final downloadUrl = await storageTaskSnapshot.ref.getDownloadURL();
      final imageUrl = downloadUrl;
      setState(() {
        isLoading = false;
        onSendMessage(imageUrl, 2);
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      await showToastMessage(msg: 'This file is not valid');
    }
  }

  void onSendMessage(String content, int type) {
    // type: 0 = text, 1 = image, 2 = sticker
    if (content.trim() != '') {
      textEditingController.clear();

      var documentReference = FirebaseDatabase.instance
          .ref()
          .child('chats')
          .child(groupid)
          .child('messages')
          .push();

      documentReference.set(Message(
              id: documentReference.key!,
              uid: uid,
              timestamp: Timestamp.now(),
              content: content,
              type: type)
          .toJson());
      listScrollController.animateTo(0.0,
          duration: Duration(milliseconds: 300), curve: Curves.easeOut);
    } else {
      showToastMessage(msg: 'Nothing to send');
    }
  }

  Future<bool> onBackPress() {
    Navigator.pop(context);
    return Future.value(false);
  }

  String? getFromNameDatabase(String uid) {
    if (nameDatabase.containsKey(uid)) {
      return nameDatabase[uid];
    } else {
      widget.database.dataManager
          .userOtherRoot(uid)
          .collection('data')
          .doc('info')
          .get()
          .then((it) {
        if (it.exists) {
          final String? name = it.get('name');
          setState(() {
            nameDatabase[uid] = name ?? it.id;
          });
        } else {
          nameDatabase[uid] = 'Anonymer Nutzer';
        }
      });
      return '...';
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onBackPress,
      child: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              // List of messages
              Flexible(
                child: StreamBuilder<List<Message>>(
                  stream: FirebaseDatabase.instance
                      .ref()
                      .child('chats')
                      .child(groupid)
                      .child('messages')
                      .orderByChild('timestamp')
                      .limitToLast(50)
                      .onValue
                      .map((event) {
                    if (event.snapshot.value == null) {
                      return [];
                    } else {
                      Map<String, dynamic> data =
                          (event.snapshot.value as dynamic)
                              .cast<String, dynamic>();
                      return data.values
                          .map((value) => Message.fromData(value))
                          .toList()
                        ..sort((m1, m2) {
                          return m2.timestamp.compareTo(m1.timestamp);
                        });
                    }
                  }),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                          child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  ColorUtils.of(context).getAccentColor())));
                    } else {
                      listMessage = (snapshot.data ?? []);
                      return ChatThreadList.build(
                        messages: listMessage
                            .map((message) => message2.Message(
                                text: message.type == 0 ? message.content : '',
                                contentType: message.type == 1
                                    ? message2.ContentType.imageURL
                                    : (message.type == 2
                                        ? message2.ContentType.documentURL
                                        : message2.ContentType.none),
                                content: message.content,
                                createdOn: message.timestamp,
                                id: message.id,
                                uID: message.uid,
                                readBy: {}))
                            .toList(),
                        messageBuilder: (context, element) {
                          return ChatBubble(
                            message: element.message,
                            isMe: element.message.uID == uid,
                            isSingleChat: false,
                            name: getFromNameDatabase(element.message.uID) ??
                                '???',
                          );
                        },
                        loadMore: () {},
                        scrollController: listScrollController,
                      );
                    }
                  },
                ),
              ),

              // Input content
              ChatInput(
                secondaryColor: Theme.of(context).colorScheme.secondary,
                onPressedAdd: () {
                  getAttachment();
                },
                onSendMessage: (newText) {
                  onSendMessage(newText, 0);
                  return true;
                },
              ),
            ],
          ),
          ChatLoading(
            isLoading: isLoading,
          ),
        ],
      ),
    );
  }

  void showFullScreenImage(BuildContext context, dynamic url) {
    OpenCloudFile(
        context, CloudFile(fileform: FileForm.WEBLINK, url: url.toString()));
  }
}

class ChatLoading extends StatelessWidget {
  final bool isLoading;

  const ChatLoading({Key? key, required this.isLoading}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Positioned(
      child: isLoading
          ? Container(
              color: Colors.white.withOpacity(0.8),
              child: Center(
                child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                        ColorUtils.of(context).getAccentColor())),
              ),
            )
          : Container(),
    );
  }
}
