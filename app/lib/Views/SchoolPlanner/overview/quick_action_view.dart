import 'package:flutter/material.dart';
import 'package:schulplaner8/Helper/helper_views.dart';
import 'package:schulplaner_widgets/schulplaner_forms.dart';
import 'package:schulplaner_widgets/schulplaner_theme.dart';

class QuickActionView extends StatelessWidget {
  final IconData iconData;
  final String text;
  final Color color;
  final VoidCallback onTap;

  const QuickActionView({
    required this.iconData,
    required this.text,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 72.0,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding:
              EdgeInsets.only(top: 3.0, bottom: 3.0, left: 6.0, right: 6.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ColoredCircleIcon(
                icon: Icon(
                  iconData,
                  color: getTextColor(color),
                ),
                color: color,
                radius: 20.0,
              ),
              FormSpace(4.0),
              Text(
                text,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w300,
                  fontSize: 13.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
