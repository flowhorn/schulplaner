import 'package:schulplaner_addons/chat/message.dart';
import 'package:schulplaner_addons/utils/date_utils.dart' as dateUtils;
import 'package:flutter/material.dart';

abstract class _ChatThreadElement {
  final int position;

  _ChatThreadElement(this.position);
}

class _ChatThreadMessage implements _ChatThreadElement {
  final Message message;
  _ChatThreadMessage(this.message);

  @override
  int get position => message.createdOn.millisecondsSinceEpoch;
}

class _ChatThreadDate implements _ChatThreadElement {
  final String date;
  final String text;

  _ChatThreadDate(this.date, this.text);

  @override
  int get position =>
      dateUtils.DateUtils.parseDateTime(date).millisecondsSinceEpoch;
}

class ChatThreadList extends StatelessWidget {
  final List<_ChatThreadElement> elements;
  final ScrollController scrollController;
  final Widget Function(BuildContext context, _ChatThreadMessage threadMessage)
      messageBuilder;
  final VoidCallback loadMore;

  const ChatThreadList._(
      {Key key,
      this.elements,
      this.messageBuilder,
      this.loadMore,
      this.scrollController})
      : super(key: key);

  factory ChatThreadList.build({
    Key key,
    @required List<Message> messages,
    @required
        Widget Function(BuildContext context, _ChatThreadMessage threadMessage)
            messageBuilder,
    @required VoidCallback loadMore,
    ScrollController scrollController,
  }) {
    return ChatThreadList._(
      key: key,
      elements: _buildThreadList(messages),
      messageBuilder: messageBuilder,
      loadMore: loadMore,
      scrollController: scrollController,
    );
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scrollInfo) {
        if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
          loadMore();
        }
        return false;
      },
      child: ListView.builder(
        padding: EdgeInsets.all(10.0),
        reverse: true,
        itemCount: elements.length,
        controller: scrollController,
        itemBuilder: (context, index) {
          _ChatThreadElement element = elements[index];
          if (element is _ChatThreadDate) {
            return ChatThreadDateView(
              threadDate: element,
            );
          } else if (element is _ChatThreadMessage) {
            return messageBuilder(context, element);
          }
          return Container();
        },
      ),
    );
  }
}

class ChatThreadDateView extends StatelessWidget {
  final _ChatThreadDate threadDate;

  const ChatThreadDateView({Key key, this.threadDate}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        threadDate.text,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.blueGrey,
        ),
      ),
    );
  }
}

List<_ChatThreadElement> _buildThreadList(List<Message> messages) {
  Map<String, bool> dates = {};
  List<_ChatThreadElement> elements = [];
  for (final message in messages) {
    String date =
        dateUtils.DateUtils.parseDateString(message.createdOn.toDate());
    if (!dates.containsKey(date)) {
      dates[date] = true;
      elements
          .add(_ChatThreadDate(date, dateUtils.DateUtils.getDateText(date)));
    }
    elements.add(_ChatThreadMessage(message));
  }
  elements.sort((e1, e2) => e1.position.compareTo(e2.position));

  return elements.reversed.toList();
}
