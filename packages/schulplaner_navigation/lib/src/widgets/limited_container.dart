import 'package:flutter/material.dart';

class LimitedContainer extends StatelessWidget {
  final Widget child;
  final double maxWidth;

  const LimitedContainer({Key? key, required this.child, this.maxWidth = 700})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: child,
      ),
    );
  }
}
