//
import 'package:schulplaner_addons/chat/message.dart';
import 'package:schulplaner_addons/utils/color_utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:url_launcher/url_launcher.dart';

class ChatBubble extends StatelessWidget {
  final Message message;
  final String name;
  final bool isMe;
  final bool isSingleChat;

  const ChatBubble({
    Key? key,
    required this.message,
    required this.name,
    required this.isMe,
    required this.isSingleChat,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isMe) {
      return _ChatBubbleRight(
        message: message,
        color: Theme.of(context).primaryColor,
      );
    } else {
      return _ChatBubbleLeft(
        message: message,
        name: name,
        isSingleChat: isSingleChat,
        color: Theme.of(context).cardColor,
      );
    }
  }
}

class _ChatBubbleLeft extends StatelessWidget {
  final Message message;
  final String name;
  final bool isSingleChat;
  final Color color;

  const _ChatBubbleLeft(
      {Key? key,
      required this.message,
      required this.name,
      required this.isSingleChat,
      required this.color})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return _BubbleBase(
      child: BubbleInner(
        child: Column(
          children: <Widget>[
            if (!isSingleChat)
              InkWell(
                child: Container(
                  child: Text(
                    name ?? '???',
                    style: TextStyle(
                      color: Colors.blueGrey,
                      fontSize: 13.5,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                onTap: () {},
              ),
            MessageInner(
              message: message,
              color: ColorUtils.getTextColor(color),
            ),
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
        isBigChild: message.contentType == ContentType.none
            ? message.text.length > 15
            : true,
        subChild: _BubbleTimeView(
          timeOfDay: TimeOfDay.fromDateTime(message.createdOn.toDate()),
          color: ColorUtils.getTextColor(color).withAlpha(90),
        ),
      ),
      background: color,
      borderColor: ColorUtils.of(context).getClearBorderColor(context, color),
      alignment: _BubbleAlignment.left,
    );
  }
}

class _ChatBubbleRight extends StatelessWidget {
  final Message message;
  final Color color;

  const _ChatBubbleRight({Key? key, required this.message, required this.color})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return _BubbleBase(
      child: BubbleInner(
        child: MessageInner(
          message: message,
          color: ColorUtils.getTextColor(color),
        ),
        subChild: Row(
          children: <Widget>[
            _BubbleTimeView(
              timeOfDay: TimeOfDay.fromDateTime(message.createdOn.toDate()),
              color: ColorUtils.getTextColor(color).withAlpha(90),
            ),
            Icon(
              Icons.check,
              color: ColorUtils.getTextColor(color).withAlpha(90),
              size: 11.0,
            ),
          ],
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
        ),
        isBigChild: message.contentType == ContentType.none
            ? message.text.length > 15
            : true,
      ),
      background: color,
      borderColor: ColorUtils.of(context).getClearBorderColor(context, color),
      alignment: _BubbleAlignment.right,
    );
  }
}

enum _BubbleAlignment { left, right }

class _BubbleTimeView extends StatelessWidget {
  final TimeOfDay timeOfDay;
  final Color color;

  const _BubbleTimeView(
      {Key? key, required this.timeOfDay, required this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      timeOfDay.format(context),
      style: TextStyle(
        fontSize: 11.0,
        color: color,
      ),
    );
  }
}

class BubbleInner extends StatelessWidget {
  final bool isBigChild;
  final Widget child, subChild;

  const BubbleInner({
    Key? key,
    required this.isBigChild,
    required this.child,
    required this.subChild,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isBigChild) {
      return Column(
        children: <Widget>[
          child,
          Align(
            alignment: Alignment.bottomRight,
            child: subChild,
          ),
        ],
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
      );
    } else {
      return Row(
        children: <Widget>[
          child,
          SizedBox(
            width: 6.0,
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: subChild,
          ),
        ],
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
      );
    }
  }
}

class _BubbleBase extends StatelessWidget {
  final _BubbleAlignment alignment;
  final Color background, borderColor;
  final Widget child;

  const _BubbleBase({
    Key? key,
    required this.background,
    required this.borderColor,
    required this.child,
    required this.alignment,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.only(
        top: 3.0,
        bottom: 3.0,
      ),
      child: Row(
        children: <Widget>[
          if (alignment == _BubbleAlignment.right) Expanded(child: Container()),
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: borderColor,
                width: 1.0,
              ),
              color: background,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Padding(
              padding:
                  EdgeInsets.only(left: 6.0, right: 6.0, top: 6.0, bottom: 6.0),
              child: LimitedBox(
                maxWidth: width / 8 * 5,
                child: child,
              ),
            ),
          ),
          if (alignment == _BubbleAlignment.left) Expanded(child: Container()),
        ],
      ),
    );
  }
}

class MessageInner extends StatelessWidget {
  final Message message;
  final Color color;

  const MessageInner({Key? key, required this.message, required this.color})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        if (message.contentType == ContentType.imageURL)
          InkWell(
            child: LimitedBox(
              child: Hero(
                child: CachedNetworkImage(
                  imageUrl: message.content,
                  fit: BoxFit.fill,
                ),
                tag: message.content,
              ),
              maxHeight: 400.0,
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => FullImageView(
                            imageUrl: message.content,
                          )));
            },
          ),
        if (message.contentType == ContentType.documentURL)
          ListTile(
            leading: CircleAvatar(
              child: Icon(Icons.insert_drive_file),
            ),
            title: Text(message.content ?? '???'),
            onTap: () {
              launch(message.content);
            },
          ),
        SizedBox(
          height: 4.0,
        ),
        if (message.text.isNotEmpty)
          Text(
            message.text,
            style: TextStyle(
              color: color,
            ),
          ),
      ],
      crossAxisAlignment: CrossAxisAlignment.start,
    );
  }
}

class FullImageView extends StatelessWidget {
  final String imageUrl;

  const FullImageView({Key? key, required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: PhotoView(
        imageProvider: CachedNetworkImageProvider(imageUrl),
        heroAttributes: PhotoViewHeroAttributes(
          tag: imageUrl,
        ),
      ),
    );
  }
}
