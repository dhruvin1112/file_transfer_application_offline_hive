import 'dart:io';

class AdConstants {
  AdConstants._();

  // Android Test Ad Unit IDs
  static const String androidBannerTestId =
      'ca-app-pub-3940256099942544/6300978111';
  static const String androidInterstitialTestId =
      'ca-app-pub-3940256099942544/1033173712';
  static const String androidRewardedTestId =
      'ca-app-pub-3940256099942544/5224354917';

  // iOS Test Ad Unit IDs
  static const String iosBannerTestId =
      'ca-app-pub-3940256099942544/2934735716';
  static const String iosInterstitialTestId =
      'ca-app-pub-3940256099942544/4411468910';
  static const String iosRewardedTestId =
      'ca-app-pub-3940256099942544/1712485313';

  // Platform adaptive ad unit ID getters (defaulting to test IDs in development)
  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return androidBannerTestId;
    } else if (Platform.isIOS) {
      return iosBannerTestId;
    }
    return '';
  }

  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return androidInterstitialTestId;
    } else if (Platform.isIOS) {
      return iosInterstitialTestId;
    }
    return '';
  }

  static String get rewardedAdUnitId {
    if (Platform.isAndroid) {
      return androidRewardedTestId;
    } else if (Platform.isIOS) {
      return iosRewardedTestId;
    }
    return '';
  }
}
