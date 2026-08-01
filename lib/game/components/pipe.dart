import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class PipeGroup extends PositionComponent with CollisionCallbacks {
  PipeGroup({required double x, required this.topHeight, required this.gap, required this.playHeight, required this.onPassed})
      : super(position: Vector2(x, 0), size: Vector2(pipeWidth, playHeight));
      
  // Renamed 'width' -> 'pipeWidth' to avoid conflict with Flame 1.38+ PositionComponent.width
  static const pipeWidth = 62.0; 
  final double topHeight;
  final double gap;
  final double playHeight;
  final void Function() onPassed;
  bool _scored = false;

  @override
  Future<void> onLoad() async {
    await addAll([
      RectangleHitbox(position: Vector2.zero(), size: Vector2(pipeWidth, topHeight)),
      RectangleHitbox(position: Vector2(0, topHeight + gap), size: Vector2(pipeWidth, playHeight - topHeight - gap)),
    ]);
  }

  @override
  void update(double dt) {
    super.update(dt);
    position.x -= 145 * dt;
    if (!_scored && position.x + pipeWidth < 74) { _scored = true; onPassed(); }
    if (position.x + pipeWidth < 0) removeFromParent();
  }

  @override
  void render(Canvas canvas) {
    final pipe = Paint()..color = const Color(0xFF39A845);
    final edge = Paint()..color = const Color(0xFF207A36);
    _drawPipe(canvas, Rect.fromLTWH(0, 0, pipeWidth, topHeight), pipe, edge, false);
    _drawPipe(canvas, Rect.fromLTWH(0, topHeight + gap, pipeWidth, playHeight - topHeight - gap), pipe, edge, true);
  }

  void _drawPipe(Canvas canvas, Rect rect, Paint fill, Paint edge, bool capAtTop) {
    canvas.drawRect(rect, fill);
    canvas.drawRect(Rect.fromLTWH(rect.left, rect.top, 6, rect.height), edge);
    final capY = capAtTop ? rect.top : rect.bottom - 14;
    canvas.drawRect(Rect.fromLTWH(-5, capY, pipeWidth + 10, 14), fill);
    canvas.drawRect(Rect.fromLTWH(-5, capY, pipeWidth + 10, 3), edge);
  }
}
