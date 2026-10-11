import 'package:moth_hop/feature/game/engine/behaviors/platform_behavior.dart';
import 'package:moth_hop/feature/game/engine/entity/platform.dart';
import 'package:moth_hop/feature/game/engine/game_cfg/game_config.dart';

class BreakableBehavior extends PlatformBehavior {
  @override
  void onLanded(GameContext ctx, PlatformEntity p) {
    if (p.state >= 3) return; // сломана — не реагируем
    if (p.state == 1) {
      p.state = 2;
      ctx.changePlatformSprite(p);
      ctx.bounce(GameConfig.jumpVelocity);
    } else {
      p.state = 3;
      ctx.changePlatformSprite(p);
      ctx.bounce(GameConfig.jumpVelocity);
    }
  }
}
