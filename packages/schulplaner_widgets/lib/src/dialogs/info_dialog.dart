import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:schulplaner_widgets/src/dialogs/dialog.dart';
import 'package:schulplaner_translations/schulplaner_translations.dart';
import 'package:universal_commons/platform_check.dart';

class InfoDialog extends SchulplanerDialog {
  final String title;
  final String message;

  const InfoDialog({
    required this.title,
    required this.message,
  });
  @override
  Widget build(BuildContext context) {
    if (PlatformCheck.isAppleOS) {
      return CupertinoAlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          CupertinoButton(
            child: Text(getString(context).done),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ],
      );
    }
    return AlertDialog(
      title: Text(title),
      content: ListTile(
        title: Text(message),
      ),
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(getString(context).done),
        )
      ],
    );
  }
}
