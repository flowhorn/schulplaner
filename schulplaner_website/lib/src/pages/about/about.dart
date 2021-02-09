import 'package:design_utils/design_utils.dart';
import 'package:flutter/material.dart';
import 'package:schulplaner_website/src/parts/inner_layout.dart';

class AboutPage extends StatelessWidget {
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
                  Icons.info_outline,
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
                  'Über:',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 12),
                Text(
                  'Die Schulplaner App\n'
                  'Hier wird einiges an Text stehen :)\n',
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
