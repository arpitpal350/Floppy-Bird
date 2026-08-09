import 'dart:math';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../../config/game_config.dart';

class Bird extends PositionComponent {
  Bird({
    required super.position,
  }) : super(
          size: Vector2(42.0, 32.0),
          anchor: Anchor.center,
        );

  double velocityY = 0.0;
  double wingPhase = 0.0;
  bool alive = true;

  void flap() {
    if (!alive) {
      return;
    }

    velocityY = GameConfig.flapVelocity;
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (!alive) {
      return;
    }

    velocityY = min(
      GameConfig.maxFallVelocity,
      velocityY + GameConfig.gravity * dt,
    );

    position.y += velocityY * dt;

    angle = (velocityY / 950.0).clamp(
      -0.38,
      0.72,
    );

    wingPhase += dt * (
      velocityY < 0.0 ? 18.0 : 10.0
    );
  }

  Rect get hitbox {
    return Rect.fromCenter(
      center: Offset(
        position.x,
        position.y,
      ),
      width: size.x * 0.68,
      height: size.y * 0.68,
    );
  }

  @override
  void render(Canvas canvas) {
    final bodyPaint = Paint()
      ..color = const Color(0xffffbd45);

    final outlinePaint = Paint()
      ..color = GameConfig.ink
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;

    canvas.save();

    canvas.translate(
      -size.x / 2.0,
      -size.y / 2.0,
    );

    // Body
    final bodyRect = Rect.fromLTWH(
      3.0,
      3.0,
      32.0,
      25.0,
    );

    canvas.drawOval(
      bodyRect,
      bodyPaint,
    );

    canvas.drawOval(
      bodyRect,
      outlinePaint,
    );

    // Wing
    final double wingY = 15.0 + sin(wingPhase) * 5.0;

    final wingPath = Path()
      ..moveTo(14.0, 17.0)
      ..quadraticBezierTo(
        23.0,
        wingY - 9.0,
        29.0,
        wingY + 4.0,
      )
      ..quadraticBezierTo(
        18.0,
        wingY + 8.0,
        11.0,
        20.0,
      )
      ..close();

    final wingPaint = Paint()
      ..color = const Color(0xfff58c3b);

    canvas.drawPath(
      wingPath,
      wingPaint,
    );

    canvas.drawPath(
      wingPath,
      outlinePaint,
    );

    // Eye
    canvas.drawCircle(
      const Offset(26.0, 10.0),
      4.2,
      Paint()..color = Colors.white,
    );

    canvas.drawCircle(
      const Offset(27.0, 10.0),
      1.8,
      Paint()..color = GameConfig.ink,
    );

    // Beak
    final beakPath = Path()
      ..moveTo(34.0, 15.0)
      ..lineTo(42.0, 18.0)
      ..lineTo(34.0, 21.0)
      ..close();

    final beakPaint = Paint()
      ..color = const Color(0xffff7757);

    canvas.drawPath(
      beakPath,
      beakPaint,
    );

    canvas.drawPath(
      beakPath,
      outlinePaint,
    );

    canvas.restore();
  }
}
