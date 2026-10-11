import 'package:moth_hop/feature/game/engine/entity/player.dart';

class ScoreSystem {
  static const int heightDivisor = 10;

  double _lastScoredY = 0;

  void reset(double startY) => _lastScoredY = startY;

  void update(Player player) {
    if (player.position.y < _lastScoredY) {
      final delta = ((_lastScoredY - player.position.y) / heightDivisor)
          .floor();
      player.score += delta;
      _lastScoredY = player.position.y;
    }
  }

  void shiftBy(double delta) => _lastScoredY += delta;
}
