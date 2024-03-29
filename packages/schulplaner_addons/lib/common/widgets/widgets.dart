import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class RoundButton extends StatelessWidget {
  final String label;
  final void Function()? onTap;

  const RoundButton({
    Key? key,
    required this.label,
    this.onTap,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onTap,
      style: ButtonStyle(
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(8.0),
            ),
          ),
        ),
      ),
      child: Text(label),
    );
  }
}

class SheetIconButton extends StatelessWidget {
  const SheetIconButton({
    Key? key,
    required this.title,
    required this.iconData,
    required this.onTap,
    required this.tooltip,
    this.radius = 75.0,
  }) : super(key: key);

  final String title, tooltip;
  final double radius;
  final IconData iconData;

  /// The value, which will be returned by poping (Navigator.pop)
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: radius * 2,
      height: radius * 2,
      decoration: BoxDecoration(shape: BoxShape.circle),
      child: Tooltip(
        message: tooltip,
        child: InkWell(
          borderRadius: BorderRadius.all(Radius.circular(75.0)),
          onTap: onTap,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  width: radius,
                  height: radius,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey[300]!, width: 1.25),
                  ),
                  child:
                      Icon(iconData, size: radius / 2, color: Colors.grey[600]),
                ),
                const SizedBox(height: 8.0),
                Text(title, style: TextStyle(color: Colors.grey[600]))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
