//
import 'package:flutter/material.dart';

class PageViewModel {
  /// Title of page
  ///
  /// @Default style `fontSize: 20.0, fontWeight: FontWeight.bold`
  final String title;

  /// Text of page (description)
  ///
  /// @Default style `fontSize: 18.0, fontWeight: FontWeight.normal`
  final String? bodytext;

  final Widget? body;

  /// Image of page
  final Widget? image;

  /// Footer
  final Widget? footer;

  /// Background page color
  ///
  /// @Default `Colors.white`
  final Color? pageColor;

  /// Progress indicator color
  ///
  /// @Default `Colors.blue`
  final Color progressColor;

  /// Progress indicator size
  ///
  /// @Default `Size.fromRadius(5.0)`
  final Size progressSize;

  /// TextStyle for title
  final TextStyle titleTextStyle;

  /// TextStyle for title
  final TextStyle bodyTextStyle;

  final bool isDetailed;

  PageViewModel({
    required this.title,
   this.body,
    this.bodytext,
    this.image,
    this.footer,
    this.pageColor,
    this.progressColor = Colors.lightBlue,
    this.progressSize = const Size.fromRadius(5.0),
    this.titleTextStyle = const TextStyle(
      fontSize: 19.0,
      fontWeight: FontWeight.bold,
    ),
    this.bodyTextStyle = const TextStyle(
      fontSize: 15.0,
      fontWeight: FontWeight.normal,
    ),
    this.isDetailed = false,
  });
}
