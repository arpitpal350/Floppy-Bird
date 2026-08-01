import 'package:flutter/material.dart';

import '../game/flappy_bird_game.dart';

class GameOverOverlay extends StatelessWidget {
  const GameOverOverlay({super.key, required this.game});
  static const id = 'gameOver';
  final FlappyBirdGame game;

  @override
  Widget build(BuildContext context) => ColoredBox(
        color: Colors.black54,
        child: Center(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(28),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                const Text('Game Over', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text('Score: ${game.score.value}', style: const TextStyle(fontSize: 20)),
                const SizedBox(height: 22),
                FilledButton(onPressed: game.restart, child: const Text('Restart')),
                const SizedBox(height: 10),
                OutlinedButton.icon(
                  onPressed: () => game.adService.showRewardedAd(onRewardEarned: game.revive),
                  icon: const Icon(Icons.play_circle_outline),
                  label: const Text('Watch Ad to Revive'),
                ),
              ]),
            ),
          ),
        ),
      );
}
