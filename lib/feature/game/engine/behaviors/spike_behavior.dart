import 'package:moth_hop/feature/game/engine/behaviors/platform_behavior.dart';
import 'package:moth_hop/feature/game/engine/entity/platform.dart';

class SpikeBehavior extends PlatformBehavior {
  @override
  void onLanded(GameContext ctx, PlatformEntity p) => ctx.killPlayer();
}
