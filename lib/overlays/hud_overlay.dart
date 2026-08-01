import 'package:flutter/material.dart';

import '../game/flappy_bird_game.dart';

class HudOverlay extends StatelessWidget {
  const HudOverlay({super.key, required this.game});
  static const id = 'hud';
  final FlappyBirdGame game;

  @override
  Widget build(BuildContext context) => SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: ValueListenableBuilder<int>(
            valueListenable: game.score,
            builder: (_, value, __) => Padding(
              padding: const EdgeInsets.only(top: 18),
              child: Text('$value', style: const TextStyle(fontSize: 46, fontWeight: FontWeight.w900, color: Colors.white, shadows: [Shadow(color: Colors.black54, blurRadius: 4, offset: Offset(2, 2))])),
            ),
          ),
        ),
      );
}
