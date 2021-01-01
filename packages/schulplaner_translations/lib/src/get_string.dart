import 'package:flutter/material.dart';
import 'my_app_localization.dart';

MyAppLocalizations getString(BuildContext context) {
  if (context == null) return MyAppLocalizations();
  return MyAppLocalizations.of(context);
}
