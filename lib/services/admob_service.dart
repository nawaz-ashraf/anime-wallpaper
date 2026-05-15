import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

/// Centralized AdMob service with clean architecture.
/// Manages banner, interstitial, and native ad lifecycle.
class AdmobService {
  AdmobService._();
  static final AdmobService instance = AdmobService._();

  // ─────────────────────────────────────────────
  // Test Ad Unit IDs (replace with production IDs)
  // ─────────────────────────────────────────────
  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/6300978111'; // Android test banner
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/2934735716'; // iOS test banner
    }
    return '';
  }

  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/1033173712'; // Android test interstitial
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/4411468910'; // iOS test interstitial
    }
    return '';
  }

  static String get nativeAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/2247696110'; // Android test native
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/3986624511'; // iOS test native
    }
    return '';
  }

  // ─────────────────────────────────────────────
  // State
  // ─────────────────────────────────────────────
  bool _isInitialized = false;
  InterstitialAd? _interstitialAd;
  bool _isInterstitialAdReady = false;
  int _interstitialCounter = 0;

  /// How many detail-view opens before showing an interstitial.
  static const int _interstitialFrequency = 4;

  // ─────────────────────────────────────────────
  // Initialization
  // ─────────────────────────────────────────────
  Future<void> initialize() async {
    if (_isInitialized) return;
    try {
      await MobileAds.instance.initialize();
      _isInitialized = true;
      debugPrint('[AdmobService] MobileAds initialized');
      _preloadInterstitial();
    } catch (e) {
      debugPrint('[AdmobService] Init error: $e');
    }
  }

  // ─────────────────────────────────────────────
  // Banner Ads
  // ─────────────────────────────────────────────
  BannerAd createBannerAd({
    AdSize adSize = AdSize.banner,
    Function? onLoaded,
    Function? onFailed,
  }) {
    return BannerAd(
      adUnitId: bannerAdUnitId,
      size: adSize,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          debugPrint('[AdmobService] Banner ad loaded');
          onLoaded?.call();
        },
        onAdFailedToLoad: (ad, error) {
          debugPrint('[AdmobService] Banner ad failed: ${error.message}');
          ad.dispose();
          onFailed?.call();
        },
        onAdOpened: (ad) => debugPrint('[AdmobService] Banner ad opened'),
        onAdClosed: (ad) => debugPrint('[AdmobService] Banner ad closed'),
      ),
    );
  }

  // ─────────────────────────────────────────────
  // Interstitial Ads (Frequency Controlled)
  // ─────────────────────────────────────────────
  void _preloadInterstitial() {
    InterstitialAd.load(
      adUnitId: interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          _isInterstitialAdReady = true;
          debugPrint('[AdmobService] Interstitial ad loaded');

          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              _isInterstitialAdReady = false;
              _preloadInterstitial(); // Preload next one
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              ad.dispose();
              _isInterstitialAdReady = false;
              _preloadInterstitial();
            },
          );
        },
        onAdFailedToLoad: (error) {
          debugPrint('[AdmobService] Interstitial failed: ${error.message}');
          _isInterstitialAdReady = false;
        },
      ),
    );
  }

  /// Call this when opening wallpaper detail view.
  /// Shows interstitial only every [_interstitialFrequency] opens.
  void onDetailViewOpened() {
    _interstitialCounter++;
    if (_interstitialCounter % _interstitialFrequency == 0) {
      showInterstitial();
    }
  }

  void showInterstitial() {
    if (_isInterstitialAdReady && _interstitialAd != null) {
      _interstitialAd!.show();
      _interstitialAd = null;
      _isInterstitialAdReady = false;
    } else {
      debugPrint('[AdmobService] Interstitial not ready, skipping');
      _preloadInterstitial();
    }
  }

  // ─────────────────────────────────────────────
  // Dispose
  // ─────────────────────────────────────────────
  void dispose() {
    _interstitialAd?.dispose();
    _interstitialAd = null;
    _isInterstitialAdReady = false;
  }
}
