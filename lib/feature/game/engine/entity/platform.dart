import 'package:flame/components.dart';
import 'package:flutter/animation.dart';
import 'package:moth_hop/feature/game/engine/enums/platform_kind.dart';
import 'package:moth_hop/feature/game/engine/game_cfg/game_config.dart';

class PlatformEntity extends SpriteComponent with HasGameReference {
  PlatformEntity({
    required this.kind,
    required super.position,
    required this.spriteFull,
    this.spriteCracked,
    this.spriteBroken,
    Vector2? size,
  }) : super(
         size: size ?? GameConfig.platformSize(kind),
         anchor: Anchor.topLeft,
         priority: 5,
       );

  final PlatformKind kind;
  final String spriteFull;
  final String? spriteCracked;
  final String? spriteBroken;

  int state = 1;
  double moveSpeed = 0;
  double minX = 0;
  double maxX = 0;
  PlatformEntity? teleportPartner;
  int jumpBoost = 5;
  bool fadingOut = false;
  double _fadeElapsed = 0;

  static const fadeOutDuration = 0.42;

  bool get isBroken =>
      fadingOut || (kind == PlatformKind.breakable && state >= 3);

  @override
  Future<void> onLoad() async {
    refreshSprite();
  }

  @override
  void update(double dt) {
    super.update(dt);
    moveHorizontally(dt);
    _updateFade(dt);
  }

  void beginFadeOut() {
    if (fadingOut) return;
    fadingOut = true;
    _fadeElapsed = 0;
  }

  void _updateFade(double dt) {
    if (!fadingOut) return;
    _fadeElapsed += dt;
    final t = (_fadeElapsed / fadeOutDuration).clamp(0.0, 1.0);
    opacity = 1.0 - Curves.easeOut.transform(t);
    if (_fadeElapsed >= fadeOutDuration && isMounted) {
      removeFromParent();
    }
  }

  void refreshSprite() {
    final name = switch (state) {
      2 => spriteCracked ?? spriteFull,
      3 => spriteBroken ?? spriteFull,
      _ => spriteFull,
    };
    final image = game.images.fromCache(name);
    sprite = Sprite(image);
  }

  void moveHorizontally(double dt) {
    if (kind != PlatformKind.moving) return;
    position.x += moveSpeed * dt;
    if (position.x <= minX || position.x + size.x >= maxX) {
      moveSpeed = -moveSpeed;
      position.x = position.x.clamp(minX, maxX - size.x);
    }
  }
}
