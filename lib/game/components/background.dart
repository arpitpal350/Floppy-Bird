import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../../config/game_config.dart';

class Background extends PositionComponent {
  Background({
    required super.size,
  });

  double scroll = 0.0;

  @override
  void update(double dt) {
    super.update(dt);

    scroll = (scroll + dt * 18.0) % 130.0;
  }

  @override
  void render(Canvas canvas) {
    final backgroundRect = size.toRect();

    final backgroundPaint = Paint()
      ..shader = const LinearGradient(
        colors: [
          GameConfig.skyTop,
          GameConfig.skyBottom,
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(backgroundRect);

    canvas.drawRect(
      backgroundRect,
      backgroundPaint,
    );

    for (int i = -1; i < 7; i++) {
      final double x = i * 130.0 - scroll;
      final double y = 65.0 + (i % 3) * 72.0;

      _drawCloud(
        canvas,
        Offset(x, y),
      );
    }
  }

  void _drawCloud(
    Canvas canvas,
    Offset position,
  ) {
    final paint = Paint()
      ..color = Colors.white.withValues(
        alpha: 0.72,
      );

    canvas.drawCircle(
      position + const Offset(20.0, 14.0),
      13.0,
      paint,
    );

    canvas.drawCircle(
      position + const Offset(38.0, 8.0),
      18.0,
      paint,
    );

    canvas.drawCircle(
      position + const Offset(58.0, 16.0),
      12.0,
      paint,
    );

    final cloudRect = Rect.fromLTWH(
      position.dx + 10.0,
      position.dy + 14.0,
      62.0,
      17.0,
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        cloudRect,
        const Radius.circular(12.0),
      ),
      paint,
    );
  }
}
