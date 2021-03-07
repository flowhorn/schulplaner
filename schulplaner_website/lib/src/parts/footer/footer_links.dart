import 'package:flutter/material.dart';
import 'package:persist_theme/persist_theme.dart';
import 'package:schulplaner_website/src/models/navigation_item.dart';
import 'package:schulplaner_website/src/routes.dart';

class FooterLinks extends StatelessWidget {
  const FooterLinks();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        SizedBox(
          width: 200,
          child: DarkModeSwitch(),
        ),
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
