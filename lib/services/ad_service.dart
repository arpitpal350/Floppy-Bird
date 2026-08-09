import 'dart:async';
import 'package:unity_ads_plugin/unity_ads_plugin.dart';

/// Unity Ads service for production.
class AdService {
  // Unity Ads Android Game ID
  static const String androidGameId = '800111386';

  // Unity Ads placement IDs
  static const String interstitialUnitId = 'Interstitial_Android';
  static const String rewardedUnitId = 'Rewarded_Android';

  bool _ready = false;
  bool _interstitialLoaded = false;
  bool _rewardedLoaded = false;

  /// Initializes Unity Ads and preloads ads.
  Future<void> initialize() async {
    try {
      await UnityAds.init(
        gameId: androidGameId,
        testMode: false,
        onComplete: () {
          _ready = true;
        },
        onFailed: (_, __) {
          _ready = false;
        },
      );

      _ready = await UnityAds.isInitialized();

      if (_ready) {
        await _loadInterstitial();
        await _loadRewarded();
      }
    } catch (_) {
      _ready = false;
    }
  }

  /// Loads an interstitial ad.
  Future<void> _loadInterstitial() async {
    if (!_ready) return;

    try {
      await UnityAds.load(
        placementId: interstitialUnitId,
        onComplete: (_) {
          _interstitialLoaded = true;
        },
        onFailed: (_, __, ___) {
          _interstitialLoaded = false;
        },
      );
    } catch (_) {
      _interstitialLoaded = false;
    }
  }

  /// Loads a rewarded ad.
  Future<void> _loadRewarded() async {
    if (!_ready) return;

    try {
      await UnityAds.load(
        placementId: rewardedUnitId,
        onComplete: (_) {
          _rewardedLoaded = true;
        },
        onFailed: (_, __, ___) {
          _rewardedLoaded = false;
        },
      );
    } catch (_) {
      _rewardedLoaded = false;
    }
  }

  /// Shows an interstitial ad if one is loaded.
  Future<void> showInterstitialIfReady() async {
    if (!_ready || !_interstitialLoaded) return;

    _interstitialLoaded = false;

    try {
      await UnityAds.showVideoAd(
        placementId: interstitialUnitId,
        onComplete: (_) {
          _loadInterstitial();
        },
        onSkipped: (_) {
          _loadInterstitial();
        },
        onFailed: (_, __, ___) {
          _loadInterstitial();
        },
      );
    } catch (_) {
      _loadInterstitial();
    }
  }

  /// Shows a rewarded ad if one is loaded.
  ///
  /// Returns true only when the user watches the rewarded ad
  /// to completion.
  Future<bool> showRewardedIfReady() async {
    if (!_ready || !_rewardedLoaded) return false;

    _rewardedLoaded = false;

    final Completer<bool> result = Completer<bool>();

    try {
      await UnityAds.showVideoAd(
        placementId: rewardedUnitId,
        onComplete: (_) {
          _loadRewarded();

          if (!result.isCompleted) {
            result.complete(true);
          }
        },
        onSkipped: (_) {
          _loadRewarded();

          if (!result.isCompleted) {
            result.complete(false);
          }
        },
        onFailed: (_, __, ___) {
          _loadRewarded();

          if (!result.isCompleted) {
            result.complete(false);
          }
        },
      );
    } catch (_) {
      _loadRewarded();
      return false;
    }

    return result.future.timeout(
      const Duration(minutes: 2),
      onTimeout: () => false,
    );
  }
}
