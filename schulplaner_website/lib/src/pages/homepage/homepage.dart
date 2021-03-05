import 'package:design_utils/design_utils.dart';
import 'package:flutter/material.dart';
import 'package:schulplaner_website/src/pages/download/download_buttons.dart';
import 'package:schulplaner_website/src/pages/homepage/screenshot_carousel.dart';
import 'package:schulplaner_website/src/parts/inner_layout.dart';

import 'information_cards.dart';
import 'learn_more.dart';

class HomePage extends StatelessWidget {
  const HomePage();
  @override
  Widget build(BuildContext context) {
    return InnerLayout(
      content: Column(
        children: const [
          SizedBox(height: 128),
          _FirstInformation(),
          SizedBox(height: 128),
          _SecondInformation(),
          SizedBox(height: 128),
          InformationCards(),
          SizedBox(height: 128),
          LearnMoreSection(),
          SizedBox(height: 128),
        ],
      ),
    );
  }
}

class _FirstInformation extends StatelessWidget {
  const _FirstInformation();
  @override
  Widget build(BuildContext context) {
    return ResponsiveSides(
      first: const Center(
        child: CircleAvatar(
          child: Icon(
            Icons.school_outlined,
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
            'Schulplaner',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 12),
          Text(
            'Die Schulplaner App\n'
            'Der intelligente Schulplaner\n'
            '- Gemeinsam den Schulalltag meistern!\n',
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

class _SecondInformation extends StatelessWidget {
  const _SecondInformation();
  @override
  Widget build(BuildContext context) {
    return ResponsiveSides(
      first: Column(
        children: const [
          Text(
            'Wie gemacht für die Schule',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 12),
          Text(
            'Eine App - mit zahlreichen Funktionen\n'
            '- Hausaufgaben, Stundenplan, Noten\n'
            '& vieles mehr! Alles in einer App!\n',
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
      second: ScreenshotCarousel(),
    );
  }
}
