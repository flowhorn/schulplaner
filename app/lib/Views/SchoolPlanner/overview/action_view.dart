import 'package:flutter/material.dart';
import 'package:schulplaner8/Helper/helper_views.dart';
import 'package:schulplaner_widgets/schulplaner_forms.dart';
import 'package:schulplaner_widgets/schulplaner_theme.dart';

class ActionView extends StatelessWidget {
  final IconData iconData;
  final String text;
  final Color color;
  final VoidCallback onTap;

  const ActionView({
    required this.iconData,
    required this.text,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 104.0,
      child: InkWell(
        child: Padding(
          padding:
              EdgeInsets.only(top: 6.0, bottom: 6.0, left: 8.0, right: 8.0),
          child: Column(
            children: <Widget>[
              ColoredCircleIcon(
                icon: Icon(
                  iconData,
                  color: getTextColor(color),
                ),
                color: color,
                radius: 28.0,
              ),
              FormSpace(6.0),
              Text(
                text,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w300,
                  fontSize: 15.5,
                ),
              ),
            ],
            mainAxisAlignment: MainAxisAlignment.center,
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}
