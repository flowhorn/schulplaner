// @dart=2.11
import 'package:flutter/material.dart';

Future<T> pushWidget<T>(BuildContext context, Widget widget,
    {String routname}) {
  return Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) {
          return widget;
        },
        settings: routname != null ? RouteSettings(name: routname) : null,
      ));
}

Future<dynamic> pushReplaceWidget(BuildContext context, Widget widget,
    {String routname}) {
  return Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) {
          return widget;
        },
        settings: routname != null ? RouteSettings(name: routname) : null,
      ));
}
