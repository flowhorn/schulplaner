import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SvgButton extends StatelessWidget {
  final String assetPath;
  final VoidCallback onTap;
  final double height;

  const SvgButton({
    Key? key,
    required this.assetPath,
    required this.onTap,
    this.height = 64.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: SvgPicture.asset(
        assetPath,
        height: height,
      ),
      onTap: onTap,
    );
  }
}
