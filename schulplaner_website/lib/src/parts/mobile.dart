import 'package:flutter/material.dart';
import 'package:schulplaner_website/src/widgets/website_title.dart';

import 'navigation_drawer.dart';

class MobileScaffold extends StatelessWidget {
  final Widget body;

  const MobileScaffold({Key? key, required this.body}) : super(key: key);
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
      key: Key('_MobileAppBar'),
      title: WebsiteTitle(),
      elevation: 0,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(64);
}
