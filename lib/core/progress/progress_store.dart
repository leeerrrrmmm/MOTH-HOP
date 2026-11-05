import 'package:flutter/foundation.dart';
import 'package:moth_hop/feature/game/engine/game_cfg/game_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProgressStore extends ChangeNotifier {
  ProgressStore._();

  static final ProgressStore instance = ProgressStore._();

  static const _yarnsKey = 'total_yarns';
  static const _bestScoreKey = 'best_score';
  static const _selectedLocationKey = 'selected_location';
  static const _ownedSkinsKey = 'owned_skins';
  static const _selectedSkinKey = 'selected_skin';

  SharedPreferences? _prefs;
  int _totalYarns = 0;
  int _bestScore = 0;
  int _selectedLocation = 0;
  int _selectedSkin = 0;
  Set<int> _ownedSkins = {0};

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _prefs = prefs;
    _totalYarns = prefs.getInt(_yarnsKey) ?? 0;
    _bestScore = prefs.getInt(_bestScoreKey) ?? 0;
    _selectedLocation = prefs.getInt(_selectedLocationKey) ?? 0;
    _selectedSkin = prefs.getInt(_selectedSkinKey) ?? 0;
    _ownedSkins =
        (prefs.getStringList(_ownedSkinsKey) ?? ['0'])
            .map(int.tryParse)
            .whereType<int>()
            .toSet()
          ..add(0);
    if (!_ownedSkins.contains(_selectedSkin)) _selectedSkin = 0;
    _selectedLocation = _selectedLocation.clamp(0, unlockedLocationCount - 1);
    notifyListeners();
  }

  int get totalYarns => _totalYarns;

  int get bestScore => _bestScore;

  int get selectedLocation => _selectedLocation;

  int get selectedSkin => _selectedSkin;

  bool ownsSkin(int skin) => _ownedSkins.contains(skin);

  Set<int> get ownedSkins => Set.unmodifiable(_ownedSkins);

  int get unlockedLocationCount => GameConfig.unlockedLocationCount(_bestScore);

  Future<void> selectLocation(int location) async {
    if (location < 0 || location >= unlockedLocationCount) return;
    _selectedLocation = location;
    notifyListeners();
    await _prefs?.setInt(_selectedLocationKey, location);
  }

  Future<void> selectSkin(int skin) async {
    if (!_ownedSkins.contains(skin)) return;
    _selectedSkin = skin;
    notifyListeners();
    await _prefs?.setInt(_selectedSkinKey, skin);
  }

  Future<bool> purchaseSkin({required int skin, required int cost}) async {
    if (skin < 1 || _ownedSkins.contains(skin) || _totalYarns < cost) {
      return false;
    }
    _totalYarns -= cost;
    _ownedSkins.add(skin);
    _selectedSkin = skin;
    notifyListeners();
    await _prefs?.setInt(_yarnsKey, _totalYarns);
    await _prefs?.setInt(_selectedSkinKey, _selectedSkin);
    await _prefs?.setStringList(
      _ownedSkinsKey,
      _ownedSkins.map((ownedSkin) => ownedSkin.toString()).toList(),
    );
    return true;
  }

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
    _selectedLocation = _selectedLocation.clamp(0, unlockedLocationCount - 1);
    await _prefs?.setInt(_selectedLocationKey, _selectedLocation);
  }
}
