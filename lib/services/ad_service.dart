import 'dart:async';
import 'package:unity_ads_plugin/unity_ads_plugin.dart';

/// Owns Unity Ads lifecycles for Floppy Bird.
class AdService {
  static const _gameId = '800111386';
  static const _interstitialPlacementId = 'Interstitial_Android';
  static const _rewardedPlacementId = 'Rewarded_Android';

  Timer? _interstitialTimer;
  bool _showingInterstitial = false;

  void initialize({
    required bool Function() isGameActive,
    required void Function() pauseGame,
    required void Function() resumeGame,
  }) {
    UnityAds.init(
      gameId: _gameId,
      testMode: false, // REAL ADS
      onComplete: () => print('✅ Unity Ads Initialized for Floppy Bird!'),
      onFailed: (error, message) => print('❌ Unity Ads Init Failed: $message'),
    );

    _interstitialTimer?.cancel();
    _interstitialTimer = Timer.periodic(const Duration(minutes: 2), (_) {
      if (isGameActive()) {
        showInterstitial(pauseGame: pauseGame, resumeGame: resumeGame);
      }
    });
  }

  void showInterstitial({
    required void Function() pauseGame,
    required void Function() resumeGame,
  }) {
    if (_showingInterstitial) return;

    _showingInterstitial = true;
    pauseGame();

    UnityAds.showVideoAd(
      placementId: _interstitialPlacementId,
      onStart: (placementId) => print('Interstitial Started'),
      onClick: (placementId) => print('Interstitial Clicked'),
      onSkipped: (placementId) {
        _showingInterstitial = false;
        resumeGame();
      },
      onComplete: (placementId) {
        _showingInterstitial = false;
        resumeGame();
      },
      onFailed: (placementId, error, message) {
        print('❌ Interstitial Failed: $message');
        _showingInterstitial = false;
        resumeGame();
      },
    );
  }

  /// Calls [onRewardEarned] only after the user finishes watching the video.
  void showRewardedAd({required void Function() onRewardEarned}) {
    UnityAds.showVideoAd(
      placementId: _rewardedPlacementId,
      onComplete: (placementId) {
        print('✅ Rewarded Ad Watched Successfully!');
        onRewardEarned();
      },
      onFailed: (placementId, error, message) {
        print('❌ Rewarded Ad Failed: $message');
      },
    );
  }

  void dispose() {
    _interstitialTimer?.cancel();
  }
}
