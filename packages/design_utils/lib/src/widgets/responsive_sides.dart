import 'package:flutter/material.dart';

/// 2 Widgets next to each other (horizontal), but if the space is smaller than the breakpoint they will be adjusted vertically
class ResponsiveSides extends StatelessWidget {
  final double breakPoint;
  final Widget first, second;

  const ResponsiveSides({
    Key? key,
    this.breakPoint = 700,
    required this.first,
    required this.second,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;
        final isWideEnough = maxWidth >= breakPoint;
        if (isWideEnough) {
          return _RowAlignment(
            first: first,
            second: second,
          );
        } else {
          return _ColumnAlignment(
            first: first,
            second: second,
          );
        }
      },
    );
  }
}

class _RowAlignment extends StatelessWidget {
  final Widget first, second;

  const _RowAlignment({Key? key, required this.first, required this.second})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(child: first),
        Flexible(child: second),
      ],
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
    );
  }
}

class _ColumnAlignment extends StatelessWidget {
  final Widget first, second;

  const _ColumnAlignment({Key? key, required this.first, required this.second})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        first,
        SizedBox(height: 16),
        second,
      ],
      crossAxisAlignment: CrossAxisAlignment.center,
    );
  }
}
