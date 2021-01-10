import 'package:flutter/material.dart';

/// 2 Widgets next to each other (horizontal), but if the space is smaller than the breakpoint they will be adjusted vertically
class ResponsiveSides extends StatelessWidget {
  final double breakPoint;
  final Widget first, second;

  const ResponsiveSides({
    Key key,
    this.breakPoint = 700,
    this.first,
    this.second,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;
        final isWideEnough = maxWidth >= breakPoint;
        if (isWideEnough) {
          return Row(
            children: [
              Flexible(child: first),
              Flexible(child: second),
            ],
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
          );
        } else {
          return Column(
            children: [
              first,
              SizedBox(height: 16),
              second,
            ],
            crossAxisAlignment: CrossAxisAlignment.center,
          );
        }
      },
    );
  }
}
