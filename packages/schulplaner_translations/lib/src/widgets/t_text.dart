import 'package:flutter/material.dart';
import 'package:schulplaner_translations/src/models/translations_string.dart';

/// Ein Text Widget, welches einen TranslationText verwendet.
class TText extends StatelessWidget {
  final TranslatableString text;

  const TText(this.text);
  @override
  Widget build(BuildContext context) {
    return Text(text.getText(context));
  }
}
