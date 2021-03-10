import 'download_file_stub.dart'
    if (dart.library.js) 'download_file_js.dart'
    if (dart.library.io) 'download_file_io.dart' as implementation;

void downloadFile(String url, String name) {
  implementation.downloadFileImplementation(url, name);
}
