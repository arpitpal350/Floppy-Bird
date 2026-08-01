import 'dart:ui';

import 'package:flame/components.dart';

/// Lightweight procedural parallax; no asset loading is required.
class ScrollingBackground extends PositionComponent {
  ScrollingBackground({required Vector2 size}) : super(size: size);
  double _cloudOffset = 0;
  double _hillOffset = 0;

  @override
  void update(double dt) { super.update(dt); _cloudOffset = (_cloudOffset + 12 * dt) % 180; _hillOffset = (_hillOffset + 25 * dt) % 160; }

  @override
  void render(Canvas canvas) {
    canvas.drawRect(size.toRect(), Paint()..color = const Color(0xFF72CFF2));
    final cloud = Paint()..color = const Color(0x99FFFFFF);
    for (double x = -_cloudOffset; x < size.x + 180; x += 180) {
      canvas.drawOval(Rect.fromLTWH(x, 62, 64, 22), cloud);
      canvas.drawOval(Rect.fromLTWH(x + 22, 48, 48, 30), cloud);
    }
    final hills = Paint()..color = const Color(0xFF8FCD71);
    for (double x = -_hillOffset; x < size.x + 160; x += 160) canvas.drawCircle(Offset(x + 80, size.y + 25), 95, hills);
  }
}
