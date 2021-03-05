import 'package:design_utils/design_utils.dart';
import 'package:flutter/material.dart';
import 'package:schulplaner_website/src/logic/website_utils.dart';
import 'package:schulplaner_website/src/parts/inner_layout.dart';

class DonatePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InnerLayout(
      content: Column(
        children: [
          SizedBox(height: 128),
          ResponsiveSides(
            first: Center(
              child: CircleAvatar(
                child: Center(
                  child: Icon(
                    Icons.favorite_outline,
                    size: 72,
                    color: Colors.white,
                  ),
                ),
                backgroundColor: Colors.teal,
                radius: 72,
              ),
            ),
            second: Column(
              children: [
                Text(
                  'Spenden',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 12),
                Text(
                  'Die Schulplaner App ist komplett kostenlos und werbefrei!\n'
                  'Für die hilfreichen Online-Features der App entstehen jedoch jeden Monat Serverkosten.\n'
                  'Du kannst mitunterstützen, damit die App am Leben bleibt!',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 12),
                _PaypalMeButton(),
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

class _PaypalMeButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      child: Text('Zu Paypal weiterleiten'),
      onPressed: () {
        openUrl(
            urlString: 'https://www.paypal.com/paypalme/felixweuthen',
            openInNewWindow: true);
      },
      color: Colors.lightBlue,
    );
  }
}
