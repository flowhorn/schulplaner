import 'package:flutter/material.dart';

class AssetButton extends StatelessWidget {
  final String assetPath;
  final VoidCallback onTap;
  final double height;

  const AssetButton({
    Key? key,
    required this.assetPath,
    required this.onTap,
    this.height = 64.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Image.asset(
        assetPath,
        height: height,
      ),
      onTap: onTap,
    );
  }
}
