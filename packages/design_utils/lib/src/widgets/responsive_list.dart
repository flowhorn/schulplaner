import 'package:flutter/material.dart';

/// Widgets next to each other (horizontal), but if the space is smaller than the breakpoint they will be adjusted vertically
class ResponsiveList extends StatelessWidget {
  final double breakPoint;
  final List<Widget> children;

  const ResponsiveList({
    Key? key,
    this.breakPoint = 700,
    required this.children,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;
        final isWideEnough = maxWidth >= breakPoint;
        if (isWideEnough) {
          return _RowAlignment(
            children: children,
          );
        } else {
          return _ColumnAlignment(
            children: children,
          );
        }
      },
    );
  }
}

class _RowAlignment extends StatelessWidget {
  final List<Widget> children;

  const _RowAlignment({
    Key? key,
    required this.children,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      children: children,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
    );
  }
}

class _ColumnAlignment extends StatelessWidget {
  final List<Widget> children;

  const _ColumnAlignment({
    Key? key,
    required this.children,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: children,
      crossAxisAlignment: CrossAxisAlignment.center,
    );
  }
}
