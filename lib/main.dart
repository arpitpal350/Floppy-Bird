import 'package:flutter/material.dart';
import 'game/screens/game_shell.dart';
import 'services/ad_service.dart';
void main() { WidgetsFlutterBinding.ensureInitialized(); final ads = AdService(); ads.initialize(); runApp(FloppyBirdApp(ads: ads)); }
class FloppyBirdApp extends StatelessWidget { const FloppyBirdApp({super.key, required this.ads}); final AdService ads; @override Widget build(BuildContext context) => MaterialApp(debugShowCheckedModeBanner: false, title: 'Floppy Bird', theme: ThemeData(useMaterial3: true), home: GameShell(ads: ads)); }
