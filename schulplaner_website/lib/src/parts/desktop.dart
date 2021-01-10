import 'package:flutter/material.dart';

import 'navigation_drawer.dart';

class DesktopScaffold extends StatelessWidget {
  final Widget body;

  const DesktopScaffold({Key key, this.body}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _DesktopAppBar(),
      body: body,
      endDrawer: NavigationDrawer(),
    );
  }
}

class _DesktopAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text('Schulplaner'),
      elevation: 0,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(72);
}
