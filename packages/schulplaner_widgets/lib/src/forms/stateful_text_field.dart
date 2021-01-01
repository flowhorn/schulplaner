import 'package:flutter/material.dart';

/// Dieses Textfeld behält seinen State bei, auch wenn sich der Inhalt gerade ändert.
class StatefulTextField extends StatefulWidget {
  const StatefulTextField({
    Key key,
    this.initialText,
    this.autofocus = false,
    this.onEditingComplete,
    this.onChanged,
    this.textInputAction,
    this.decoration,
    this.maxLength,
    this.maxLengthEnforced = false,
    this.focusNode,
    this.maxLines = 1,
    this.style,
    this.cursorColor,
    this.keyboardType,
    this.scrollPadding = const EdgeInsets.all(20.0),
    this.autofillHints,
  }) : super(key: key);

  StatefulTextField.standard({
    Key key,
    this.initialText,
    this.autofocus = false,
    this.onEditingComplete,
    this.onChanged,
    this.textInputAction,
    this.maxLength,
    this.maxLengthEnforced = false,
    this.focusNode,
    this.maxLines = 1,
    this.style,
    this.cursorColor,
    this.keyboardType,
    this.scrollPadding = const EdgeInsets.all(20.0),
    this.autofillHints,
    String labelText,
    IconData iconData,
    String prefixText,
  })  : this.decoration = InputDecoration(
            icon: iconData != null ? Icon(iconData) : null,
            labelText: labelText,
            border: OutlineInputBorder(),
            prefixText: prefixText),
        super(key: key);

  final String initialText;
  final bool autofocus;
  final FocusNode focusNode;
  final VoidCallback onEditingComplete;
  final ValueChanged<String> onChanged;
  final TextInputAction textInputAction;
  final InputDecoration decoration;
  final int maxLength;
  final int maxLines;
  final bool maxLengthEnforced;
  final TextStyle style;
  final Color cursorColor;
  final TextInputType keyboardType;
  final EdgeInsets scrollPadding;
  final Iterable<String> autofillHints;

  @override
  _StatefulTextFieldState createState() => _StatefulTextFieldState();
}

class _StatefulTextFieldState extends State<StatefulTextField> {
  TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.initialText);
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      autofocus: widget.autofocus,
      onEditingComplete: widget.onEditingComplete,
      textInputAction: widget.textInputAction,
      decoration: widget.decoration,
      onChanged: widget.onChanged,
      maxLength: widget.maxLength,
      maxLengthEnforced: widget.maxLengthEnforced,
      maxLines: widget.maxLines,
      autofillHints: widget.autofillHints,
      focusNode: widget.focusNode,
      style: widget.style,
      keyboardType: widget.keyboardType,
      cursorColor: widget.cursorColor,
      scrollPadding: widget.scrollPadding,
    );
  }
}
