import 'package:flutter/material.dart';
import 'package:schulplaner_widgets/schulplaner_dialogs.dart';

class StateSheet extends SchulplanerSheet {
  final Stream<SheetContent> stream;

  const StateSheet({
    required this.stream,
  });
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<SheetContent>(
      stream: stream,
      builder: (context, snapshot) {
        final sheetContent = snapshot.data;
        if (sheetContent != null) {
          return sheetContent.build(context);
        } else {
          return LoadingSheetContent().build(context);
        }
      },
    );
  }
}
