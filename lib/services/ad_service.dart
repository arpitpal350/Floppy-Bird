import 'dart:async';

import 'package:google_mobile_ads/google_mobile_ads.dart';

/// Owns all ad lifecycles. Use test devices during development to avoid invalid traffic.
class AdService {
  static const _interstitialUnitId = 'ca-app-pub-2443131689614210/8842604358';
  static const _rewardedUnitId = 'ca-app-pub-2443131689614210/9169073267';
  InterstitialAd? _interstitialAd;
  RewardedAd? _rewardedAd;
  Timer? _interstitialTimer;
  bool _showingInterstitial = false;

  void initialize({required bool Function() isGameActive, required void Function() pauseGame, required void Function() resumeGame}) {
    loadInterstitial();
    loadRewarded();
    _interstitialTimer?.cancel();
    _interstitialTimer = Timer.periodic(const Duration(minutes: 2), (_) {
      if (isGameActive()) showInterstitial(pauseGame: pauseGame, resumeGame: resumeGame);
    });
  }

  void loadInterstitial() {
    if (_interstitialAd != null) return;
    InterstitialAd.load(
      adUnitId: _interstitialUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(onAdLoaded: (ad) => _interstitialAd = ad, onAdFailedToLoad: (_) => _interstitialAd = null),
    );
  }

  void loadRewarded() {
    if (_rewardedAd != null) return;
    RewardedAd.load(
      adUnitId: _rewardedUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(onAdLoaded: (ad) => _rewardedAd = ad, onAdFailedToLoad: (_) => _rewardedAd = null),
    );
  }

  void showInterstitial({required void Function() pauseGame, required void Function() resumeGame}) {
    final ad = _interstitialAd;
    if (ad == null || _showingInterstitial) {
      loadInterstitial();
      return;
    }
    _interstitialAd = null;
    _showingInterstitial = true;
    pauseGame();
    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) { ad.dispose(); _showingInterstitial = false; resumeGame(); loadInterstitial(); },
      onAdFailedToShowFullScreenContent: (ad, _) { ad.dispose(); _showingInterstitial = false; resumeGame(); loadInterstitial(); },
    );
    ad.show();
  }

  /// Calls [onRewardEarned] only after the SDK confirms the reward.
  void showRewardedAd({required void Function() onRewardEarned}) {
    final ad = _rewardedAd;
    if (ad == null) { loadRewarded(); return; }
    _rewardedAd = null;
    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) { ad.dispose(); loadRewarded(); },
      onAdFailedToShowFullScreenContent: (ad, _) { ad.dispose(); loadRewarded(); },
    );
    ad.show(onUserEarnedReward: (_, __) => onRewardEarned());
  }

  void dispose() { _interstitialTimer?.cancel(); _interstitialAd?.dispose(); _rewardedAd?.dispose(); }
}
