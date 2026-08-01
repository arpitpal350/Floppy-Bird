import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class Bird extends PositionComponent with CollisionCallbacks {
  Bird({required Vector2 position}) : super(position: position, size: Vector2(38, 28), anchor: Anchor.center);

  static const gravity = 950.0;
  static const jumpVelocity = -360.0;
  double velocityY = 0;

  @override
  Future<void> onLoad() async {
    await add(RectangleHitbox());
  }

  void jump() => velocityY = jumpVelocity;
  void reviveBoost() => velocityY = jumpVelocity * 0.65;

  @override
  void update(double dt) {
    super.update(dt);
    velocityY += gravity * dt;
    position.y += velocityY * dt;
    angle = (velocityY / 900).clamp(-0.45, 0.8).toDouble();
  }

  @override
  void render(Canvas canvas) {
    final body = Paint()..color = const Color(0xFFFFD43B);
    final wing = Paint()..color = const Color(0xFFFFA000);
    final eye = Paint()..color = const Color(0xFF1E293B);
    canvas.drawOval(size.toRect(), body);
    canvas.drawOval(Rect.fromLTWH(5, 14, 17, 10), wing);
    canvas.drawCircle(Offset(size.x - 10, 8), 4, Paint()..color = const Color(0xFFFFFFFF));
    canvas.drawCircle(Offset(size.x - 9, 8), 1.8, eye);
    canvas.drawPath(Path()..moveTo(size.x, 13)..lineTo(size.x + 9, 17)..lineTo(size.x, 20)..close(), Paint()..color = const Color(0xFFFF7043));
  }
}
