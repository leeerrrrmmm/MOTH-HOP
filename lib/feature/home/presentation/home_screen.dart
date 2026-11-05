import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:moth_hop/core/app_assets/app_assets.dart';
import 'package:moth_hop/core/components/app_image_widget.dart';
import 'package:moth_hop/core/progress/progress_store.dart';
import 'package:moth_hop/core/progress/yarn_count_formatter.dart';
import 'package:moth_hop/feature/game/engine/game_cfg/game_config.dart';
import 'package:moth_hop/feature/home/presentation/widgets/arc_carousel.dart';
import 'package:moth_hop/router/routes.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _settingsExpanded = false;
  bool _soundOn = true;
  bool _vibrationOn = true;

  @override
  Widget build(BuildContext context) {
    final store = ProgressStore.instance;
    return ListenableBuilder(
      listenable: store,
      builder: (context, _) {
        return LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            final height = constraints.maxHeight;
            final panelHeight = height * 0.385;
            final selectedSkin = store.selectedSkin;

            return Scaffold(
              backgroundColor: Colors.transparent,
              body: Stack(
                fit: StackFit.expand,
                children: [
                  Positioned.fill(
                    child: AppImageWidget(
                      AppAssets.homeBackgroundForLocation(
                        store.selectedLocation,
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned.fill(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 0, sigmaY: 0),
                      child: ColoredBox(
                        color: Colors.black.withValues(alpha: 0.5),
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      Expanded(
                        child: _buildHero(
                          width: width,
                          height: height,
                          yarns: store.totalYarns,
                          skin: selectedSkin,
                        ),
                      ),
                      SizedBox(
                        height: panelHeight,
                        width: width,
                        child: _buildBottomPanel(
                          width: width,
                          height: panelHeight,
                          selectedLocation: store.selectedLocation,
                          unlockedCount: store.unlockedLocationCount,
                          onLocationSelected: store.selectLocation,
                          onPlay: () => context.push(
                            Routes.game,
                            extra: store.selectedLocation,
                          ),
                          onScore: () => context.push(Routes.score),
                          onShop: () => context.push(Routes.shop),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildHero({
    required double width,
    required double height,
    required int yarns,
    required int skin,
  }) {
    final iconSize = (width * 0.1).clamp(34.0, 60.0);
    final characterWidth = width * 0.65;
    final characterHeight = height * 0.34;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(
          top: height * 0.018,
          left: width * 0.035,
          width: width * 0.18,
          height: height * 0.075,
          child: Stack(
            alignment: Alignment.center,
            children: [
              AppImageWidget(AppAssets.counBtn, fit: BoxFit.fill),
              Padding(
                padding: EdgeInsets.only(left: width * 0.035),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    YarnCountFormatter.format(yarns),
                    style: TextStyle(
                      fontFamily: 'Litia',
                      color: const Color(0xFFFCE6CA),
                      fontSize: width * 0.04,
                      shadows: const [
                        Shadow(color: Color(0xFF915B1F), blurRadius: 2),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: height * 0.025,
          left: width * 0.19,
          right: width * 0.19,
          height: height * 0.15,
          child: AppImageWidget(AppAssets.logo, fit: BoxFit.contain),
        ),
        Positioned(
          top: height * 0.02,
          right: width * 0.035,
          child: Column(
            children: [
              _imageButton(
                AppAssets.settingsIcon,
                size: iconSize,
                onTap: () =>
                    setState(() => _settingsExpanded = !_settingsExpanded),
              ),
              AnimatedSize(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOut,
                child: _settingsExpanded
                    ? Column(
                        children: [
                          SizedBox(height: height * 0.008),
                          _imageButton(
                            _soundOn
                                ? AppAssets.btnSoundOn
                                : AppAssets.btnSoundOff,
                            size: iconSize * 0.99,
                            onTap: () => setState(() => _soundOn = !_soundOn),
                          ),
                          SizedBox(height: height * 0.006),
                          _imageButton(
                            _vibrationOn
                                ? AppAssets.btnVibrationOn
                                : AppAssets.btnVibrationOff,
                            size: iconSize * 0.99,
                            onTap: () =>
                                setState(() => _vibrationOn = !_vibrationOn),
                          ),
                        ],
                      )
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        ),
        Positioned(
          left: (width - characterWidth) / 2,
          bottom: height * 0.08,
          width: characterWidth,
          height: characterHeight,
          child: AppImageWidget(
            AppAssets.characterForSkin(skin),
            fit: BoxFit.contain,
          ),
        ),
        Positioned(
          left: width * 0.12,
          right: width * 0.12,
          bottom: 0,
          height: height * 0.1,
          child: AppImageWidget(AppAssets.mainPillow, fit: BoxFit.fill),
        ),
      ],
    );
  }

  Widget _buildBottomPanel({
    required double width,
    required double height,
    required int selectedLocation,
    required int unlockedCount,
    required ValueChanged<int> onLocationSelected,
    required VoidCallback onPlay,
    required VoidCallback onScore,
    required VoidCallback onShop,
  }) {
    final actionSize = (width * 0.9).clamp(48.0, 100.0);
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned.fill(
          top: 10.h,
          child: AppImageWidget(AppAssets.bottomElement, fit: BoxFit.fill),
        ),
        Positioned.fill(
          child: ArcCarousel(
            key: ValueKey('$selectedLocation:$unlockedCount'),
            itemCount: GameConfig.locationCount,
            unlockedCount: unlockedCount,
            initialIndex: selectedLocation,
            onSelected: onLocationSelected,
          ),
        ),
        Positioned(
          top: height * 0.09,
          left: (width - actionSize) / 2.2,
          child: _imageButton(AppAssets.playBtn, size: 140, onTap: onPlay),
        ),
        Positioned(
          left: width * 0.015,
          bottom: height * 0.018,
          child: _imageButton(
            AppAssets.scoreBtn,
            size: actionSize * 0.58,
            onTap: onScore,
          ),
        ),
        Positioned(
          right: width * 0.015,
          bottom: height * 0.018,
          child: _imageButton(
            AppAssets.shopBtn,
            size: actionSize * 0.58,
            onTap: onShop,
          ),
        ),
      ],
    );
  }

  Widget _imageButton(
    String asset, {
    required double size,
    required VoidCallback onTap,
  }) {
    return Semantics(
      button: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: SizedBox(
          width: size,
          height: size,
          child: AppImageWidget(asset, fit: BoxFit.contain),
        ),
      ),
    );
  }
}
