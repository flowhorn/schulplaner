import 'package:flutter/material.dart';

import '../dimensions.dart';

/// Switches between Mobile and Desktop UI according to the current Window width
class ResponsiveUI extends StatelessWidget {
  final WidgetBuilder desktopBuilder;
  final WidgetBuilder mobileBuilder;

  const ResponsiveUI({Key key, this.desktopBuilder, this.mobileBuilder})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final dimensions = Dimensions.of(context);
    if (dimensions.isDesktopModus) {
      return desktopBuilder(context);
    } else {
      return mobileBuilder(context);
    }
  }
}
