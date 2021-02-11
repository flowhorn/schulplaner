import 'package:meta/meta.dart';

class CloudPhoto {
  final String id;
  final String fullUrl, compUrl, thumbUrl;

  const CloudPhoto({
    required this.id,
    required this.fullUrl,
    required this.compUrl,
    required this.thumbUrl,
  });
}

class CloudPhotoConverter {
  static CloudPhoto fromJson(dynamic data) {
    if (data == null) return null;
    return CloudPhoto(
      id: data['id'],
      fullUrl: data['fullUrl'],
      compUrl: data['compUrl'],
      thumbUrl: data['thumbUrl'],
    );
  }

  static Map<String, dynamic> toJson(CloudPhoto cloudPhoto) {
    if (cloudPhoto == null) return null;
    return {
      'id': cloudPhoto.id,
      'fullUrl': cloudPhoto.fullUrl,
      'compUrl': cloudPhoto.compUrl,
      'thumbUrl': cloudPhoto.thumbUrl,
    };
  }
}
