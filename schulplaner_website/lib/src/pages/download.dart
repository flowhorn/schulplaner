import 'package:design_utils/design_utils.dart';
import 'package:flutter/material.dart';
import 'package:schulplaner_website/src/parts/inner_layout.dart';

class DownloadPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InnerLayout(
      content: Column(
        children: [
          SizedBox(height: 32),
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
                SizedBox(height: 8),
                Text(
                  'Schulplaner ist auf Android & iOS kostenlos verfügbar.\n'
                  'Außerdem kannst du ganz bequem von jedem Browser aus die Webapp öffnen.',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16),
                _DownloadButtons(),
              ],
              crossAxisAlignment: CrossAxisAlignment.center,
            ),
          ),
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
        SizedBox(width: 12),
        _DownloadiOS(),
        SizedBox(width: 12),
        _OpenWebApp(),
      ],
      mainAxisAlignment: MainAxisAlignment.center,
    );
  }
}

class _DownloadAndroid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: () {},
      child: Text('Android'),
      color: Colors.blue,
    );
  }
}

class _DownloadiOS extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: () {},
      child: Text('iOS'),
      color: Colors.green,
    );
  }
}

class _OpenWebApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: () {},
      child: Text('Web-App'),
      color: Colors.orange,
    );
  }
}
