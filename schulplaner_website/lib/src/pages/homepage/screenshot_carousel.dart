import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

/// Zeigt einzelne Screenshots der App auf der Homepage
class ScreenshotCarousel extends StatelessWidget {
  const ScreenshotCarousel();
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400,
      width: 800,
      child: CarouselSlider(
        items: const [
          _ScreenshotImage(
            assetPath: 'assets/screenshots/screenshot_mobile1.png',
          ),
          _ScreenshotImage(
            assetPath: 'assets/screenshots/screenshot_mobile2.png',
          ),
          _ScreenshotImage(
            assetPath: 'assets/screenshots/screenshot_mobile3.png',
          ),
        ],
        options: CarouselOptions(
          autoPlay: true,
          enlargeCenterPage: true,
          aspectRatio: 1.6,
          viewportFraction: 0.3,
        ),
      ),
    );
  }
}

class _ScreenshotImage extends StatelessWidget {
  final String assetPath;

  const _ScreenshotImage({
    Key? key,
    required this.assetPath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 180,
      height: 415,
      child: Center(
        child: Image(
          image: AssetImage(assetPath),
          width: 180,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
