import 'dart:math';

import 'package:flame/components.dart';
import 'package:moth_hop/core/app_assets/app_assets.dart';
import 'package:moth_hop/feature/game/engine/entity/platform.dart';
import 'package:moth_hop/feature/game/engine/entity/yarn.dart';
import 'package:moth_hop/feature/game/engine/enums/platform_kind.dart';
import 'package:moth_hop/feature/game/engine/game_cfg/game_config.dart';

class SpawnSystem {
  SpawnSystem({
    required this.world,
    required this.rng,
    required this.screenWidth,
  });

  final World world;
  final Random rng;
  final double screenWidth;

  double _lastY = 0;
  double _seedY = 0;
  int _spawned = 0;
  PlatformEntity? _unpairedTeleport;

  Map<PlatformKind, int> weights = {
    PlatformKind.normal: 70,
    PlatformKind.fragile: 10,
    PlatformKind.breakable: 8,
    PlatformKind.jumpPad: 4,
    PlatformKind.teleport: 3,
    PlatformKind.moving: 5,
    PlatformKind.spike: 0,
  };

  void seed(double startY) {
    _lastY = startY;
    _seedY = startY;
    _spawned = 0;
    _unpairedTeleport = null;
  }

  void reset() {
    _lastY = 0;
    _seedY = 0;
    _spawned = 0;
    _unpairedTeleport = null;
  }

  void shiftBy(double dy) => _lastY += dy;

  double get highestY => _lastY;

  PlatformKind _pickKind() {
    _applyDifficulty();
    final total = weights.values.fold(0, (a, b) => a + b);
    if (total <= 0) return PlatformKind.normal;
    var r = rng.nextInt(total);
    for (final entry in weights.entries) {
      r -= entry.value;
      if (r < 0) return entry.key;
    }
    return PlatformKind.normal;
  }

  void _applyDifficulty() {
    if (_spawned < 6) {
      weights = {for (final k in PlatformKind.values) k: 0}
        ..[PlatformKind.normal] = 100;
      return;
    }

    final climbed = _seedY - _lastY;
    if (climbed < 700) {
      weights = {
        PlatformKind.normal: 78,
        PlatformKind.fragile: 12,
        PlatformKind.breakable: 6,
        PlatformKind.jumpPad: 0,
        PlatformKind.teleport: 0,
        PlatformKind.moving: 4,
        PlatformKind.spike: 0,
      };
    } else if (climbed < 1800) {
      weights = {
        PlatformKind.normal: 58,
        PlatformKind.fragile: 14,
        PlatformKind.breakable: 10,
        PlatformKind.jumpPad: 6,
        PlatformKind.teleport: 3,
        PlatformKind.moving: 8,
        PlatformKind.spike: 1,
      };
    } else {
      weights = {
        PlatformKind.normal: 44,
        PlatformKind.fragile: 16,
        PlatformKind.breakable: 12,
        PlatformKind.jumpPad: 8,
        PlatformKind.teleport: 5,
        PlatformKind.moving: 10,
        PlatformKind.spike: 5,
      };
    }
  }

  PlatformEntity spawnFixed({
    required PlatformKind kind,
    required double x,
    required double y,
    bool withYarn = false,
  }) {
    _lastY = min(_lastY == 0 ? y : _lastY, y);
    return _addPlatform(kind, x, y, withYarn: withYarn);
  }

  PlatformEntity spawnOne() {
    final gap =
        GameConfig.minPlatformGap +
        rng.nextDouble() *
            (GameConfig.maxPlatformGap - GameConfig.minPlatformGap);
    _lastY -= gap;

    final kind = _pickKind();
    final width = GameConfig.platformSize(kind).x;
    final x = 16 + rng.nextDouble() * (screenWidth - width - 32);
    return _addPlatform(kind, x, _lastY, withYarn: true);
  }

  PlatformEntity _addPlatform(
    PlatformKind kind,
    double x,
    double y, {
    required bool withYarn,
  }) {
    _spawned++;
    final p = PlatformEntity(
      kind: kind,
      position: Vector2(x, y),
      spriteFull: _spriteForKind(kind),
      spriteCracked: kind == PlatformKind.breakable
          ? AppAssets.flameName(AppAssets.almostBreakablePlatform)
          : null,
      spriteBroken: kind == PlatformKind.breakable
          ? AppAssets.flameName(AppAssets.breakedPlatform)
          : null,
    );

    if (kind == PlatformKind.moving) {
      p.moveSpeed = 70 + rng.nextDouble() * 70;
      p.minX = 8;
      p.maxX = screenWidth - 8;
      if (rng.nextBool()) p.moveSpeed = -p.moveSpeed;
    }

    if (kind == PlatformKind.teleport) {
      final unpaired = _unpairedTeleport;
      if (unpaired != null && unpaired.isMounted) {
        unpaired.teleportPartner = p;
        p.teleportPartner = unpaired;
        _unpairedTeleport = null;
      } else {
        _unpairedTeleport = p;
      }
    }

    world.add(p);

    if (withYarn &&
        kind != PlatformKind.spike &&
        rng.nextDouble() < GameConfig.yarnSpawnChance) {
      final offset = Vector2(p.size.x / 2, -26);
      world.add(
        Yarn(
          position: Vector2(p.position.x + offset.x, p.position.y + offset.y),
          platform: p,
          localOffset: offset,
        ),
      );
    }

    return p;
  }

  String _spriteForKind(PlatformKind k) {
    switch (k) {
      case PlatformKind.normal:
        return AppAssets.flameName(AppAssets.normalPlatform);
      case PlatformKind.fragile:
        return AppAssets.flameName(AppAssets.fragilePlatform);
      case PlatformKind.breakable:
        return AppAssets.flameName(AppAssets.breakablePlatform);
      case PlatformKind.jumpPad:
        return AppAssets.flameName(AppAssets.jumpPadPlatform);
      case PlatformKind.teleport:
        return AppAssets.flameName(AppAssets.teleportPlatform);
      case PlatformKind.moving:
        return AppAssets.flameName(AppAssets.movingPlatform);
      case PlatformKind.spike:
        return AppAssets.flameName(AppAssets.spikePlatform);
    }
  }
}
