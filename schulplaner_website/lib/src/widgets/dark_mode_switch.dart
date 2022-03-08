import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';
import 'package:flutter/material.dart';

class DarkmodeSwitch extends StatelessWidget {
  final double? width;

  const DarkmodeSwitch({Key? key, this.width}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: ListTile(
        title: const Text('Dunkelmodus'),
        trailing: EasyDynamicThemeSwitch(),
      ),
    );
  }
}
