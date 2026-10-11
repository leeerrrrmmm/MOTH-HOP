import 'package:flutter/foundation.dart';
import 'package:moth_hop/feature/game/engine/game_cfg/game_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProgressStore extends ChangeNotifier {
  ProgressStore._();

  static final ProgressStore instance = ProgressStore._();

  static const _yarnsKey = 'total_yarns';
  static const _bestScoreKey = 'best_score';

  SharedPreferences? _prefs;
  int _totalYarns = 0;
  int _bestScore = 0;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _prefs = prefs;
    _totalYarns = prefs.getInt(_yarnsKey) ?? 0;
    _bestScore = prefs.getInt(_bestScoreKey) ?? 0;
    notifyListeners();
  }

  int get totalYarns => _totalYarns;

  int get bestScore => _bestScore;

  int get unlockedLocationCount =>
      GameConfig.unlockedLocationCount(_bestScore);

  Future<void> recordBestScore(int score) async {
    if (score <= _bestScore) return;
    _bestScore = score;
    notifyListeners();
    await _prefs?.setInt(_bestScoreKey, _bestScore);
  }

  Future<void> recordRound({required int score, required int yarns}) async {
    var changed = false;
    if (yarns > 0) {
      _totalYarns += yarns;
      changed = true;
    }
    if (score > _bestScore) {
      _bestScore = score;
      changed = true;
    }
    if (!changed) return;
    notifyListeners();
    if (yarns > 0) {
      await _prefs?.setInt(_yarnsKey, _totalYarns);
    }
    await _prefs?.setInt(_bestScoreKey, _bestScore);
  }
}
