import 'package:color/color.dart' as colorlib;
import 'package:flutter/material.dart';

String getHex(Color c) {
  colorlib.RgbColor rgbcolor = colorlib.RgbColor(c.red, c.green, c.blue);
  return rgbcolor.toHexColor().toString();
}

Color fromHex(String? hex) {
  if (hex == null) return Colors.blue;
  colorlib.RgbColor primaryRgb = colorlib.HexColor(hex).toRgbColor();
  return Color.fromARGB(
      255, primaryRgb.r.toInt(), primaryRgb.g.toInt(), primaryRgb.b.toInt());
}
