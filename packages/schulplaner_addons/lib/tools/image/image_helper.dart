import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class ImageCompresser {
  static Future<XFile?> compressImage(XFile image,
      {int compressionRate = 95}) async {
    final fileUri = Uri.file(image.path);
    String temporaryPath =
        (await getTemporaryDirectory()).path + fileUri.pathSegments.last;
    final file = await FlutterImageCompress.compressAndGetFile(
        image.path, temporaryPath,
        quality: compressionRate);
    return file != null ? XFile(file.path) : null;
  }

  static Future<XFile> compressVideo(XFile video,
      {int compressionRate = 95}) async {
    return video;
  }
}

class ImageHelper {
  static Future<XFile?> cropImage(XFile file) async {
    final croppedFile = await ImageCropper.cropImage(
      sourcePath: file.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
      ],
    );
    return croppedFile != null ? XFile(croppedFile.path) : null;
  }

  static Future<XFile?> pickImageCamera({
    double? maxWidth,
    double? maxHeight,
  }) async {
    final image = await ImagePicker().pickImage(
      source: ImageSource.camera,
      maxHeight: maxHeight,
      maxWidth: maxWidth,
    );
    return image;
  }

  static Future<XFile?> pickImageGallery({
    double? maxWidth,
    double? maxHeight,
  }) async {
    final image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxHeight: maxHeight,
      maxWidth: maxWidth,
    );
    return image;
  }
}
