import 'package:flame/cache.dart';
import 'package:flame/components.dart';
import 'package:moth_hop/core/app_assets/app_assets.dart';
import 'package:moth_hop/feature/game/engine/entity/background_layer.dart';
import 'package:moth_hop/feature/game/engine/game_cfg/game_config.dart';

class ScrollingBackground extends Component {
  ScrollingBackground({required this.images, required this.viewSize});

  final Images images;
  final Vector2 viewSize;

  late final BackgroundLayer _tileA;
  late final BackgroundLayer _tileB;
  late final SpriteComponent _fadeOverlay;

  late String _active;
  bool _switching = false;
  double _fade = 0;

  String get _biome1 => AppAssets.flameName(AppAssets.gameBackground1);
  String get _biome2 => AppAssets.flameName(AppAssets.gameBackground2);

  @override
  Future<void> onLoad() async {
    _active = _biome1;
    _tileA = BackgroundLayer(
      sprite: Sprite(images.fromCache(_active)),
      size: viewSize.clone(),
      position: Vector2.zero(),
    );
    _tileB = BackgroundLayer(
      sprite: Sprite(images.fromCache(_active)),
      size: viewSize.clone(),
      position: Vector2(0, -viewSize.y),
    );
    _fadeOverlay = SpriteComponent(
      sprite: Sprite(images.fromCache(_biome2)),
      size: viewSize.clone(),
      position: Vector2.zero(),
      anchor: Anchor.topLeft,
    )..opacity = 0;
    await addAll([_tileA, _tileB, _fadeOverlay]);
  }

  void scroll(double dy) {
    for (final tile in [_tileA, _tileB]) {
      tile.position.y += dy;
      if (tile.position.y >= viewSize.y) {
        tile.position.y -= viewSize.y * 2;
        tile.sprite = Sprite(images.fromCache(_active));
      }
    }
  }

  void onScore(int score) {
    if (!_switching &&
        _active == _biome1 &&
        score >= GameConfig.biomeSwitchScore) {
      _switching = true;
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (!_switching) return;
    _fade = (_fade + dt * 0.5).clamp(0.0, 1.0);
    _fadeOverlay.opacity = _fade;
    if (_fade >= 1) {
      _active = _biome2;
      _tileA.sprite = Sprite(images.fromCache(_biome2));
      _tileB.sprite = Sprite(images.fromCache(_biome2));
      _fadeOverlay.opacity = 0;
      _switching = false;
    }
  }

  void reset() {
    _active = _biome1;
    _switching = false;
    _fade = 0;
    _fadeOverlay.opacity = 0;
    _tileA
      ..sprite = Sprite(images.fromCache(_biome1))
      ..position.setValues(0, 0);
    _tileB
      ..sprite = Sprite(images.fromCache(_biome1))
      ..position.setValues(0, -viewSize.y);
  }
}
