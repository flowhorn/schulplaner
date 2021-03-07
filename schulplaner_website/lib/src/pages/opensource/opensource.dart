import 'package:design_utils/design_utils.dart';
import 'package:flutter/material.dart';
import 'package:schulplaner_website/src/logic/website_utils.dart';
import 'package:schulplaner_website/src/parts/inner_layout.dart';

class OpenSourcePage extends StatelessWidget {
  const OpenSourcePage();
  @override
  Widget build(BuildContext context) {
    return InnerLayout(
      key: ValueKey('OpenSourceContent'),
      content: Column(
        children: const [
          SizedBox(height: 128),
          _FirstSection(),
          SizedBox(height: 128),
        ],
      ),
    );
  }
}

class _FirstSection extends StatelessWidget {
  const _FirstSection();
  @override
  Widget build(BuildContext context) {
    return ResponsiveSides(
      first: Center(
        child: CircleAvatar(
          child: Icon(
            Icons.code_outlined,
            size: 72,
            color: Colors.white,
          ),
          backgroundColor: Colors.teal,
          radius: 72,
        ),
      ),
      second: Column(
        children: const [
          Text(
            'Open Source! Community!',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8),
          Text(
            'Der gesamte Source Code von Schulplaner ist Open Source.\n'
            'Alles ist einsehbar. Und ihr könnt euch an diesem Projekt beteiligen und mitmachen!\n'
            'Für Fragen, Anregungen, Kontakt und mehr kannst du die Community auf Discord erreichen.',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16),
          _RedirectButtons(),
        ],
        crossAxisAlignment: CrossAxisAlignment.center,
      ),
    );
  }
}

class _RedirectButtons extends StatelessWidget {
  const _RedirectButtons();
  @override
  Widget build(BuildContext context) {
    return ResponsiveList(
      breakPoint: 350,
      children: const [
        _OpenGithub(),
        SizedBox(width: 12, height: 12),
        _OpenDiscord(),
        SizedBox(width: 12, height: 12),
      ],
    );
  }
}

class _OpenGithub extends StatelessWidget {
  const _OpenGithub();
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: () {
        openUrl(
            urlString: 'https://github.com/flowhorn/schulplaner',
            openInNewWindow: true);
      },
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Text('Github (Source Code)'),
      ),
      color: Colors.green,
    );
  }
}

class _OpenDiscord extends StatelessWidget {
  const _OpenDiscord();
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: () {
        openUrl(
            urlString: 'https://discord.com/invite/uZyK7Tf',
            openInNewWindow: true);
      },
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Text('Discord (Community)'),
      ),
      color: Colors.orange,
    );
  }
}
