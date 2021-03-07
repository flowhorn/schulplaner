import 'package:flutter/material.dart';

import 'url_image.dart';

class AvatarImage extends StatelessWidget {
  const AvatarImage({
    Key? key,
    required this.avatarData,
    required this.size,
  }) : super(key: key);
  final String avatarData;
  final double size;

  @override
  Widget build(BuildContext context) {
    // Solange Avataaar nicht gefixt ist.
    return StandardIcon(
      size: size,
    );
    /*
    return AvataaarImage(
      avatar: avatarData == null
          ? Avataaar.random()
          : Avataaar.fromJson(avatarData),
      errorImage: Icon(Icons.person),
      placeholder: CircularProgressIndicator(),
      width: size,
    );
    */
  }
}
