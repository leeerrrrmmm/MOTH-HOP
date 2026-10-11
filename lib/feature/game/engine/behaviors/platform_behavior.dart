import 'package:moth_hop/feature/game/engine/entity/platform.dart';

abstract class PlatformBehavior {
  /// Викликається, коли гравець приземлився ЗВЕРХУ.
  void onLanded(GameContext ctx, PlatformEntity p);

  /// Викликається при будь-якому дотику (для spike/teleport).
  void onTouch(GameContext ctx, PlatformEntity p) => onLanded(ctx, p);
}

/// Що поведінка може робити зі світом.
abstract class GameContext {
  void bounce(double velocity);
  void killPlayer();
  void teleportUp(PlatformEntity from);
  void breakPlatform(PlatformEntity p);
  void changePlatformSprite(PlatformEntity p);
  void boostJump(PlatformEntity p, int tiles);
}
