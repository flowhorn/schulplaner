import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';
import 'package:flutter/material.dart';

class DarkmodeSwitch extends StatelessWidget {
  final double? width;
  const DarkmodeSwitch({this.width});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      child: ListTile(
        title: Text('Dunkelmodus'),
        trailing: EasyDynamicThemeSwitch(),
      ),
    );
  }
}
