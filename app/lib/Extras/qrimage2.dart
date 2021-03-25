import 'package:flutter/material.dart';
import 'package:qr/qr.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrImage2 extends StatelessWidget {
  QrImage2({
    required String data,
    this.size,
    this.padding = const EdgeInsets.all(10.0),
    this.backgroundColor,
    Color foregroundColor = const Color(0xFF000000),
    int version = 4,
    int errorCorrectionLevel = QrErrorCorrectLevel.L,
    this.gapless = false,
  }) : _painter = QrPainter(
          data: data,
          color: foregroundColor,
          version: version,
          errorCorrectionLevel: errorCorrectionLevel,
          gapless: gapless,
        );

  final QrPainter _painter;
  final Color? backgroundColor;
  final EdgeInsets padding;
  final double? size;
  final bool gapless;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      color: backgroundColor,
      child: Padding(
        padding: padding,
        child: CustomPaint(
          painter: _painter,
        ),
      ),
    );
  }
}
