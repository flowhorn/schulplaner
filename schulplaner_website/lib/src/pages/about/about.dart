import 'package:design_utils/design_utils.dart';
import 'package:flutter/material.dart';
import 'package:schulplaner_website/src/parts/inner_layout.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InnerLayout(
      key: const ValueKey('AboutPageContent'),
      content: Column(
        children: const [
          SizedBox(height: 128),
          _FirstSection(),
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
            Icons.info_outline,
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
    );
  }
}
