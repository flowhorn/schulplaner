import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:schulplaner_widgets/src/dialogs/dialog.dart';
import 'package:schulplaner_translations/schulplaner_translations.dart';
import 'package:universal_commons/platform_check.dart';

class ConfirmDialog extends SchulplanerDialog {
  final String title;
  final String message;

  const ConfirmDialog({
    @required this.title,
    @required this.message,
  });
  @override
  Widget build(BuildContext context) {
    if (PlatformCheck.isAppleOS) {
      return CupertinoAlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          CupertinoButton(
            child: Text(getString(context).cancel),
            onPressed: () {
              Navigator.pop(context, false);
            },
          ),
          CupertinoButton(
            child: Text(getString(context).confirm),
            onPressed: () {
              Navigator.pop(context, true);
            },
          ),
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
            Navigator.pop(context, false);
          },
          child: Text(getString(context).cancel),
        ),
        FlatButton(
          onPressed: () {
            Navigator.pop(context, true);
          },
          child: Text(getString(context).confirm),
        ),
      ],
    );
  }
}
