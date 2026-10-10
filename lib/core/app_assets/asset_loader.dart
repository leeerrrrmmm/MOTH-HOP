import 'package:flutter/material.dart';

import 'app_assets.dart';

/// Прогріває кеш зображень, щоб `Image.asset` показувався миттєво.
class AssetLoader {
  const AssetLoader();

  /// Прогріває один ассет. Не кидає помилку, якщо файл відсутній —
  /// просто логує в debug.
  Future<void> _safePrecache(BuildContext context, String path) async {
    try {
      await precacheImage(AssetImage(path), context);
    } catch (e, st) {
      assert(() {
        debugPrint('⚠️ Failed to precache "$path": $e\n$st');
        return true;
      }());
    }
  }

  /// Прогріває всі ассети зі [AppAssets.all].
  /// Повертає `Future`, який завершується, коли все завантажено.
  Future<void> precacheAll(BuildContext context) async {
    await Future.wait(
      AppAssets.all.map((path) => _safePrecache(context, path)),
    );
  }

  /// Прогріває довільний список ассетів (для окремих екранів).
  Future<void> precache(BuildContext context, List<String> paths) async {
    await Future.wait(paths.map((path) => _safePrecache(context, path)));
  }
}
