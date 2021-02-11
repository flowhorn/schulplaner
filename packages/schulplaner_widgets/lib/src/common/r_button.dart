import 'package:flutter/material.dart';
import 'package:schulplaner_widgets/schulplaner_theme.dart';

/// A rectangular Button with border
class RButton extends StatelessWidget {
  const RButton({
    Key key,
    required this.text,
    this.iconData,
    required this.onTap,
    this.enabled = true,
    this.disabledColor,
  }) : super(key: key);
  final String text;
  final IconData iconData;
  final VoidCallback onTap;
  final bool enabled;
  final Color disabledColor;

  @override
  Widget build(BuildContext context) {
    if (iconData != null) {
      return OutlineButton.icon(
        onPressed: enabled == true ? onTap : null,
        icon: Icon(
          iconData,
          color: enabled ? null : disabledColor,
        ),
        label: Text(text ?? '-'),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(16.0),
          ),
        ),
        disabledTextColor: disabledColor,
        disabledBorderColor: disabledColor,
        highlightedBorderColor: getClearTextColor(context),
        textColor: getClearTextColor(context),
      );
    } else {
      return OutlineButton(
        onPressed: enabled == true ? onTap : null,
        child: Text(text ?? '-'),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16.0)),
          side: BorderSide(
            color: getPrimaryColor(context),
          ),
        ),
        disabledTextColor: disabledColor,
        disabledBorderColor: disabledColor,
        highlightedBorderColor: getAccentColor(context),
        textColor: getAccentColor(context),
      );
    }
  }
}
