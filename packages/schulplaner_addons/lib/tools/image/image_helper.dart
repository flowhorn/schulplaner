import 'dart:io';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image/image.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class ImageCompresser {
  static Future<File?> compressImage(File image,
      {int compressionRate = 95}) async {
    String temporaryPath =
        (await getTemporaryDirectory()).path + image.uri.pathSegments.last;
    return FlutterImageCompress.compressAndGetFile(image.path, temporaryPath,
        quality: compressionRate);
  }

  static Future<File> compressVideo(File video,
      {int compressionRate = 95}) async {
    return video;
  }
}

class ImageHelper {
  static Future<File> resizeImage(File file, {int? width, int? height}) async {
    final image = decodeImage(file.readAsBytesSync());
    final thumbnail = copyResize(image!, width: width, height: height);
    String path =
        (await getTemporaryDirectory()).path + file.uri.pathSegments.last;
    return File(path)..writeAsBytesSync(encodePng(thumbnail));
  }

  static Future<File?> cropImage(File file) {
    return ImageCropper.cropImage(
      sourcePath: file.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
      ],
    );
  }

  static Future<File?> pickImageCamera({
    double? maxWidth,
    double? maxHeight,
  }) async {
    final image = await ImagePicker().pickImage(
      source: ImageSource.camera,
      maxHeight: maxHeight,
      maxWidth: maxWidth,
    );
    if (image != null) {
      return File(image.path);
    } else {
      return null;
    }
  }

  static Future<File?> pickImageGallery({
    double? maxWidth,
    double? maxHeight,
  }) async {
    final image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxHeight: maxHeight,
      maxWidth: maxWidth,
    );
    if (image != null) {
      return File(image.path);
    } else {
      return null;
    }
  }
}
