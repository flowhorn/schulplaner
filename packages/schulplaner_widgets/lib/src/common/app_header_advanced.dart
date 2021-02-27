//@dart=2.11
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:schulplaner_widgets/schulplaner_theme.dart';

class AppHeaderAdvanced extends StatelessWidget implements PreferredSizeWidget {
  final Widget title, leading;
  final List<Widget> actions;
  AppHeaderAdvanced({@required this.title, this.leading, this.actions});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        AppBar(
          centerTitle: true,
          title: title,
          leading: leading,
          actions: actions,
          elevation: 0.0,
        ),
        Divider(
          height: 1.0,
          color: getDividerColor(context),
        ),
      ],
      mainAxisSize: MainAxisSize.min,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(57.0);
}
