import 'package:flutter/material.dart';
import 'package:schulplaner_translations/schulplaner_translations.dart';
import 'package:schulplaner_widgets/src/dialogs/sheet_content/sheet_content.dart';

class SimpleItemSheetContent extends SheetContent {
  final IconData iconData;
  final Color color;
  final TranslatableString text;

  const SimpleItemSheetContent({
    required this.iconData,
    required this.color,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Icon(
            iconData,
            size: 72,
            color: color,
          ),
          SizedBox(
            height: 12,
          ),
          Text(
            text.getText(context),
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
      ),
    );
  }
}

final successfulSheetContent = SimpleItemSheetContent(
  iconData: Icons.done,
  color: Colors.green,
  text: BaseTranslations.successfull,
);

final errorSheetContent = SimpleItemSheetContent(
  iconData: Icons.error,
  color: Colors.red,
  text: BaseTranslations.error,
);

final noInternetSheetContent = SimpleItemSheetContent(
  iconData: Icons.warning,
  color: Colors.orange,
  text: BaseTranslations.noInternetAccess,
);

final unknownExceptionSheetContent = SimpleItemSheetContent(
  iconData: Icons.warning,
  color: Colors.orange,
  text: BaseTranslations.unknownException,
);

class LoadingSheetContent extends SheetContent {
  const LoadingSheetContent();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          CircularProgressIndicator(),
          SizedBox(
            height: 12,
          ),
          Text(
            getString(context).pleasewait,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
      ),
    );
  }
}
