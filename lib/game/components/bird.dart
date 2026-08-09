import 'dart:math';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../../config/game_config.dart';

class Bird extends PositionComponent {
  Bird({required super.position}) : super(size: Vector2(42, 32), anchor: Anchor.center);
  double velocityY = 0;
  double wingPhase = 0;
  bool alive = true;
  void flap() { if (alive) velocityY = GameConfig.flapVelocity; }
  @override void update(double dt) { super.update(dt); if (!alive) return; velocityY = min(GameConfig.maxFallVelocity, velocityY + GameConfig.gravity * dt); position.y += velocityY * dt; angle = (velocityY / 950).clamp(-.38, .72); wingPhase += dt * (velocityY < 0 ? 18 : 10); }
  Rect get hitbox => Rect.fromCenter(center: Offset(position.x, position.y), width: size.x * .68, height: size.y * .68);
  @override void render(Canvas canvas) {
    final body = Paint()..color = const Color(0xffffbd45); final outline = Paint()..color = GameConfig.ink..style = PaintingStyle.stroke..strokeWidth = 2.5;
    canvas.save(); canvas.translate(-size.x / 2, -size.y / 2);
    canvas.drawOval(Rect.fromLTWH(3, 3, 32, 25), body); canvas.drawOval(Rect.fromLTWH(3, 3, 32, 25), outline);
    final wingY = 15 + sin(wingPhase) * 5; final wing = Path()..moveTo(14, 17)..quadraticBezierTo(23, wingY - 9, 29, wingY + 4)..quadraticBezierTo(18, wingY + 8, 11, 20)..close();
    canvas.drawPath(wing, Paint()..color = const Color(0xfff58c3b)); canvas.drawPath(wing, outline);
    canvas.drawCircle(const Offset(26, 10), 4.2, Paint()..color = Colors.white); canvas.drawCircle(const Offset(27, 10), 1.8, Paint()..color = GameConfig.ink);
    final beak = Path()..moveTo(34, 15)..lineTo(42, 18)..lineTo(34, 21)..close(); canvas.drawPath(beak, Paint()..color = const Color(0xffff7757)); canvas.drawPath(beak, outline); canvas.restore();
  }
}
