import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../../config/game_config.dart';

class ObstaclePair extends PositionComponent {
  ObstaclePair({required this.gapTop, required this.gapSize, required this.worldHeight, required super.position}) : super(size: Vector2(GameConfig.obstacleWidth, worldHeight));
  final double gapTop, gapSize, worldHeight; bool scored = false;
  Rect get topRect => Rect.fromLTWH(position.x, 0, size.x, gapTop);
  Rect get bottomRect => Rect.fromLTWH(position.x, gapTop + gapSize, size.x, worldHeight - gapTop - gapSize);
  bool hits(Rect bird) => topRect.overlaps(bird) || bottomRect.overlaps(bird);
  @override void render(Canvas canvas) { _drawPillar(canvas, 0, gapTop, false); _drawPillar(canvas, gapTop + gapSize, worldHeight - gapTop - gapSize, true); }
  void _drawPillar(Canvas c, double y, double height, bool fromBottom) { if (height <= 0) return; final r = Rect.fromLTWH(0, y, size.x, height); c.drawRRect(RRect.fromRectAndRadius(r, const Radius.circular(8)), Paint()..color = const Color(0xff7655d7)); c.drawRRect(RRect.fromRectAndRadius(r, const Radius.circular(8)), Paint()..color = GameConfig.ink..style = PaintingStyle.stroke..strokeWidth = 3); final capY = fromBottom ? y : y + height - 16; c.drawRRect(RRect.fromLTWH(-6, capY, size.x + 12, 16), const Radius.circular(5)), Paint()..color = const Color(0xff9a7af0)); }
}
