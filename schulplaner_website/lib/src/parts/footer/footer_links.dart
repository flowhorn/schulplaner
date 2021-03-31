import 'package:flutter/material.dart';
import 'package:schulplaner_website/src/models/navigation_item.dart';
import 'package:schulplaner_website/src/routes.dart';
import 'package:schulplaner_website/src/widgets/dark_mode_switch.dart';

class FooterLinks extends StatelessWidget {
  const FooterLinks();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        DarkmodeSwitch(width: 250),
        _PrivacyPolicy(),
        _Imprint(),
        _About(),
      ],
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
    );
  }
}

class _PrivacyPolicy extends StatelessWidget {
  const _PrivacyPolicy();
  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: Text('-> Datenschutzerklärung'),
      onPressed: () {
        openNavigationPage(context, NavigationItem.privacy);
      },
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all(Colors.white),
      ),
    );
  }
}

class _Imprint extends StatelessWidget {
  const _Imprint();
  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: Text('-> Impressum'),
      onPressed: () {
        openNavigationPage(context, NavigationItem.impressum);
      },
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all(Colors.white),
      ),
    );
  }
}

class _About extends StatelessWidget {
  const _About();
  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: Text(
        '-> Über',
      ),
      onPressed: () {
        openNavigationPage(context, NavigationItem.about);
      },
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all(Colors.white),
      ),
    );
  }
}
