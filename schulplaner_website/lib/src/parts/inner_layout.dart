import 'package:flutter/material.dart';

import 'footer.dart';

class InnerLayout extends StatelessWidget {
  final String title;
  final Widget content;

  const InnerLayout({Key key, this.title, this.content}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      hoverThickness: 12,
      thickness: 12,
      child: SingleChildScrollView(
        child: Column(
          children: [
            if (title != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            Padding(
              padding: EdgeInsets.all(16),
              child: content,
            ),
            Footer(),
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
      ),
    );
  }
}
