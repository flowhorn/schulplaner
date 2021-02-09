import 'package:flutter/material.dart';
import 'package:schulplaner_website/src/logic/website_utils.dart';
import 'package:schulplaner_website/src/widgets/assets_button.dart';
import 'package:schulplaner_website/src/widgets/svg_button.dart';

final kPlayStoreURL =
    'https://play.google.com/store/apps/details?id=com.xla.school&hl=de';
final kAppstoreURL =
    'https://apps.apple.com/de/app/schulplaner-pro/id1425606459';
final kWebAppURL = 'https://schulplaner-beta.web.app';

class DownloadButtons extends StatelessWidget {
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
