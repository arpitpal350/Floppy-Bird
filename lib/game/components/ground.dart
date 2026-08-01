import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class Ground extends PositionComponent with CollisionCallbacks {
  Ground({required Vector2 position, required Vector2 size}) : super(position: position, size: size);
  double _offset = 0;

  @override
  Future<void> onLoad() async => add(RectangleHitbox());

  @override
  void update(double dt) { super.update(dt); _offset = (_offset + 110 * dt) % 24; }

  @override
  void render(Canvas canvas) {
    canvas.drawRect(size.toRect(), Paint()..color = const Color(0xFFD9A441));
    canvas.drawRect(Rect.fromLTWH(0, 0, size.x, 7), Paint()..color = const Color(0xFF7CBD42));
    final stripe = Paint()..color = const Color(0xFFC78B2F);
    for (double x = -_offset; x < size.x; x += 24) canvas.drawRect(Rect.fromLTWH(x, 14, 12, 5), stripe);
  }
}
