import 'package:flutter/material.dart';

class LimitedContainer extends StatelessWidget {
  final Widget child;

  const LimitedContainer({Key key, this.child}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 800),
        child: child,
      ),
    );
  }
}
