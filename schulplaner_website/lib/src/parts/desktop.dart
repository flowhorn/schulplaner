import 'package:flutter/material.dart';

class DesktopScaffold extends StatelessWidget {
  final Widget body;

  const DesktopScaffold({Key key, this.body}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _DesktopAppBar(),
      body: body,
    );
  }
}

class _DesktopAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text('Schulplaner'),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(72);
}
