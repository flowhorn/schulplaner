import 'package:flutter/material.dart';
import 'package:schulplaner_widgets/schulplaner_dialogs.dart';
import 'package:schulplaner_widgets/src/dialogs/sheet_content/simple_item_sheet_content.dart';
import 'sheet_content/sheet_content.dart';

class StateSheet extends SchulplanerSheet {
  final Stream<SheetContent> stream;

  const StateSheet({
    @required this.stream,
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
