import 'package:flame/components.dart';
import 'package:moth_hop/feature/game/engine/entity/platform.dart';

import '../entity/yarn.dart';
import '../game_cfg/game_config.dart';

class CleanupSystem {
  CleanupSystem(this.world);

  final World world;

  void update(double screenBottom) {
    for (final c in world.children.toList()) {
      if (c is PlatformEntity &&
          c.position.y > screenBottom + GameConfig.cleanupBuffer) {
        c.removeFromParent();
      }
      if (c is Yarn && c.position.y > screenBottom + GameConfig.cleanupBuffer) {
        c.removeFromParent();
      }
    }
  }
}
