import 'package:moth_hop/feature/game/engine/behaviors/platform_behavior.dart';
import 'package:moth_hop/feature/game/engine/entity/platform.dart';
import 'package:moth_hop/feature/game/engine/game_cfg/game_config.dart';

class MovingBehavior extends PlatformBehavior {
  @override
  void onLanded(GameContext ctx, PlatformEntity p) {
    ctx.bounce(GameConfig.jumpVelocity);
  }
}
