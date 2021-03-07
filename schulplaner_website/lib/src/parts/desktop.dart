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
      appBar: _DesktopAppBar(
        key: Key('_DesktopAppBar'),
      ),
      body: body,
      endDrawer: NavigationDrawer(),
    );
  }
}

class _DesktopAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _DesktopAppBar({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return AppBar(
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
      children: const [
        _HomepageTile(),
        SizedBox(width: 8),
        _DownloadTile(),
        SizedBox(width: 8),
        _AboutTile(),
        SizedBox(width: 8),
        _SupportTile(),
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

class _SupportTile extends StatelessWidget {
  const _SupportTile();
  @override
  Widget build(BuildContext context) {
    return _AppBarAction(
      iconData: Icons.favorite_outline,
      iconColor: Colors.red,
      title: 'Unterstützen',
      navigationItem: NavigationItem.donate,
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
  final IconData? iconData;
  final Color? iconColor;

  const _AppBarAction({
    Key? key,
    required this.navigationItem,
    required this.title,
    this.iconData,
    this.iconColor,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final currentNavigationItem = WebsiteBloc.of(context).navigationItem;
    if (iconData != null) {
      return TextButton.icon(
        icon: Icon(
          iconData,
          color: iconColor,
        ),
        label: Padding(
          padding: const EdgeInsets.all(4.0),
          child: _AppBarActionText(
            title: title,
            isCurrentPage: currentNavigationItem == navigationItem,
          ),
        ),
        onPressed: () {
          openNavigationPage(context, navigationItem);
        },
      );
    } else {
      return TextButton(
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: _AppBarActionText(
            title: title,
            isCurrentPage: currentNavigationItem == navigationItem,
          ),
        ),
        onPressed: () {
          openNavigationPage(context, navigationItem);
        },
        /* style: ButtonStyle(
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16.0)),
            side: BorderSide(
              color: currentNavigationItem == navigationItem
                  ? Theme.of(context).accentColor
                  : Colors.black,
            ),
          ),
        ),
      ),*/
      );
    }
  }
}

class _AppBarActionText extends StatelessWidget {
  final String title;
  final bool isCurrentPage;
  const _AppBarActionText({
    required this.title,
    required this.isCurrentPage,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          color: isCurrentPage
              ? Theme.of(context).accentColor
              : Theme.of(context).primaryTextTheme.bodyText1?.color,
        ),
      ),
    );
  }
}
