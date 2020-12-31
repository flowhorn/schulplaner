import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class FormTextField extends StatelessWidget {
  const FormTextField(
      {@required this.text,
      this.labeltext,
      this.iconData,
      @required this.valueChanged,
      this.keyBoardType,
      this.obscureText = false,
      this.maxLength,
      this.maxLines,
      this.autofocus = false,
      this.maxLengthEnforced = false,
      this.prefixtext});
  final String text;
  final String labeltext;
  final IconData iconData;
  final ValueChanged<String> valueChanged;
  final TextInputType keyBoardType;
  final bool obscureText, maxLengthEnforced, autofocus;
  final int maxLength, maxLines;
  final String prefixtext;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: Theme(
          data:
              newAppTheme(context, primaryColor: Theme.of(context).accentColor),
          child: TextField(
            controller: TextEditingController(text: text ?? ""),
            onChanged: valueChanged,
            decoration: InputDecoration(
                icon: iconData != null ? Icon(iconData) : null,
                labelText: labeltext,
                border: OutlineInputBorder(),
                prefixText: prefixtext),
            keyboardAppearance: Theme.of(context).brightness,
            keyboardType: keyBoardType,
            obscureText: obscureText,
            maxLines: maxLines,
            maxLength: maxLength,
            maxLengthEnforced: maxLengthEnforced,
            autofocus: autofocus,
          )),
    );
  }
}
