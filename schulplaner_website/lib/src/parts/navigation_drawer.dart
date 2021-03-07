import 'package:flutter/material.dart';
import 'package:persist_theme/ui/theme_widgets.dart';
import 'package:schulplaner_website/src/blocs/website_bloc.dart';
import 'package:schulplaner_website/src/models/navigation_item.dart';
import 'package:schulplaner_website/src/routes.dart';

class NavigationDrawer extends StatelessWidget {
  const NavigationDrawer();
  @override
  Widget build(BuildContext context) {
    return const Drawer(
      child: SingleChildScrollView(
        child: _DrawerList(),
      ),
    );
  }
}

class _DrawerList extends StatelessWidget {
  const _DrawerList();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
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
    );
  }
}

class _HomepageTile extends StatelessWidget {
  const _HomepageTile();
  @override
  Widget build(BuildContext context) {
    return const _DrawerListTile(
      title: 'Übersicht',
      navigationItem: NavigationItem.homepage,
      iconData: Icons.home_outlined,
    );
  }
}

class _AboutTile extends StatelessWidget {
  const _AboutTile();
  @override
  Widget build(BuildContext context) {
    return const _DrawerListTile(
      title: 'Über',
      navigationItem: NavigationItem.about,
      iconData: Icons.info_outline,
    );
  }
}

class _PrivacyTile extends StatelessWidget {
  const _PrivacyTile();
  @override
  Widget build(BuildContext context) {
    return const _DrawerListTile(
      title: 'Datenschutz',
      navigationItem: NavigationItem.privacy,
      iconData: Icons.privacy_tip_outlined,
    );
  }
}

class _DownloadTile extends StatelessWidget {
  const _DownloadTile();
  @override
  Widget build(BuildContext context) {
    return const _DrawerListTile(
      title: 'Download',
      navigationItem: NavigationItem.download,
      iconData: Icons.download_outlined,
    );
  }
}

class _DonateTile extends StatelessWidget {
  const _DonateTile();
  @override
  Widget build(BuildContext context) {
    return const _DrawerListTile(
      title: 'Spenden',
      navigationItem: NavigationItem.donate,
      iconData: Icons.favorite_outline,
    );
  }
}

class _ImpressumTile extends StatelessWidget {
  const _ImpressumTile();
  @override
  Widget build(BuildContext context) {
    return const _DrawerListTile(
      title: 'Impressum',
      navigationItem: NavigationItem.impressum,
      iconData: Icons.contact_mail_outlined,
    );
  }
}

class _OpenSourceTile extends StatelessWidget {
  const _OpenSourceTile();
  @override
  Widget build(BuildContext context) {
    return const _DrawerListTile(
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
    Key? key,
    required this.navigationItem,
    required this.title,
    required this.iconData,
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
