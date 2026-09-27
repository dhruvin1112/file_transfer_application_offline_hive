import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../constants/ad_constants.dart';

class AdService {
  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  // Strict guard: ads must NEVER interrupt active file transfers
  bool _isTransferActive = false;
  void setTransferActive(bool active) {
    _isTransferActive = active;
  }

  InterstitialAd? _interstitialAd;
  bool _isInterstitialLoading = false;

  RewardedAd? _rewardedAd;
  bool _isRewardedLoading = false;

  /// Initializes the Google Mobile Ads SDK
  Future<void> init() async {
    if (_isInitialized) return;
    try {
      if (Platform.isAndroid || Platform.isIOS) {
        await MobileAds.instance.initialize();
        _isInitialized = true;
        loadInterstitialAd();
      }
    } catch (e) {
      debugPrint('AdService initialization error: $e');
    }
  }

  /// Creates and loads a BannerAd configured for non-intrusive UI placement
  BannerAd? createBannerAd({
    required void Function() onAdLoaded,
    required void Function(LoadAdError) onAdFailedToLoad,
  }) {
    if (!_isInitialized) return null;

    return BannerAd(
      adUnitId: AdConstants.bannerAdUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) => onAdLoaded(),
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          onAdFailedToLoad(error);
        },
      ),
    );
  }

  /// Loads an InterstitialAd in the background
  void loadInterstitialAd() {
    if (!_isInitialized || _isInterstitialLoading || _interstitialAd != null) {
      return;
    }

    _isInterstitialLoading = true;
    InterstitialAd.load(
      adUnitId: AdConstants.interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          _isInterstitialLoading = false;
          _interstitialAd!.fullScreenContentCallback =
              FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              _interstitialAd = null;
              loadInterstitialAd();
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              ad.dispose();
              _interstitialAd = null;
              loadInterstitialAd();
            },
          );
        },
        onAdFailedToLoad: (error) {
          _isInterstitialLoading = false;
          _interstitialAd = null;
          debugPrint('InterstitialAd failed to load: $error');
        },
      ),
    );
  }

  /// Shows an Interstitial Ad ONLY when appropriate (e.g. transfer completion)
  /// STRICT RULE: Interstitial ads will NEVER show while a transfer is active.
  void showInterstitialAd({void Function()? onAdClosed}) {
    if (_isTransferActive) {
      debugPrint('AdService: Interstitial suppressed. Transfer is currently active.');
      onAdClosed?.call();
      return;
    }

    if (_interstitialAd != null) {
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          _interstitialAd = null;
          onAdClosed?.call();
          loadInterstitialAd();
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          ad.dispose();
          _interstitialAd = null;
          onAdClosed?.call();
          loadInterstitialAd();
        },
      );
      _interstitialAd!.show();
    } else {
      onAdClosed?.call();
      loadInterstitialAd();
    }
  }

  /// Loads a RewardedAd in the background
  void loadRewardedAd() {
    if (!_isInitialized || _isRewardedLoading || _rewardedAd != null) return;

    _isRewardedLoading = true;
    RewardedAd.load(
      adUnitId: AdConstants.rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedAd = ad;
          _isRewardedLoading = false;
        },
        onAdFailedToLoad: (error) {
          _isRewardedLoading = false;
          _rewardedAd = null;
        },
      ),
    );
  }

  /// Disposes all loaded ads
  void dispose() {
    _interstitialAd?.dispose();
    _rewardedAd?.dispose();
  }
}
