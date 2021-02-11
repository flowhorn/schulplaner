import 'package:flutter/material.dart';

abstract class SchulplanerSheet {
  const SchulplanerSheet();

  Widget build(BuildContext context);

  Future<T> show<T>(BuildContext context) async {
    return showModalBottomSheet<T>(
      context: context,
      builder: (context) => build(context),
    );
  }

  Future<void> showWithAutoPop(
    BuildContext context, {
    required Future<bool> future,
    Duration delay,
  }) async {
    final sheetPop = show(context);
    bool hasSheetPopped = false;
    sheetPop.then((_) => hasSheetPopped = true);
    future.then((result) async {
      if (result == true) {
        await Future.delayed(delay);
        if (!hasSheetPopped) {
          Navigator.pop(context);
        }
      }
    });
  }
}
