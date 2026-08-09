import 'dart:async';
import 'package:unity_ads_plugin/unity_ads_plugin.dart';

/// Keeps advertisements optional: failed SDK work never reaches gameplay.
class AdService {
  // Replace these before a production store release. Keep testMode true until then.
  static const androidGameId = 'YOUR_UNITY_ANDROID_GAME_ID';
  static const interstitialUnitId = 'YOUR_INTERSTITIAL_AD_UNIT_ID';
  static const rewardedUnitId = 'YOUR_REWARDED_AD_UNIT_ID';
  bool _ready = false;
  bool _interstitialLoaded = false;
  bool _rewardedLoaded = false;

  Future<void> initialize() async {
    if (androidGameId.startsWith('YOUR_')) return;
    try {
      await UnityAds.init(gameId: androidGameId, testMode: true, onComplete: () { _ready = true; }, onFailed: (_, __) { _ready = false; });
      _ready = await UnityAds.isInitialized();
      if (_ready) { await _loadInterstitial(); await _loadRewarded(); }
    } catch (_) { _ready = false; }
  }
  Future<void> _loadInterstitial() async {
    if (!_ready || interstitialUnitId.startsWith('YOUR_')) return;
    await UnityAds.load(placementId: interstitialUnitId, onComplete: (_) => _interstitialLoaded = true, onFailed: (_, __, ___) => _interstitialLoaded = false);
  }
  Future<void> _loadRewarded() async {
    if (!_ready || rewardedUnitId.startsWith('YOUR_')) return;
    await UnityAds.load(placementId: rewardedUnitId, onComplete: (_) => _rewardedLoaded = true, onFailed: (_, __, ___) => _rewardedLoaded = false);
  }
  Future<void> showInterstitialIfReady() async {
    if (!_interstitialLoaded) return;
    _interstitialLoaded = false;
    try { await UnityAds.showVideoAd(placementId: interstitialUnitId, onComplete: (_) { _loadInterstitial(); }, onSkipped: (_) { _loadInterstitial(); }, onFailed: (_, __, ___) { _loadInterstitial(); }); } catch (_) { _loadInterstitial(); }
  }
  Future<bool> showRewardedIfReady() async {
    if (!_rewardedLoaded) return false;
    final result = Completer<bool>(); _rewardedLoaded = false;
    try { await UnityAds.showVideoAd(placementId: rewardedUnitId, onComplete: (_) { _loadRewarded(); if (!result.isCompleted) result.complete(true); }, onSkipped: (_) { _loadRewarded(); if (!result.isCompleted) result.complete(false); }, onFailed: (_, __, ___) { _loadRewarded(); if (!result.isCompleted) result.complete(false); }); } catch (_) { _loadRewarded(); return false; }
    return result.future.timeout(const Duration(minutes: 2), onTimeout: () => false);
  }
}
