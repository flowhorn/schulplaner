import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class UrlImage extends StatelessWidget {
  UrlImage({
    Key key,
    required this.size,
    required this.url,
  }) : super(key: key);
  final double size;
  final String url;
  @override
  Widget build(BuildContext context) {
    if (url == null || url == '') {
      return StandardIcon(
        size: size,
      );
    }
    return ClipOval(
      clipBehavior: Clip.antiAlias,
      child: CachedNetworkImage(
        imageUrl: url,
        width: size,
        height: size,
        errorWidget: (_, _2, _3) => Text('Error'),
      ),
    );
  }
}

class StandardIcon extends StatelessWidget {
  const StandardIcon({Key key, required this.size}) : super(key: key);
  final double size;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      child: Icon(
        Icons.person,
        size: size / 2,
      ),
      radius: size / 2,
    );
  }
}
