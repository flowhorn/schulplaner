import 'package:universal_commons/platform_check.dart';
import 'package:url_launcher/url_launcher.dart';

abstract class DownloadService {
  Future<bool> downloadFromUrl(String url);
}

class MockDownloadService implements DownloadService {
  @override
  Future<bool> downloadFromUrl(String url) {
    if (PlatformCheck.isWeb) {
      return launch(url);
    }
    return launch(url);
  }
}
