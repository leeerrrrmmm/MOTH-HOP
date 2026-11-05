import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:moth_hop/core/app_assets/app_assets.dart';
import 'package:moth_hop/core/app_assets/asset_loader.dart';
import 'package:moth_hop/core/components/app_image_widget.dart';
import 'package:moth_hop/router/routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  static const _assetLoader = AssetLoader();
  static const _minSplashDuration = Duration(milliseconds: 2200);

  late final AnimationController _bounce = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 620),
  )..repeat(reverse: true);
  bool _navigated = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _bootstrap());
  }

  Future<void> _bootstrap() async {
    try {
      await Future.wait([
        Future<void>.delayed(_minSplashDuration),
        _assetLoader.precacheAll(context),
      ]);
    } catch (error, stackTrace) {
      debugPrint('Splash setup failed: $error\n$stackTrace');
    }
    if (!mounted || _navigated) return;
    _navigated = true;
    context.go(Routes.home);
  }

  @override
  void dispose() {
    _bounce.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF15213F),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          final height = constraints.maxHeight;
          final characterWidth = width * 0.38;
          return Stack(
            fit: StackFit.expand,
            children: [
              AppImageWidget(AppAssets.thirdBackground, fit: BoxFit.cover),
              ColoredBox(
                color: const Color(0xFF102044).withValues(alpha: 0.18),
              ),
              Positioned(
                left: width * 0.08,
                right: width * 0.08,
                top: height * 0.035,
                height: height * 0.16,
                child: AppImageWidget(AppAssets.logo, fit: BoxFit.contain),
              ),
              Positioned(
                left: width * 0.035,
                right: width * 0.035,
                top: height * 0.77,
                height: height * 0.19,
                child: AppImageWidget(
                  AppAssets.mainPillow,
                  fit: BoxFit.contain,
                ),
              ),
              for (var index = 0; index < 3; index++)
                Positioned(
                  left: width * (0.015 + index * 0.29),
                  top: height * 0.49,
                  width: characterWidth,
                  height: height * 0.34,
                  child: AnimatedBuilder(
                    animation: _bounce,
                    builder: (context, child) {
                      final phase = index * math.pi * 0.62;
                      final offsetY =
                          math.sin((_bounce.value * math.pi) + phase) *
                          height *
                          0.018;
                      return Transform.translate(
                        offset: Offset(0, -offsetY),
                        child: child,
                      );
                    },
                    child: AppImageWidget(
                      AppAssets.characterForSkin(index),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              Positioned(
                bottom: height * 0.035,
                left: 0,
                right: 0,
                child: const Center(
                  child: SizedBox(
                    width: 30,
                    height: 30,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      color: Color(0xFFFCE6CA),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
