import 'package:flutter/material.dart';

abstract class SchulplanerSheet {
  const SchulplanerSheet();

  Widget build(BuildContext context);

  Future<T?> show<T>(BuildContext context) async {
    return showModalBottomSheet<T>(
      constraints: const BoxConstraints(maxWidth: 600, minHeight: 200),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      context: context,
      builder: (context) => build(context),
    );
  }

  Future<void> showWithAutoPop(
    BuildContext context, {
    required Future<bool> future,
    required Duration delay,
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
