import 'package:flutter/material.dart';

abstract final class GameConfig {
  static const String title = 'Floppy Bird';
  static const double groundHeight = 92;
  static const double birdXFraction = .28;
  static const double gravity = 1180;
  static const double flapVelocity = -430;
  static const double maxFallVelocity = 620;
  static const double initialSpeed = 190;
  static const double maxSpeed = 330;
  static const double obstacleWidth = 60;
  static const double minGap = 176;
  static const double maxGap = 232;
  static const Color skyTop = Color(0xff72d9ff);
  static const Color skyBottom = Color(0xffd5f6ff);
  static const Color ink = Color(0xff17324d);
}
