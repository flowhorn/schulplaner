import 'package:flutter/material.dart';
import 'package:persist_theme/ui/theme_widgets.dart';
import 'package:schulplaner_website/src/blocs/website_bloc.dart';
import 'package:schulplaner_website/src/models/navigation_item.dart';
import 'package:schulplaner_website/src/routes.dart';

class NavigationDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 16),
            _HomepageTile(),
            _DownloadTile(),
            _DonateTile(),
            _PrivacyTile(),
            _OpenSourceTile(),
            _ImpressumTile(),
            _AboutTile(),
            SizedBox(height: 16),
            Divider(),
            SizedBox(height: 16),
            DarkModeSwitch(),
          ],
        ),
      ),
    );
  }
}

class _HomepageTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _DrawerListTile(
      title: 'Übersicht',
      navigationItem: NavigationItem.homepage,
      iconData: Icons.home_outlined,
    );
  }
}

class _AboutTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _DrawerListTile(
      title: 'Über',
      navigationItem: NavigationItem.about,
      iconData: Icons.info_outline,
    );
  }
}

class _PrivacyTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _DrawerListTile(
      title: 'Datenschutz',
      navigationItem: NavigationItem.privacy,
      iconData: Icons.privacy_tip_outlined,
    );
  }
}

class _DownloadTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _DrawerListTile(
      title: 'Download',
      navigationItem: NavigationItem.download,
      iconData: Icons.download_outlined,
    );
  }
}

class _DonateTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _DrawerListTile(
      title: 'Spenden',
      navigationItem: NavigationItem.donate,
      iconData: Icons.favorite_outline,
    );
  }
}

class _ImpressumTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _DrawerListTile(
      title: 'Impressum',
      navigationItem: NavigationItem.impressum,
      iconData: Icons.contact_mail_outlined,
    );
  }
}

class _OpenSourceTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _DrawerListTile(
      title: 'Open Source',
      navigationItem: NavigationItem.opensource,
      iconData: Icons.code_outlined,
    );
  }
}

class _DrawerListTile extends StatelessWidget {
  final NavigationItem navigationItem;
  final String title;
  final IconData iconData;

  const _DrawerListTile({
    Key key,
    this.navigationItem,
    this.title,
    this.iconData,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final currentNavigationItem = WebsiteBloc.of(context).navigationItem;
    return ListTile(
      title: Text(
        title,
        style: TextStyle(
          color: currentNavigationItem == navigationItem
              ? Theme.of(context).accentColor
              : null,
        ),
      ),
      leading: Icon(
        iconData,
        color: currentNavigationItem == navigationItem
            ? Theme.of(context).accentColor
            : null,
      ),
      onTap: () {
        openNavigationPage(context, navigationItem);
      },
    );
  }
}
