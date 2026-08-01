import 'dart:async' as async;

import 'package:flame/collisions.dart';
import 'package:flame/components.dart' hide Timer;
import 'package:flame/events.dart'; // TapCallbacks provides modern tap handling
import 'package:flame/game.dart' hide Timer;
import 'package:flutter/foundation.dart';

import '../overlays/game_over_overlay.dart';
import '../services/ad_service.dart';
import 'components/background.dart';
import 'components/bird.dart';
import 'components/ground.dart';
import 'components/pipe.dart';

enum GameStatus { playing, gameOver, adPaused }

class FlappyBirdGame extends FlameGame with TapCallbacks, HasCollisionDetection {
  FlappyBirdGame({required this.adService});

  final AdService adService;
  final score = ValueNotifier<int>(0);
  final _rng = _SeededRandom();
  GameStatus status = GameStatus.playing;
  late Bird bird;
  Ground? _ground;
  async.Timer? _pipeTimer;
  double get _groundHeight => 100;
  double get _playHeight => size.y - _groundHeight;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(ScrollingBackground(size: size));
    _ground = Ground(position: Vector2(0, size.y - _groundHeight), size: Vector2(size.x, _groundHeight));
    add(_ground!);
    bird = Bird(position: Vector2(size.x * .28, _playHeight * .48));
    add(bird);
    _startPipeTimer();
    adService.initialize(
      isGameActive: () => status == GameStatus.playing,
      pauseGame: pauseForInterstitial,
      resumeGame: resumeAfterInterstitial,
    );
  }

  void _startPipeTimer() {
    _pipeTimer?.cancel();
    _pipeTimer = async.Timer.periodic(const Duration(milliseconds: 1450), (_) {
      if (status == GameStatus.playing && isLoaded) _spawnPipe();
    });
  }

  void _spawnPipe() {
    const gap = 155.0;
    final topHeight = 70 + _rng.nextDouble() * (_playHeight - gap - 140);
    add(PipeGroup(x: size.x + 25, topHeight: topHeight, gap: gap, playHeight: _playHeight, onPassed: _incrementScore));
  }

  void _incrementScore() { score.value++; }

  @override
  void onTapDown(TapDownEvent event) {
    if (status == GameStatus.playing) bird.jump();
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (status != GameStatus.playing) return;
    if (bird.position.y - bird.size.y / 2 < 0 || bird.position.y + bird.size.y / 2 >= _playHeight) gameOver();
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (status == GameStatus.playing && (other is Ground || other is PipeGroup || other.parent is PipeGroup)) gameOver();
  }

  void gameOver() {
    if (status != GameStatus.playing) return;
    status = GameStatus.gameOver;
    pauseEngine();
    overlays.add(GameOverOverlay.id);
  }

  void restart() {
    overlays.remove(GameOverOverlay.id);
    score.value = 0;
    _removePipes();
    bird.position = Vector2(size.x * .28, _playHeight * .48);
    bird.velocityY = 0;
    bird.angle = 0;
    status = GameStatus.playing;
    resumeEngine();
  }

  void revive() {
    if (status != GameStatus.gameOver) return;
    overlays.remove(GameOverOverlay.id);
    _removePipes();
    bird.position.y = bird.position.y.clamp(60, _playHeight - 80).toDouble();
    bird.reviveBoost();
    status = GameStatus.playing;
    resumeEngine();
  }

  void _removePipes() {
    for (final pipe in children.whereType<PipeGroup>().toList()) { pipe.removeFromParent(); }
  }

  void pauseForInterstitial() {
    if (status != GameStatus.playing) return;
    status = GameStatus.adPaused;
    pauseEngine();
  }

  void resumeAfterInterstitial() {
    if (status != GameStatus.adPaused) return;
    status = GameStatus.playing;
    resumeEngine();
  }

  void disposeGame() {
    _pipeTimer?.cancel();
    score.dispose();
  }
}

/// Small deterministic PRNG keeps this example dependency-free.
class _SeededRandom {
  int _state = DateTime.now().microsecondsSinceEpoch & 0x7fffffff;
  double nextDouble() { _state = (1103515245 * _state + 12345) & 0x7fffffff; return _state / 0x7fffffff; }
}
