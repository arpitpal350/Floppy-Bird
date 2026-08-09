import 'package:flutter_test/flutter_test.dart';
import 'package:floppy_bird/game/systems/difficulty_system.dart';
import 'package:floppy_bird/config/game_config.dart';

void main() {
  test('difficulty remains within fair configured bounds', () {
    final difficulty = DifficultySystem()..update(10000);
    expect(difficulty.speed, GameConfig.maxSpeed);
    expect(difficulty.gap, GameConfig.minGap);
    expect(difficulty.spawnInterval, greaterThanOrEqualTo(1.18));
  });
}
