import '../../config/game_config.dart';

class DifficultySystem {
  double elapsed = 0;
  void reset() => elapsed = 0;
  void update(double dt) => elapsed += dt;
  double get speed => (GameConfig.initialSpeed + elapsed * 3.2).clamp(GameConfig.initialSpeed, GameConfig.maxSpeed);
  double get gap => (GameConfig.maxGap - elapsed * 1.1).clamp(GameConfig.minGap, GameConfig.maxGap);
  double get spawnInterval => (1.72 - elapsed * .006).clamp(1.18, 1.72);
}
