import 'package:flutter/material.dart';
import 'package:schulplaner_website/src/parts/layout_title.dart';

import 'footer.dart';

class InnerLayout extends StatelessWidget {
  final String? title;
  final Widget content;

  const InnerLayout({
    Key? key,
    this.title,
    required this.content,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      hoverThickness: 12,
      thickness: 12,
      child: SingleChildScrollView(
        child: Column(
          children: [
            if (title != null)
              LayoutTitle(
                text: title!,
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
