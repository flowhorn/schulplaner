import 'package:cross_file/cross_file.dart';
import 'package:file_picker/file_picker.dart';
import 'package:universal_commons/platform_check.dart';

class FileHelper {
  Future<XFile?> pickFile() async {
    final filePickerResult = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      withData: true,
    );
    if (filePickerResult?.files.isNotEmpty ?? false) {
      if (PlatformCheck.isWeb) {
        return XFile.fromData(filePickerResult!.files.first.bytes!);
      } else {
        return XFile(filePickerResult!.files.first.path!);
      }
    } else {
      return null;
    }
  }
}
