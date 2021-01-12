import 'package:design_utils/design_utils.dart';
import 'package:flutter/material.dart';
import 'package:schulplaner_website/src/logic/website_utils.dart';
import 'package:schulplaner_website/src/parts/inner_layout.dart';
import 'package:schulplaner_website/src/widgets/assets_button.dart';
import 'package:schulplaner_website/src/widgets/svg_button.dart';

final kPlayStoreURL =
    'https://play.google.com/store/apps/details?id=com.xla.school&hl=de';
final kAppstoreURL =
    'https://apps.apple.com/de/app/schulplaner-pro/id1425606459';
final kWebAppURL = 'https://schulplaner-beta.web.app';

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
                _DownloadButtons(),
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

class _DownloadButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _DownloadAndroid(),
        SizedBox(width: 8),
        _DownloadiOS(),
        SizedBox(width: 8),
        _OpenWebApp(),
      ],
      mainAxisAlignment: MainAxisAlignment.center,
    );
  }
}

class _DownloadAndroid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AssetButton(
      onTap: () {
        openUrl(
          urlString: kPlayStoreURL,
          openInNewWindow: true,
        );
      },
      assetPath: 'assets/badges/google-play-badge.png',
      height: 58.0,
    );
  }
}

class _DownloadiOS extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SvgButton(
      onTap: () {
        openUrl(
          urlString: kAppstoreURL,
          openInNewWindow: true,
        );
      },
      assetPath: 'assets/badges/Download_on_the_App_Store_Badge_DE_RGB_wht.svg',
      height: 40.0,
    );
  }
}

class _OpenWebApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AssetButton(
      onTap: () {
        openUrl(
          urlString: kWebAppURL,
          openInNewWindow: true,
        );
      },
      assetPath: 'assets/badges/open-web-app.png',
      height: 40.0,
    );
  }
}
