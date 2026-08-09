import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../../config/game_config.dart';
class Ground extends PositionComponent { Ground({required super.position, required super.size}); double offset = 0; void move(double amount) => offset = (offset + amount) % 24; @override void render(Canvas c) { c.drawRect(size.toRect(), Paint()..color = const Color(0xff5dbb63)); c.drawRect(Rect.fromLTWH(0, 0, size.x, 9), Paint()..color = const Color(0xffa6df69)); for (double x = -offset; x < size.x; x += 24) { c.drawRect(Rect.fromLTWH(x, 18, 12, 5), Paint()..color = const Color(0xff439650)); } c.drawLine(Offset.zero, Offset(size.x, 0), Paint()..color = GameConfig.ink..strokeWidth = 3); } }
