import 'package:flutter/widgets.dart';
import 'package:overlay_support/overlay_support.dart';

Future<void> showToastMessage({required String msg}) async {
  showSimpleNotification(
    Text(
      msg,
      textAlign: TextAlign.center,
    ),
  );
}
