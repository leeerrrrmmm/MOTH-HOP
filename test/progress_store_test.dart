import 'package:flutter_test/flutter_test.dart';
import 'package:moth_hop/core/progress/progress_store.dart';
import 'package:moth_hop/core/progress/yarn_count_formatter.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('formats yarn counts in the requested compact bands', () {
    expect(YarnCountFormatter.format(1), '1');
    expect(YarnCountFormatter.format(10), '10');
    expect(YarnCountFormatter.format(100), '100');
    expect(YarnCountFormatter.format(101), '1к');
    expect(YarnCountFormatter.format(9999), '1к');
    expect(YarnCountFormatter.format(10000), '10к');
    expect(YarnCountFormatter.format(99999), '10к');
    expect(YarnCountFormatter.format(100000), '100к');
    expect(YarnCountFormatter.format(300000), '100к');
  });

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await ProgressStore.instance.init();
  });

  test('records score and yarns and unlocks the next location', () async {
    final store = ProgressStore.instance;

    expect(store.bestScore, 0);
    expect(store.totalYarns, 0);
    expect(store.unlockedLocationCount, 1);

    await store.recordRound(score: 350, yarns: 650);

    expect(store.bestScore, 350);
    expect(store.totalYarns, 650);
    expect(store.unlockedLocationCount, 2);
  });

  test('persists location and charges yarns when buying a skin', () async {
    final store = ProgressStore.instance;
    await store.recordRound(score: 350, yarns: 650);
    await store.selectLocation(1);

    expect(await store.purchaseSkin(skin: 1, cost: 300), isTrue);
    expect(store.totalYarns, 350);
    expect(store.selectedSkin, 1);
    expect(store.ownsSkin(1), isTrue);
    expect(await store.purchaseSkin(skin: 2, cost: 600), isFalse);

    await store.init();

    expect(store.selectedLocation, 1);
    expect(store.selectedSkin, 1);
    expect(store.totalYarns, 350);
    expect(store.ownsSkin(1), isTrue);
    expect(store.ownsSkin(2), isFalse);
  });

  test('does not allow choosing a location that is still locked', () async {
    final store = ProgressStore.instance;

    await store.selectLocation(1);

    expect(store.selectedLocation, 0);
  });
}
