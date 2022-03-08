import 'package:flutter/material.dart';

class LayoutTitle extends StatelessWidget {
  final String text;

  const LayoutTitle({Key? key, required this.text}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
