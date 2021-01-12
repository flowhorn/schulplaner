import 'package:community_material_icon/community_material_icon.dart';
import 'package:design_utils/design_utils.dart';
import 'package:flutter/material.dart';
import 'package:schulplaner_website/src/logic/website_utils.dart';
import 'package:schulplaner_website/src/models/navigation_item.dart';
import 'package:schulplaner_website/src/routes.dart';

class Footer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).accentColor,
      width: double.infinity,
      child: Column(
        children: [
          SizedBox(height: 64),
          ResponsiveSides(
            first: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      SizedBox(width: 8),
                      Icon(Icons.school, size: 28),
                      SizedBox(width: 8),
                      Text(
                        'Schulplaner @2021',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ],
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                  ),
                  SizedBox(height: 16),
                  _SocialMediaButtons(),
                ],
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
              ),
            ),
            second: Column(
              children: [
                FlatButton(
                  child: Text('-> Datenschutzerklärung'),
                  onPressed: () {
                    openNavigationPage(context, NavigationItem.privacy);
                  },
                ),
                FlatButton(
                  child: Text('-> Impressum'),
                  onPressed: () {
                    openNavigationPage(context, NavigationItem.impressum);
                  },
                ),
                FlatButton(
                  child: Text('-> Über'),
                  onPressed: () {
                    openNavigationPage(context, NavigationItem.about);
                  },
                ),
              ],
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
            ),
          ),
          SizedBox(height: 64),
        ],
      ),
    );
  }
}

class _SocialMediaButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(width: 8),
        _Instagram(),
        SizedBox(width: 8),
        _Twitter(),
        SizedBox(width: 8),
        _Discord(),
      ],
    );
  }
}

class _Instagram extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(CommunityMaterialIcons.instagram),
      onPressed: () {
        openUrl(
            urlString: 'https://instagram.com/schulplaner.app',
            openInNewWindow: true);
      },
    );
  }
}

class _Twitter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(CommunityMaterialIcons.twitter),
      onPressed: () {
        openUrl(
            urlString: 'https://twitter.com/schulplanerapp',
            openInNewWindow: true);
      },
    );
  }
}

class _Discord extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(CommunityMaterialIcons.discord),
      onPressed: () {
        openUrl(
            urlString: 'https://discord.com/invite/uZyK7Tf',
            openInNewWindow: true);
      },
    );
  }
}
