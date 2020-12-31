import 'package:flutter/material.dart';

/// Eine ListView mit einer Endzone am Ende von 72dp, zusätzlich einem emptyViewBuilder
class UpListView<T> extends StatelessWidget {
  final List<T> items;
  final Widget Function(BuildContext context, T item) builder;
  final Widget Function(BuildContext context) emptyViewBuilder;

  const UpListView(
      {Key key,
      @required this.items,
      @required this.builder,
      this.emptyViewBuilder})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    if (items.isNotEmpty) {
      return ListView.builder(
        itemCount: items.length + 1,
        itemBuilder: (context, index) {
          if (index == items.length) {
            return SizedBox(
              height: 72.0,
            );
          } else {
            return builder(context, items[index]);
          }
        },
      );
    } else {
      return Center(
        child:
            emptyViewBuilder != null ? emptyViewBuilder(context) : Container(),
      );
    }
  }
}
