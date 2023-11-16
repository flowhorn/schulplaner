import 'package:flutter/material.dart';
import 'package:schulplaner_website/src/widgets/website_title.dart';

import 'navigation_drawer.dart';

class MobileScaffold extends StatelessWidget {
  final Widget body;

  const MobileScaffold({Key? key, required this.body}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const _MobileAppBar(),
      body: body,
      endDrawer: const WebsiteNavigationDrawer(),
    );
  }
}

class _MobileAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _MobileAppBar({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return AppBar(
      key: const Key('_MobileAppBar'),
      title: const WebsiteTitle(),
      elevation: 0,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(64);
}
