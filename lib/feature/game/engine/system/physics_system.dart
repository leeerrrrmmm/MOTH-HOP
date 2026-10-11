import '../behaviors/platform_behavior.dart';
import '../entity/platform.dart';
import '../entity/player.dart';
import '../game_cfg/game_config.dart';
import '../mapper/behaviors_mapper.dart';

class PhysicsSystem {
  PhysicsSystem(this.ctx);

  final GameContext ctx;

  void update(
    Player player,
    List<PlatformEntity> platforms,
    double dt,
    double screenWidth,
  ) {
    player.velocityY = (player.velocityY + GameConfig.gravity * dt).clamp(
      -9999,
      GameConfig.maxFallSpeed,
    );
    player.position.y += player.velocityY * dt;
    player.position.x += player.velocityX * dt;
    player.wrapX(screenWidth);

    if (player.isDead) return;

    for (final p in platforms) {
      if (p.isBroken) continue;
      if (!player.toRect().overlaps(p.toRect())) continue;

      final playerRect = player.toRect();
      final platformRect = p.toRect();
      final isFalling = player.velocityY > 0;
      final wasAbove =
          playerRect.bottom - player.velocityY * dt <= platformRect.top + 12;

      if (isFalling && wasAbove) {
        player.position.y = platformRect.top;
        platformBehaviors[p.kind]!.onLanded(ctx, p);
      }
    }
  }
}
