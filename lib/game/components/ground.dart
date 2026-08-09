import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../../config/game_config.dart';

class Ground extends PositionComponent {
  Ground({
    required super.position,
    required super.size,
  });

  double offset = 0.0;

  void move(double amount) {
    offset = (offset + amount) % 24.0;
  }

  @override
  void render(Canvas canvas) {
    // Main ground
    canvas.drawRect(
      size.toRect(),
      Paint()..color = const Color(0xff5dbb63),
    );

    // Top grass section
    canvas.drawRect(
      Rect.fromLTWH(
        0.0,
        0.0,
        size.x,
        9.0,
      ),
      Paint()..color = const Color(0xffa6df69),
    );

    // Moving ground details
    final detailPaint = Paint()
      ..color = const Color(0xff439650);

    for (
      double x = -offset;
      x < size.x;
      x += 24.0
    ) {
      canvas.drawRect(
        Rect.fromLTWH(
          x,
          18.0,
          12.0,
          5.0,
        ),
        detailPaint,
      );
    }

    // Ground outline
    final outlinePaint = Paint()
      ..color = GameConfig.ink
      ..strokeWidth = 3.0;

    canvas.drawLine(
      const Offset(0.0, 0.0),
      Offset(size.x, 0.0),
      outlinePaint,
    );
  }
}
