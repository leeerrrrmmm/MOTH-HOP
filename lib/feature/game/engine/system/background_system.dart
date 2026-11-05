import 'package:flame/cache.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:moth_hop/core/app_assets/app_assets.dart';
import 'package:moth_hop/feature/game/engine/entity/background_layer.dart';
import 'package:moth_hop/feature/game/engine/game_cfg/game_config.dart';

class ScrollingBackground extends Component {
  ScrollingBackground({
    required this.images,
    required this.viewSize,
    required this.location,
  });

  final Images images;
  final Vector2 viewSize;
  final int location;

  late final BackgroundLayer _tileA;
  late final BackgroundLayer _tileB;
  late final SpriteComponent _fadeOverlay;
  late final RectangleComponent _darkOverlay;

  late int _activeIndex;
  late int _nextSwitchScore;
  bool _switching = false;
  double _fade = 0;

  String _background(int index) =>
      AppAssets.flameName(AppAssets.gameBackgroundForLocation(index));

  double get _darkness => (_activeIndex * 0.19).clamp(0.0, 0.52);

  @override
  Future<void> onLoad() async {
    _activeIndex = location.clamp(0, GameConfig.locationCount - 1).toInt();
    _nextSwitchScore = GameConfig.biomeSwitchScore;
    final activeBackground = _background(_activeIndex);
    _tileA = BackgroundLayer(
      sprite: Sprite(images.fromCache(activeBackground)),
      size: viewSize.clone(),
      position: Vector2.zero(),
    );
    _tileB = BackgroundLayer(
      sprite: Sprite(images.fromCache(activeBackground)),
      size: viewSize.clone(),
      position: Vector2(0, -viewSize.y),
    );
    _fadeOverlay = SpriteComponent(
      sprite: Sprite(images.fromCache(_background(_nextIndex))),
      size: viewSize.clone(),
      position: Vector2.zero(),
      anchor: Anchor.topLeft,
      priority: 1,
    )..opacity = 0;
    _darkOverlay = RectangleComponent(
      size: viewSize.clone(),
      position: Vector2.zero(),
      paint: Paint()..color = Colors.black.withValues(alpha: _darkness),
      priority: 2,
    );
    await addAll([_tileA, _tileB, _fadeOverlay, _darkOverlay]);
  }

  int get _nextIndex =>
      (_activeIndex + 1).clamp(0, GameConfig.locationCount - 1).toInt();

  void scroll(double dy) {
    for (final tile in [_tileA, _tileB]) {
      tile.position.y += dy;
      if (tile.position.y >= viewSize.y) {
        tile.position.y -= viewSize.y * 2;
        tile.sprite = Sprite(images.fromCache(_background(_activeIndex)));
      }
    }
  }

  void onScore(int score) {
    if (!_switching && _nextIndex > _activeIndex && score >= _nextSwitchScore) {
      _switching = true;
      _fadeOverlay.sprite = Sprite(images.fromCache(_background(_nextIndex)));
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (!_switching) return;
    _fade = (_fade + dt * 0.5).clamp(0.0, 1.0);
    _fadeOverlay.opacity = _fade;
    if (_fade >= 1) {
      _activeIndex = _nextIndex;
      final activeBackground = _background(_activeIndex);
      _tileA.sprite = Sprite(images.fromCache(activeBackground));
      _tileB.sprite = Sprite(images.fromCache(activeBackground));
      _fadeOverlay.opacity = 0;
      _switching = false;
      _nextSwitchScore += GameConfig.biomeSwitchScore;
      _darkOverlay.paint.color = Colors.black.withValues(alpha: _darkness);
      _fadeOverlay.sprite = Sprite(images.fromCache(_background(_nextIndex)));
    }
  }

  void reset(int location) {
    _activeIndex = location.clamp(0, GameConfig.locationCount - 1).toInt();
    _nextSwitchScore = GameConfig.biomeSwitchScore;
    _switching = false;
    _fade = 0;
    _fadeOverlay.opacity = 0;
    final background = _background(_activeIndex);
    _tileA
      ..sprite = Sprite(images.fromCache(background))
      ..position.setValues(0, 0);
    _tileB
      ..sprite = Sprite(images.fromCache(background))
      ..position.setValues(0, -viewSize.y);
    _darkOverlay.paint.color = Colors.black.withValues(alpha: _darkness);
    _fadeOverlay.sprite = Sprite(images.fromCache(_background(_nextIndex)));
  }
}
