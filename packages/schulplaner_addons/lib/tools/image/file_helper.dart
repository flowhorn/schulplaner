import 'package:file_picker/file_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

class FileHelper {
  Future<XFile?> pickFile() async {
    final filePickerResult = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      withData: true,
    );
    if (filePickerResult?.files.isNotEmpty ?? false) {
      return XFile(filePickerResult!.files.first.path!);
    } else {
      return null;
    }
  }
}
