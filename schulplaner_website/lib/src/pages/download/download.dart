import 'package:design_utils/design_utils.dart';
import 'package:flutter/material.dart';
import 'package:schulplaner_website/src/parts/inner_layout.dart';

import 'download_buttons.dart';

class DownloadPage extends StatelessWidget {
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
                  Icons.download_outlined,
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
          ),
          SizedBox(height: 128),
          ResponsiveSides(
            first: Column(
              children: [
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
              child: Image.asset(
                'assets/screenshots/screenshot_mobile1.png',
                width: 180.0,
              ),
            ),
          ),
          SizedBox(height: 128),
          ResponsiveSides(
            first: Center(
              child: Image.asset(
                'assets/screenshots/screenshot_desktop1.png',
                height: 240.0,
              ),
            ),
            second: Column(
              children: [
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
          ),
          SizedBox(height: 128),
        ],
      ),
    );
  }
}
