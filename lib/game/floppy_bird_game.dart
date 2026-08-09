import 'dart:math';
import 'package:flame/game.dart';
import 'package:flame/events.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import '../config/game_config.dart';
import '../services/storage_service.dart';
import 'components/background.dart';
import 'components/bird.dart';
import 'components/ground.dart';
import 'components/obstacle.dart';
import 'systems/difficulty_system.dart';

enum GamePhase { menu, playing, paused, gameOver }
class FloppyBirdGame extends FlameGame with TapCallbacks, KeyboardEvents {
  FloppyBirdGame({required this.onPhaseChanged, required this.onScoreChanged, required this.onGameOver});
  final ValueChanged<GamePhase> onPhaseChanged; final ValueChanged<int> onScoreChanged; final void Function(int, int) onGameOver;
  final difficulty = DifficultySystem(); final storage = StorageService(); final random = Random(); final obstacles = <ObstaclePair>[];
  late Bird bird; late Ground ground; GamePhase phase = GamePhase.menu; double spawnClock = 0; int score = 0;
  @override Color backgroundColor() => GameConfig.skyTop;
  @override Future<void> onLoad() async { await super.onLoad(); add(Background(size: size)); ground = Ground(position: Vector2(0, size.y - GameConfig.groundHeight), size: Vector2(size.x, GameConfig.groundHeight)); add(ground); _makeBird(); }
  void _makeBird() { bird = Bird(position: Vector2(size.x * GameConfig.birdXFraction, size.y * .43)); add(bird); }
  void start() { _clearRound(); resumeEngine(); phase = GamePhase.playing; onPhaseChanged(phase); flap(); }
  void flap() { if (phase == GamePhase.playing) bird.flap(); }
  @override void onTapDown(TapDownEvent event) { flap(); }
  @override KeyEventResult onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    if (event is KeyDownEvent && event.logicalKey == LogicalKeyboardKey.space) flap();
    return KeyEventResult.handled;
  }
  void togglePause() { if (phase == GamePhase.playing) { phase = GamePhase.paused; pauseEngine(); } else if (phase == GamePhase.paused) { phase = GamePhase.playing; resumeEngine(); } onPhaseChanged(phase); }
  void resumeFromLifecycle() { if (phase == GamePhase.playing) { phase = GamePhase.paused; pauseEngine(); onPhaseChanged(phase); } }
  void _clearRound() { for (final o in obstacles) { o.removeFromParent(); } obstacles.clear(); bird.removeFromParent(); difficulty.reset(); score = 0; spawnClock = 1.1; _makeBird(); onScoreChanged(score); }
  @override void update(double dt) { super.update(dt); if (phase != GamePhase.playing) return; difficulty.update(dt); final speed = difficulty.speed; ground.move(speed * dt); spawnClock -= dt; if (spawnClock <= 0) { _spawn(); spawnClock = difficulty.spawnInterval; } for (final o in List.of(obstacles)) { o.position.x -= speed * dt; if (!o.scored && o.position.x + o.size.x < bird.position.x) { o.scored = true; score++; onScoreChanged(score); } if (o.hits(bird.hitbox)) { _end(); return; } if (o.position.x + o.size.x < -20) { obstacles.remove(o); o.removeFromParent(); } } if (bird.position.y - bird.size.y / 2 < 0 || bird.position.y + bird.size.y / 2 >= ground.position.y) _end(); }
  void _spawn() { final playable = ground.position.y; final gap = difficulty.gap; final minTop = 70.0; final maxTop = max(minTop, playable - gap - 70); final top = minTop + random.nextDouble() * (maxTop - minTop); final obstacle = ObstaclePair(gapTop: top, gapSize: gap, worldHeight: playable, position: Vector2(size.x + 30, 0)); obstacles.add(obstacle); add(obstacle); }
  Future<void> _end() async { if (phase != GamePhase.playing) return; bird.alive = false; phase = GamePhase.gameOver; pauseEngine(); final best = await storage.saveIfBest(score); onGameOver(score, best); onPhaseChanged(phase); }
}
