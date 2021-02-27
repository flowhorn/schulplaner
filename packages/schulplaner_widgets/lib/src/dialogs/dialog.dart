//@dart=2.11
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:universal_commons/platform_check.dart';

abstract class SchulplanerDialog {
  const SchulplanerDialog();

  Widget build(BuildContext context);

  Future<T> show<T>(BuildContext context) async {
    if (PlatformCheck.isAppleOS) {
      return showCupertinoDialog<T>(
        context: context,
        builder: (context) => build(context),
      );
    }
    return showDialog<T>(
      context: context,
      builder: (context) => build(context),
    );
  }
}
