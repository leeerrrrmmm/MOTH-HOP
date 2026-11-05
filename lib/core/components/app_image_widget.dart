import 'package:flutter/material.dart';
import 'package:moth_hop/core/app_assets/app_assets.dart';

class AppImageWidget extends StatelessWidget {
  const AppImageWidget(
    this.path, {
    super.key,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
  });

  final String path;
  final double? width;
  final double? height;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    final cacheSize = AppAssets.cacheSize(context, path);
    return Image.asset(
      path,
      width: width,
      height: height,
      fit: fit,
      gaplessPlayback: true,
      cacheWidth: cacheSize.width,
      cacheHeight: cacheSize.height,
    );
  }
}
