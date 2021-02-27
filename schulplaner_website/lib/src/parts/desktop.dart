import 'package:flutter/material.dart';
import 'package:schulplaner_website/src/blocs/website_bloc.dart';
import 'package:schulplaner_website/src/models/navigation_item.dart';
import 'package:schulplaner_website/src/widgets/website_title.dart';

import '../routes.dart';
import 'navigation_drawer.dart';

class DesktopScaffold extends StatelessWidget {
  final Widget body;

  const DesktopScaffold({
    Key? key,
    required this.body,
  }) : super(key: key);
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
      key: Key('_DesktopAppBar'),
      title: WebsiteTitle(),
      elevation: 0,
      actions: const [
        _ActionsRow(),
        _EndDrawerButton(),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(64);
}

class _EndDrawerButton extends StatelessWidget {
  const _EndDrawerButton();
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.menu),
      onPressed: () {
        Scaffold.of(context).openEndDrawer();
      },
    );
  }
}

class _ActionsRow extends StatelessWidget {
  const _ActionsRow();
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _HomepageTile(),
        SizedBox(width: 8),
        _DownloadTile(),
        SizedBox(width: 8),
        _AboutTile(),
        SizedBox(width: 8),
      ],
    );
  }
}

class _HomepageTile extends StatelessWidget {
  const _HomepageTile();
  @override
  Widget build(BuildContext context) {
    return _AppBarAction(
      title: 'Übersicht',
      navigationItem: NavigationItem.homepage,
    );
  }
}

class _DownloadTile extends StatelessWidget {
  const _DownloadTile();
  @override
  Widget build(BuildContext context) {
    return _AppBarAction(
      title: 'Download',
      navigationItem: NavigationItem.download,
    );
  }
}

class _AboutTile extends StatelessWidget {
  const _AboutTile();
  @override
  Widget build(BuildContext context) {
    return _AppBarAction(
      title: 'Über',
      navigationItem: NavigationItem.about,
    );
  }
}

class _AppBarAction extends StatelessWidget {
  final NavigationItem navigationItem;
  final String title;

  const _AppBarAction({
    Key? key,
    required this.navigationItem,
    required this.title,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final currentNavigationItem = WebsiteBloc.of(context).navigationItem;
    return OutlineButton(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            color: currentNavigationItem == navigationItem
                ? Theme.of(context).accentColor
                : Theme.of(context).primaryTextTheme.bodyText1?.color,
          ),
        ),
      ),
      onPressed: () {
        openNavigationPage(context, navigationItem);
      },
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16.0)),
        side: BorderSide(
          color: currentNavigationItem == navigationItem
              ? Theme.of(context).accentColor
              : Colors.black,
        ),
      ),
    );
  }
}
