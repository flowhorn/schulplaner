import 'package:flutter/material.dart';

import 'navigation_drawer.dart';

class MobileScaffold extends StatelessWidget {
  final Widget body;

  const MobileScaffold({Key key, this.body}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _MobileAppBar(),
      body: body,
      endDrawer: NavigationDrawer(),
    );
  }
}

class _MobileAppBar extends StatelessWidget implements PreferredSizeWidget {
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
