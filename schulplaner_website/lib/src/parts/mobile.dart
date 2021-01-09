import 'package:flutter/material.dart';

class MobileScaffold extends StatelessWidget {
  final Widget body;

  const MobileScaffold({Key key, this.body}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _MobileAppBar(),
      body: body,
    );
  }
}

class _MobileAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text('Schulplaner'),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(72);
}
