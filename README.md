# Floppy Bird

An original, colorful, procedural Flutter + Flame arcade game. Android package ID: `com.arpit.floppybird`.

## What is included

- Responsive tap and desktop Space-key flapping, physics-based tilt and wing animation.
- Fair, single-gap obstacle generation; speed and gap difficulty advance within fixed safe bounds.
- Start, pause/resume, game-over and restart flows; lifecycle backgrounding pauses a live game.
- Locally persisted best score. All art is drawn in code; no copyrighted game assets are used.
- Optional Unity interstitial/rewarded architecture that is disabled until valid IDs are configured.

## Setup and run

Install a current stable Flutter SDK with Dart 3.11+ and Android SDK Platform 35, then run:

```bash
flutter pub get
flutter analyze
flutter test
flutter run
```

If your clone does not include `android/gradle/wrapper/gradle-wrapper.jar` (some source-only archive tools omit binary wrapper files), restore it from the official Gradle 8.10.2 tag before the first Android build. Codemagic does this automatically.

## Unity Ads

In [lib/services/ad_service.dart](lib/services/ad_service.dart), replace the three `YOUR_...` values with the Android Game ID and placement IDs from your Unity dashboard. Keep `testMode: true` while testing; change it to `false` only for a production release with real credentials. The game proceeds normally if SDK initialization, loading, or display fails. Interstitials are considered only every third completed attempt and never during a run.

## Releases / Codemagic

Codemagic reads `codemagic.yaml`, runs dependency resolution, analysis and tests, then emits an APK and AAB. Create an Android keystore in Codemagic's code-signing area named `floppy_bird_keystore`, and set the secure variables `CM_KEYSTORE_PASSWORD`, `CM_KEY_PASSWORD`, `CM_KEY_ALIAS`, and `CM_KEYSTORE_PATH`. Do not commit `android/key.properties` or any keystore.

For a local signed release, place a non-committed `android/key.properties` pointing to your keystore and run:

```bash
flutter build apk --release
flutter build appbundle --release
```

The project uses Java/Kotlin JVM target 17, minSdk 23, compile/target SDK 35, AGP 8.7.3 and Gradle 8.10.2.
