import 'package:flame/components.dart';
import 'package:moth_hop/feature/game/engine/enums/platform_kind.dart';

class GameConfig {
  GameConfig._();

  static const double gravity = 1600;
  static const double jumpVelocity = -900;
  static const double jumpPadVelocity = -1500;
  static const double moveSpeed = 500;
  static const double maxFallSpeed = 1500;

  static const double platformWidth = 96;
  static const double platformHeight = 24;
  static const double minPlatformGap = 95;
  static const double maxPlatformGap = 168;

  static const int platformsAhead = 12;
  static const int cleanupBuffer = 220;

  static const double yarnSpawnChance = 0.22;
  static final Vector2 yarnSize = Vector2(28, 28);

  static final Vector2 playerSize = Vector2(82, 64);

  /// Keep the moth around this screen line while climbing.
  static const double cameraKeepLine = 0.42;

  /// Score at which the closet fills with clothes.
  static const int biomeSwitchScore = 350;

  static const int locationCount = 5;

  /// Best score needed to unlock each location. Index 0 is always open.
  static const List<int> locationUnlockScores = [
    0,
    biomeSwitchScore,
    800,
    1500,
    2500,
  ];

  static int unlockedLocationCount(int bestScore) {
    var unlocked = 1;
    for (var i = 1; i < locationUnlockScores.length; i++) {
      if (bestScore >= locationUnlockScores[i]) {
        unlocked = i + 1;
      }
    }
    return unlocked;
  }

  static Vector2 platformSize(PlatformKind kind) {
    switch (kind) {
      case PlatformKind.normal:
        return Vector2(96, 24);
      case PlatformKind.fragile:
        return Vector2(102, 28);
      case PlatformKind.breakable:
        return Vector2(96, 22);
      case PlatformKind.jumpPad:
        return Vector2(96, 24);
      case PlatformKind.teleport:
        return Vector2(96, 24);
      case PlatformKind.moving:
        return Vector2(104, 30);
      case PlatformKind.spike:
        return Vector2(98, 30);
    }
  }
}
