import 'package:flutter/material.dart';

import 'app_assets.dart';

/// Прогріває кеш зображень, щоб `Image.asset` показувався миттєво.
class AssetLoader {
  const AssetLoader();

  Future<void> _precache(BuildContext context, String path) async {
    final size = AppAssets.cacheSize(context, path);
    await precacheImage(
      ResizeImage(AssetImage(path), width: size.width, height: size.height),
      context,
    );
  }

  Future<void> precacheAll(BuildContext context) async {
    for (final path in AppAssets.all) {
      await _precache(context, path);
    }
  }

  Future<void> precache(BuildContext context, List<String> paths) async {
    for (final path in paths) {
      await _precache(context, path);
    }
  }
}
