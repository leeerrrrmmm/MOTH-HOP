import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:moth_hop/core/app_assets/app_assets.dart';
import 'package:moth_hop/core/app_assets/asset_loader.dart';
import 'package:moth_hop/router/routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  static const _assetLoader = AssetLoader();
  static const _minSplashDuration = Duration(seconds: 2);

  bool _started = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_started) return;
    _started = true;
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    // Мінімальний час показу + прогрів паралельно
    await Future.wait([
      Future.delayed(_minSplashDuration),
      _assetLoader.precacheAll(context),
    ]);

    if (!mounted) return;
    context.go(Routes.home);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(
            child: Image.asset(
              AppAssets.splashBackground,
              fit: BoxFit.cover,
              gaplessPlayback: true,
            ),
          ),
        ],
      ),
    );
  }
}
