//
import 'package:schulplaner_addons/chat/chat_attachment.dart';
import 'package:schulplaner_addons/chat/chat_bubble.dart';
import 'package:schulplaner_addons/chat/chat_page.dart';
import 'package:schulplaner_addons/chat/chat_room.dart';
import 'package:schulplaner_addons/chat/chat_threadlist.dart';
import 'package:schulplaner_addons/chat/message.dart';
import 'package:bloc/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:schulplaner_addons/utils/color_utils.dart';
import 'package:schulplaner_widgets/schulplaner_theme.dart';

class ChatThread extends StatelessWidget {
  final ChatRoom chatRoom;

  const ChatThread({Key? key, required this.chatRoom}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<ChatPageBloc>(context);
    return Scaffold(
      appBar: ChatAppBar(
        title: chatRoom.name,
      ),
      body: Column(children: [
        Expanded(
          child: StreamBuilder<List<Message>>(
            stream: bloc.streamMessages(),
            builder: (context, snapshot) {
              List<Message> messages = snapshot.hasData ? snapshot.data! : [];
              return ChatThreadList.build(
                messages: messages,
                messageBuilder: (
                  context,
                  threadMessage,
                ) {
                  String name =
                      chatRoom.members[threadMessage.message.uID]?.name ??
                          '???';
                  return ChatBubble(
                    message: threadMessage.message,
                    name: name,
                    isMe: threadMessage.message.uID == 'max',
                    isSingleChat: false,
                  );
                },
                loadMore: () {
                  bloc.loadMoreMessages();
                },
              );
            },
          ),
        ),
        ChatInput(
          onPressedAdd: () async {
            ChatAttachment? attachment = await selectChatAttachment(context);
            if (attachment != null) {
              switch (attachment.type) {
                case ChatAttachmentType.image:
                  {
                    break;
                  }
                case ChatAttachmentType.document:
                  {
                    break;
                  }
                case ChatAttachmentType.text:
                  {
                    break;
                  }
              }
            }
          },
          onSendMessage: (message) {
            return true;
          },
        ),
      ]),
    );
  }
}

class ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const ChatAppBar({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: InkWell(
        child: SizedBox(
          width: double.infinity,
          child: Row(
            children: <Widget>[
              CircleAvatar(
                radius: 22.0,
                child: Icon(Icons.chat_bubble),
              ),
              SizedBox(width: 8.0),
              Text(title),
            ],
          ),
        ),
        onTap: () {},
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.more_vert),
          onPressed: () {},
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(57.0);
}

class ChatInput extends StatelessWidget {
  final Color secondaryColor;
  final bool Function(String text) onSendMessage;
  final void Function() onPressedAdd;
  final TextEditingController textEditingController =
      TextEditingController(text: '');
  ChatInput({
    Key? key,
    required this.onSendMessage,
    required this.onPressedAdd,
    this.secondaryColor = Colors.blueGrey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
          colorScheme: getColorScheme(
              primary: secondaryColor,
              brightness: Theme.of(context).brightness)),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Row(
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.add_circle_outline),
              onPressed: onPressedAdd,
              color: secondaryColor,
              iconSize: 30.0,
            ),
            Expanded(
              child: TextField(
                controller: textEditingController,
                cursorColor: secondaryColor,
                style: TextStyle(
                    color: ColorUtils.of(context).getDefaultTextColor()),
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(32.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(32.0),
                        borderSide: BorderSide(
                          color: ColorUtils.of(context).getDefaultTextColor(),
                        )),
                    hintText: 'Sende eine Nachricht...',
                    contentPadding: EdgeInsets.only(
                      left: 16.0,
                      right: 16.0,
                      top: 16.0,
                      bottom: 16.0,
                    ),
                    hintStyle: TextStyle(
                      color: ColorUtils.of(context)
                          .getDefaultTextColor()
                          .withOpacity(0.7),
                    )),
                maxLines: 5,
                minLines: 1,
              ),
            ),
            SizedBox(width: 4.0),
            Container(
              width: 48.0,
              height: 48.0,
              child: ValueListenableBuilder<TextEditingValue>(
                valueListenable: textEditingController,
                builder: (context, data, _) {
                  final bool enabled = data.text.isNotEmpty;
                  return RawMaterialButton(
                    fillColor: enabled
                        ? secondaryColor
                        : secondaryColor.withOpacity(0.5),
                    shape: CircleBorder(),
                    elevation: 0.0,
                    onPressed: enabled
                        ? () {
                            bool value =
                                onSendMessage(textEditingController.text);
                            if (value == true) {
                              textEditingController.clear();
                            }
                          }
                        : null,
                    child: Icon(
                      Icons.send,
                      size: 28.0,
                      color: Theme.of(context).canvasColor,
                    ),
                  );
                },
              ),
            ),
            SizedBox(width: 4.0),
          ],
        ),
      ),
    );
  }
}
