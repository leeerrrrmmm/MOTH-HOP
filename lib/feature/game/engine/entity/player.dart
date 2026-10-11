import 'package:flame/components.dart';
import 'package:moth_hop/core/app_assets/app_assets.dart';
import 'package:moth_hop/feature/game/engine/game_cfg/game_config.dart';

class Player extends SpriteComponent with HasGameReference {
  Player({required super.position})
    : super(
        size: GameConfig.playerSize,
        anchor: Anchor.bottomCenter,
        priority: 20,
      );

  double velocityY = 0;
  double velocityX = 0;
  int score = 0;
  int yarns = 0;
  bool isDead = false;

  @override
  Future<void> onLoad() async {
    sprite = Sprite(
      game.images.fromCache(AppAssets.flameName(AppAssets.mainCharacter)),
    );
  }

  void wrapX(double screenWidth) {
    if (position.x < 0) {
      position.x += screenWidth;
    } else if (position.x > screenWidth) {
      position.x -= screenWidth;
    }
  }
}
