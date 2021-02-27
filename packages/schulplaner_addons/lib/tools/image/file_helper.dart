import 'dart:io';

import 'package:file_picker/file_picker.dart';

class FileHelper {
  Future<File?> pickFile() async {
    final filePickerResult = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      withData: true,
    );
    if (filePickerResult.files.isNotEmpty) {
      return File(filePickerResult.files.first.path);
    } else {
      return null;
    }
  }
}
