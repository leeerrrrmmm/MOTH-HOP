import 'package:moth_hop/feature/game/engine/entity/player.dart';
import 'package:moth_hop/feature/game/engine/entity/yarn.dart';

class CollectSystem {
  void update(Player player, Iterable<Yarn> yarns) {
    if (player.isDead) return;
    for (final yarn in yarns.toList()) {
      if (!yarn.isMounted) continue;
      if (player.toRect().overlaps(yarn.toRect())) {
        player.yarns += yarn.value;
        yarn.removeFromParent();
      }
    }
  }
}
