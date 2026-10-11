import 'package:flame/components.dart';

class BackgroundLayer extends SpriteComponent {
  BackgroundLayer({
    required Sprite sprite,
    required Vector2 size,
    required Vector2 position,
  }) : super(
         sprite: sprite,
         size: size,
         position: position,
         anchor: Anchor.topLeft,
       );
}
