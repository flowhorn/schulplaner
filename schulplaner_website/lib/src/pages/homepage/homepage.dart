import 'package:design_utils/design_utils.dart';
import 'package:flutter/material.dart';
import 'package:schulplaner_website/src/pages/download/download_buttons.dart';
import 'package:schulplaner_website/src/pages/homepage/screenshot_carousel.dart';
import 'package:schulplaner_website/src/parts/inner_layout.dart';

import 'information_cards.dart';
import 'learn_more.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InnerLayout(
      content: Column(
        children: [
          SizedBox(height: 128),
          ResponsiveSides(
            first: Center(
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
              children: [
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
          ),
          SizedBox(height: 128),
          ResponsiveSides(
            first: Column(
              children: [
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
          ),
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
