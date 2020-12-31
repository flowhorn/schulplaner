import 'package:flutter/material.dart';
import '../get_string.dart';

abstract class TranslatableString {
  String getText(BuildContext context);
}

class TranslationString implements TranslatableString {
  final String Function(BuildContext context) _getAppLocalizationsString;

  const TranslationString(this._getAppLocalizationsString);
  String getText(BuildContext context) {
    return _getAppLocalizationsString(context);
  }
}

class BothLangString implements TranslatableString {
  final String de, en;
  const BothLangString({@required this.de, @required this.en});

  String getText(BuildContext context) {
    if (getString(context).languagecode == "de") {
      return de;
    } else {
      return en;
    }
  }
}

class SimpleString implements TranslatableString {
  final String text;
  const SimpleString(this.text);

  String getText(BuildContext context) {
    return text;
  }
}
