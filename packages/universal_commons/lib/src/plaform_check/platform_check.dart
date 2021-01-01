import 'platform.dart';
import 'implementation/stub.dart'
    if (dart.library.io) 'implementation/io.dart'
    if (dart.library.js) 'implementation/js.dart' as implementation;

class PlatformCheck {
  static get platform => _getPlatform();

  static bool get isAndroid => platform == CurrentPlatform.android;
  static bool get isIOS => platform == CurrentPlatform.iOS;
  static bool get isMacOS => platform == CurrentPlatform.macOS;
  static bool get isWeb => platform == CurrentPlatform.web;
  static bool get isAppleOS => isIOS || isMacOS;
  static bool get isMobile => isAndroid || isIOS;
}

CurrentPlatform _getPlatform() {
  return implementation.getPlatform();
}
