import 'package:flutter/material.dart';
import 'package:schulplaner_translations/schulplaner_translations.dart';

class Choice {
  dynamic id;
  String name;
  IconData? iconData;

  Choice(this.id, this.name, {this.iconData});
}

List<Choice> getGradeTypes(BuildContext context) {
  return [
    Choice(0, getString(context).task, iconData: Icons.class_),
    Choice(1, getString(context).exam, iconData: Icons.class_),
    Choice(2, getString(context).oralexam, iconData: Icons.speaker),
    Choice(3, getString(context).test, iconData: Icons.text_fields),
    Choice(4, getString(context).other, iconData: Icons.all_out),
    Choice(5, getString(context).generalparticipation,
        iconData: Icons.pan_tool),
  ];
}
