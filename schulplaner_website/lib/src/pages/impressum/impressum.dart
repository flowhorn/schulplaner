import 'package:design_utils/design_utils.dart';
import 'package:flutter/material.dart';
import 'package:schulplaner_website/src/parts/inner_layout.dart';

class ImpressumPage extends StatelessWidget {
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
                  Icons.contact_mail_outlined,
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
                  'Impressum:',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 12),
                Text(
                  'Felix Weuthen\n'
                  'Klosterstraße 50, 41747 Viersen\n'
                  'Email: danielfelixplay@gmail.com\n \n'
                  'Angaben gemäß § 5 TMG',
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
