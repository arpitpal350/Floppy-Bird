import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '../../config/game_config.dart';
import '../../services/ad_service.dart';
import '../floppy_bird_game.dart';

class GameShell extends StatefulWidget {
  const GameShell({
    super.key,
    required this.ads,
  });

  final AdService ads;

  @override
  State<GameShell> createState() => _GameShellState();
}

class _GameShellState extends State<GameShell>
    with WidgetsBindingObserver {
  late final FloppyBirdGame game;

  GamePhase phase = GamePhase.menu;
  int score = 0;
  int best = 0;
  int attempts = 0;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);

    game = FloppyBirdGame(
      onPhaseChanged: (newPhase) {
        if (!mounted) return;

        setState(() {
          phase = newPhase;
        });
      },
      onScoreChanged: (newScore) {
        if (!mounted) return;

        setState(() {
          score = newScore;
        });
      },
      onGameOver: (finalScore, bestScore) {
        if (mounted) {
          setState(() {
            score = finalScore;
            best = bestScore;
            attempts++;
          });
        }

        if (attempts % 3 == 0) {
          widget.ads.showInterstitialIfReady();
        }
      },
    );

    game.storage.bestScore().then((value) {
      if (!mounted) return;

      setState(() {
        best = value;
      });
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    game.pauseEngine();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(
    AppLifecycleState state,
  ) {
    if (state != AppLifecycleState.resumed) {
      game.resumeFromLifecycle();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            GameWidget(
              game: game,
            ),

            if (phase == GamePhase.playing ||
                phase == GamePhase.paused)
              _hud(),

            if (phase == GamePhase.menu)
              _menu(),

            if (phase == GamePhase.paused)
              _pause(),

            if (phase == GamePhase.gameOver)
              _gameOver(),
          ],
        ),
      ),
    );
  }

  Widget _hud() {
    return Positioned.fill(
      child: IgnorePointer(
        ignoring: phase == GamePhase.playing,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Text(
                '$score',
                style: const TextStyle(
                  fontSize: 44,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      color: GameConfig.ink,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  onPressed: game.togglePause,
                  icon: const Icon(
                    Icons.pause_circle_filled,
                    size: 36,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _menu() {
    return _panel(
      children: [
        const Text(
          'FLOPPY\nBIRD',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 48,
            height: 0.82,
            fontWeight: FontWeight.w900,
            color: GameConfig.ink,
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          'Tap to flap • Dodge the sky towers',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: GameConfig.ink,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 32),
        _button(
          'PLAY',
          Icons.play_arrow,
          game.start,
        ),
        const SizedBox(height: 12),
        Text(
          'Best score: $best',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: GameConfig.ink,
          ),
        ),
      ],
    );
  }

  Widget _pause() {
    return _panel(
      children: [
        const Text(
          'PAUSED',
          style: TextStyle(
            fontSize: 38,
            fontWeight: FontWeight.w900,
            color: GameConfig.ink,
          ),
        ),
        const SizedBox(height: 22),
        _button(
          'RESUME',
          Icons.play_arrow,
          game.togglePause,
        ),
      ],
    );
  }

  Widget _gameOver() {
    return _panel(
      children: [
        const Text(
          'GAME OVER',
          style: TextStyle(
            fontSize: 35,
            fontWeight: FontWeight.w900,
            color: GameConfig.ink,
          ),
        ),
        const SizedBox(height: 18),
        Text(
          'Score  $score',
          style: const TextStyle(
            fontSize: 23,
            fontWeight: FontWeight.w800,
            color: GameConfig.ink,
          ),
        ),
        Text(
          'Best  $best',
          style: const TextStyle(
            fontSize: 18,
            color: GameConfig.ink,
          ),
        ),
        const SizedBox(height: 24),
        _button(
          'PLAY AGAIN',
          Icons.refresh,
          game.start,
        ),
        const SizedBox(height: 10),
        TextButton(
          onPressed: () {
            setState(() {
              phase = GamePhase.menu;
            });
          },
          child: const Text('MAIN MENU'),
        ),
      ],
    );
  }

  Widget _panel({
    required List<Widget> children,
  }) {
    return Center(
      child: Container(
        width: 300,
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.92),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            color: GameConfig.ink,
            width: 3,
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x44000000),
              blurRadius: 15,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: children,
        ),
      ),
    );
  }

  Widget _button(
    String label,
    IconData icon,
    VoidCallback action,
  ) {
    return FilledButton.icon(
      onPressed: action,
      icon: Icon(icon),
      label: Text(label),
      style: FilledButton.styleFrom(
        backgroundColor: const Color(0xffed6b57),
        foregroundColor: Colors.white,
        textStyle: const TextStyle(
          fontWeight: FontWeight.w900,
          fontSize: 17,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 14,
        ),
      ),
    );
  }
}
