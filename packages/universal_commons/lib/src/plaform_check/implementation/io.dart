import 'dart:io' as io;
import '../platform.dart';

CurrentPlatform getPlatform() {
  if (io.Platform.isAndroid) return CurrentPlatform.android;
  if (io.Platform.isIOS) return CurrentPlatform.iOS;
  if (io.Platform.isMacOS) return CurrentPlatform.macOS;
  if (io.Platform.isWindows) return CurrentPlatform.windows;
  if (io.Platform.isLinux) return CurrentPlatform.linux;
  return CurrentPlatform.other;
}
