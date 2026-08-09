import 'dart:math';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../../config/game_config.dart';

class Background extends PositionComponent {
  Background({required super.size}); double scroll = 0;
  @override void update(double dt) { scroll = (scroll + dt * 18) % 130; }
  @override void render(Canvas c) { c.drawRect(size.toRect(), Paint()..shader = const LinearGradient(colors: [GameConfig.skyTop, GameConfig.skyBottom], begin: Alignment.topCenter, end: Alignment.bottomCenter).createShader(size.toRect())); for (var i = -1; i < 7; i++) { final x = i * 130 - scroll; final y = 65 + (i % 3) * 72; _cloud(c, Offset(x, y)); } }
  void _cloud(Canvas c, Offset p) { final paint = Paint()..color = Colors.white.withValues(alpha: .72); c.drawCircle(p + const Offset(20, 14), 13, paint); c.drawCircle(p + const Offset(38, 8), 18, paint); c.drawCircle(p + const Offset(58, 16), 12, paint); c.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(p.dx + 10, p.dy + 14, 62, 17), const Radius.circular(12)), paint); }
}
