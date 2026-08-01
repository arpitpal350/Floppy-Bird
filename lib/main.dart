import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'game/flappy_bird_game.dart';
import 'overlays/game_over_overlay.dart';
import 'overlays/hud_overlay.dart';
import 'services/ad_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MobileAds.instance.initialize();
  final adService = AdService();
  runApp(FlappyBirdApp(adService: adService));
}

class FlappyBirdApp extends StatefulWidget {
  const FlappyBirdApp({super.key, required this.adService});
  final AdService adService;

  @override
  State<FlappyBirdApp> createState() => _FlappyBirdAppState();
}

class _FlappyBirdAppState extends State<FlappyBirdApp> {
  late final FlappyBirdGame _game;

  @override
  void initState() {
    super.initState();
    _game = FlappyBirdGame(adService: widget.adService);
  }

  @override
  void dispose() {
    _game.disposeGame();
    widget.adService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.amber),
        home: Scaffold(
          body: GameWidget<FlappyBirdGame>(
            game: _game,
            overlayBuilderMap: {
              HudOverlay.id: (context, game) => HudOverlay(game: game),
              GameOverOverlay.id: (context, game) => GameOverOverlay(game: game),
            },
            initialActiveOverlays: const [HudOverlay.id],
          ),
        ),
      );
}
