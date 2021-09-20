import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:universal_commons/platform_check.dart';

class GetAdId {
  static String get donationRewardAd {
    if (PlatformCheck.isAndroid) {
      return dotenv.env['AD_ID_ANDROID_DONATION_REWARD'] ?? '';
    } else {
      return '';
    }
  }

  static String get standardBannerAd {
    if (PlatformCheck.isAndroid) {
      return dotenv.env['AD_ID_ANDROID_STANDARD_BANNER'] ?? '';
    } else {
      return '';
    }
  }
}
