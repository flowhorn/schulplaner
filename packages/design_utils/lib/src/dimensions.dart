import 'package:flutter/material.dart';

final kDesktopModusBreakpoint = 700;

/// Gives Informations like [isDesktopModus] according to the current Window Size.
class Dimensions {
  final MediaQueryData _mediaQueryData;
  Dimensions._(this._mediaQueryData);

  factory Dimensions.of(BuildContext context) {
    return Dimensions._(MediaQuery.of(context));
  }

  bool get isDesktopModus =>
      _mediaQueryData.size.width > kDesktopModusBreakpoint;
}
