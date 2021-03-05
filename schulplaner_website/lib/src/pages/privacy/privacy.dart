import 'package:design_utils/design_utils.dart';
import 'package:flutter/material.dart';
import 'package:native_pdf_renderer/native_pdf_renderer.dart';
import 'package:schulplaner_website/src/logic/website_utils.dart';
import 'package:schulplaner_website/src/parts/inner_layout.dart';

class PrivacyPage extends StatelessWidget {
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
                  Icons.privacy_tip_outlined,
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
                  'Datenschutz!',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 12),
                Text(
                  'Schulplaner ist kein kommerzielles Produkt.\n'
                  'Alle erhobenen Daten dienen ausschließlich der Funktionalität von Schulplaner\n'
                  '-> Erfahre mehr darüber.',
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
          _PdfPrivacyPolicy(),
          SizedBox(height: 128),
        ],
        crossAxisAlignment: CrossAxisAlignment.start,
      ),
    );
  }
}

class _PdfPrivacyPolicy extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: LayoutBuilder(builder: (context, constraints) {
            final maxWidth = constraints.maxWidth;
            return Container(
              width: maxWidth * 0.8,
              child: FutureBuilder<PrivacyPolicyData>(
                future: getPrivacyPolicyData(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData || snapshot.data == null) {
                    return SizedBox(
                      height: 48,
                      width: 48,
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  final privacyPolicyData = snapshot.data!;
                  return Column(
                    children: [
                      ListTile(
                        leading: Icon(Icons.picture_as_pdf),
                        title: Text('Datenschutzerklärung'),
                        trailing: IconButton(
                          icon: Icon(Icons.download_outlined),
                          onPressed: () {
                            downloadFile(
                                'assets/privacy_policy_schulplaner.pdf',
                                'Schulplaner Datenschutzerklärung.pdf');
                          },
                        ),
                      ),
                      Image(
                        image: MemoryImage(privacyPolicyData.page1.bytes),
                      ),
                      Image(
                        image: MemoryImage(privacyPolicyData.page2.bytes),
                      ),
                    ],
                  );
                },
              ),
            );
          }),
        ),
      ),
    );
  }
}

class PrivacyPolicyData {
  final PdfPageImage page1, page2;

  PrivacyPolicyData(this.page1, this.page2);
}

Future<PrivacyPolicyData> getPrivacyPolicyData() async {
  final document =
      await PdfDocument.openAsset('privacy_policy_schulplaner.pdf');
  final page1 = await document.getPage(1);
  final pageImage1 =
      await page1.render(width: page1.width * 3, height: page1.height * 3);
  final page2 = await document.getPage(2);
  final pageImage2 =
      await page2.render(width: page2.width * 3, height: page2.height * 3);
  return PrivacyPolicyData(
    pageImage1!,
    pageImage2!,
  );
}
