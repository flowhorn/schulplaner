import 'package:design_utils/design_utils.dart';
import 'package:flutter/material.dart';
import 'package:schulplaner_website/src/parts/inner_layout.dart';

import 'download_buttons.dart';

class DownloadPage extends StatelessWidget {
  const DownloadPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InnerLayout(
      key: const ValueKey('DownloadPageContent'),
      content: Column(
        children: const [
          SizedBox(height: 128),
          _FirstSection(),
          SizedBox(height: 128),
          _SecondSection(),
          SizedBox(height: 128),
          _ThirdSection(),
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
      first: const Center(
        child: CircleAvatar(
          child: Icon(
            Icons.download_outlined,
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
            'Ein Planer. Für alle Geräte!',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 12),
          Text(
            'Schulplaner ist auf Android & iOS kostenlos verfügbar.\n'
            'Außerdem kannst du ganz bequem von jedem Browser aus die Webapp öffnen.',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 32),
          DownloadButtons(),
        ],
        crossAxisAlignment: CrossAxisAlignment.center,
      ),
    );
  }
}

class _SecondSection extends StatelessWidget {
  const _SecondSection();
  @override
  Widget build(BuildContext context) {
    return ResponsiveSides(
      first: Column(
        children: const [
          Text(
            'Für Mobile Geräte!',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 12),
          Text(
            'Schulplaner ist optimiert für mobile Geräte.\n'
            'Alles ist übersichtlich, und trotzdem umfangreich.\n'
            'Praktisch: Du kannst die App auch ohne Internetverbindung verwenden\n'
            ' - im Anschluss wird alles wie gewohnt synchronisiert.',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 32),
        ],
        crossAxisAlignment: CrossAxisAlignment.center,
      ),
      second: Center(
        child: _Mobile1Screenshot(),
      ),
    );
  }
}

class _ThirdSection extends StatelessWidget {
  const _ThirdSection();
  @override
  Widget build(BuildContext context) {
    return ResponsiveSides(
      first: const Center(
        child: _Desktop1Screenshot(),
      ),
      second: Column(
        children: const [
          Text(
            'Professionell! Für den Desktop!',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 12),
          Text(
            'Ob am Desktop oder auch auf dem Tablet.\n'
            'Schulplaner passt die Ansicht optimal ans Endgerät an.\n'
            'Auf Funktionen musst du dabei nicht verzichten\n'
            ' - so kannst du noch effizienter deinen Schulalltag gestalten.',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 32),
        ],
        crossAxisAlignment: CrossAxisAlignment.center,
      ),
    );
  }
}

class _Mobile1Screenshot extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400,
      width: 200,
      child: Image.asset(
        'assets/screenshots/screenshot_mobile1.png',
        width: 200,
      ),
    );
  }
}

class _Desktop1Screenshot extends StatelessWidget {
  const _Desktop1Screenshot();
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      width: 400,
      child: Image.asset(
        'assets/screenshots/screenshot_desktop1.png',
        height: 250.0,
      ),
    );
  }
}
