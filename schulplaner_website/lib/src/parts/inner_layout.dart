import 'package:flutter/material.dart';
import 'footer/footer.dart';

class InnerLayout extends StatelessWidget {
  final Widget content;

  const InnerLayout({
    Key? key,
    required this.content,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      thickness: 12,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: content,
            ),
            const Footer(),
          ],
        ),
      ),
    );
  }
}
