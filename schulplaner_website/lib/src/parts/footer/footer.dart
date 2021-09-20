import 'package:community_material_icon/community_material_icon.dart';
import 'package:design_utils/design_utils.dart';
import 'package:flutter/material.dart';
import 'package:schulplaner_website/src/logic/website_utils.dart';

import 'footer_links.dart';

class Footer extends StatelessWidget {
  const Footer();
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.secondary,
      width: double.infinity,
      child: Column(
        children: const [
          SizedBox(height: 64),
          ResponsiveSides(
            first: _Infos(),
            second: FooterLinks(),
          ),
          SizedBox(height: 64),
        ],
      ),
    );
  }
}

class _Infos extends StatelessWidget {
  const _Infos();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: const [
          _SchoolplannerLogo(),
          SizedBox(height: 16),
          _SocialMediaButtons(),
        ],
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
      ),
    );
  }
}

class _SchoolplannerLogo extends StatelessWidget {
  const _SchoolplannerLogo();
  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
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
    );
  }
}

class _SocialMediaButtons extends StatelessWidget {
  const _SocialMediaButtons();
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
