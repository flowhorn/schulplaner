import 'package:flutter/material.dart';

/// A rectangular Button with border
class RButton extends StatelessWidget {
  const RButton({
    Key? key,
    this.text,
    this.iconData,
    this.onTap,
    this.enabled = true,
    this.disabledColor,
  }) : super(key: key);
  final String? text;
  final IconData? iconData;
  final VoidCallback? onTap;
  final bool enabled;
  final Color? disabledColor;

  @override
  Widget build(BuildContext context) {
    if (iconData != null) {
      return OutlinedButton.icon(
        onPressed: enabled == true ? onTap : null,
        icon: Icon(
          iconData,
          color: enabled ? null : disabledColor,
        ),
        label: Text(text ?? '-'),
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(16.0),
            ),
          ),
        ),
      );
    } else {
      return OutlinedButton(
        onPressed: enabled == true ? onTap : null,
        child: Text(text ?? '-'),
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(16.0),
            ),
          ),
        ),
      );
    }
  }
}
