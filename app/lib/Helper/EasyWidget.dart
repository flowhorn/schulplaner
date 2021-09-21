import 'package:schulplaner_navigation/schulplaner_navigation.dart';
import 'package:schulplaner_widgets/schulplaner_common.dart';

import 'helper_views.dart';
import 'package:flutter/material.dart';

typedef Widget DataWidgetBuilder<T>(BuildContext context, T data);

Future<T?> selectItem<T>({
  required BuildContext context,
  required List<T> items,
  required DataWidgetBuilder<T> builder,
  WidgetListBuilder? actions,
}) {
  return showSheetBuilder<T>(
    context: context,
    child: (context) => Flexible(
        child: UpListView<T>(
      items: items,
      emptyViewBuilder: (context) => EmptyListState(),
      builder: (BuildContext context, item) {
        return builder(context, item);
      },
      shrinkWrap: true,
    )),
    actions: actions,
  );
}

Future<void> selectItemAsync<T>({
  required BuildContext context,
  required Stream<List<T>> itemstream,
  required DataWidgetBuilder<T> builder,
  WidgetListBuilder? actions,
}) {
  return showSheetBuilder(
    context: context,
    child: (context) => StreamBuilder<List<T>>(
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final List<T> items = snapshot.data ?? [];
          return Flexible(
              child: UpListView<T>(
            items: items,
            emptyViewBuilder: (context) => EmptyListState(),
            builder: (BuildContext context, item) {
              return builder(context, item);
            },
          ));
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
      stream: itemstream,
    ),
    actions: actions,
  );
}

Widget getFlexList(List<Widget> children) {
  return Flexible(
      child: SingleChildScrollView(
    child: Column(
      children: children,
    ),
  ));
}

Widget getExpandList(List<Widget> children) {
  return Expanded(
      child: SingleChildScrollView(
    child: Column(
      children: children,
    ),
  ));
}

Widget getDefaultList(List<Widget> children) {
  return SingleChildScrollView(
    child: Column(
      children: children,
    ),
  );
}
