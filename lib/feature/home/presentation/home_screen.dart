import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:moth_hop/core/app_assets/app_assets.dart';
import 'package:moth_hop/core/components/app_image_widget.dart';
import 'package:moth_hop/core/progress/progress_store.dart';
import 'package:moth_hop/feature/game/engine/game_cfg/game_config.dart';
import 'package:moth_hop/feature/home/presentation/widgets/arc_carousel.dart';
import 'package:moth_hop/router/routes.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isSettingsTapped = false;
  bool isSoundOn = true;
  bool isVibrationOn = true;

  void _onSettingsTapped() =>
      setState(() => isSettingsTapped = !isSettingsTapped);

  void _onSoundTapped() => setState(() => isSoundOn = !isSoundOn);

  void _onVibrationTapped() => setState(() => isVibrationOn = !isVibrationOn);

  @override
  Widget build(BuildContext context) {
    final store = ProgressStore.instance;
    return ListenableBuilder(
      listenable: store,
      builder: (context, _) {
        final yarns = store.totalYarns;
        final unlockedLocations = store.unlockedLocationCount;
        return _buildScaffold(yarns, unlockedLocations);
      },
    );
  }

  Widget _buildScaffold(int yarns, int unlockedLocations) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Positioned.fill(
            bottom: 12.h,
            left: -18,
            right: -18,
            child: Image.asset(AppAssets.fBackgroundSelector),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 0, sigmaY: 0),
            child: Container(color: Colors.black.withValues(alpha: 0.5)),
          ),

          Column(
            children: [
              //?TOP ELEMENT
              Expanded(
                flex: 2,
                child: Container(
                  decoration: BoxDecoration(),
                  width: double.infinity,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 20.0,
                          left: 8.0,
                          right: 8.0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // COUNT BUTTON

                            Container(
                              margin: EdgeInsets.only(bottom: 114.h),
                              width: 60.w,
                              height: 30.w,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(AppAssets.counBtn),
                                ),
                              ),
                              child: Align(
                                alignment: Alignment.bottomRight,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    right: 6.0,
                                    bottom: 10.0,
                                  ),
                                  child: SizedBox(
                                    width: 30.w,
                                    height: 14.w,
                                    child: Center(
                                      child: Text(
                                        textAlign: TextAlign.center,
                                        yarns.toString(),
                                        style: TextStyle(
                                          fontSize: yarns.toString().length > 3
                                              ? 12.sp
                                              : 14.sp,
                                          fontWeight: FontWeight.w400,
                                          fontFamily: 'Litia',
                                          color: Color(0xFFFCE6CA),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            // LOGO
                            Padding(
                              padding: const EdgeInsets.only(
                                bottom: 30.0,
                                left: 0.0,
                              ),
                              child: AppImageWidget(
                                AppAssets.logo,
                                width: 240.w,
                                height: 120.h,
                                fit: BoxFit.fill,
                              ),
                            ),
                            // SETTINGS BUTTON
                            SizedBox(
                              width: 40.w,
                              height: 160.h,
                              child: Stack(
                                clipBehavior: Clip.none,
                                alignment: Alignment.topRight,
                                children: [
                                  // SOUND
                                  AnimatedPositioned(
                                    duration: const Duration(milliseconds: 400),
                                    curve: Curves.easeOut,
                                    top: isSettingsTapped ? 44 : 0,
                                    right: 0,
                                    child: IgnorePointer(
                                      ignoring: !isSettingsTapped,
                                      child: GestureDetector(
                                        behavior: HitTestBehavior.opaque,
                                        onTap: _onSoundTapped,
                                        child: AppImageWidget(
                                          isSoundOn
                                              ? AppAssets.btnSoundOn
                                              : AppAssets.btnSoundOff,
                                          width: 40.w,
                                          height: 40.w,
                                        ),
                                      ),
                                    ),
                                  ),
                                  // VIBRATION
                                  AnimatedPositioned(
                                    duration: const Duration(milliseconds: 400),
                                    curve: Curves.easeOut,
                                    top: isSettingsTapped ? 88 : 0,
                                    right: 0,
                                    child: IgnorePointer(
                                      ignoring: !isSettingsTapped,
                                      child: GestureDetector(
                                        behavior: HitTestBehavior.opaque,
                                        onTap: _onVibrationTapped,
                                        child: AppImageWidget(
                                          isVibrationOn
                                              ? AppAssets.btnVibrationOn
                                              : AppAssets.btnVibrationOff,
                                          width: 40.w,
                                          height: 40.w,
                                        ),
                                      ),
                                    ),
                                  ),
                                  // SETTINGS
                                  GestureDetector(
                                    behavior: HitTestBehavior.opaque,
                                    onTap: _onSettingsTapped,
                                    child: AnimatedRotation(
                                      turns: isSettingsTapped ? 0.5 : 0,
                                      duration: const Duration(
                                        milliseconds: 300,
                                      ),
                                      child: AppImageWidget(
                                        AppAssets.settingsIcon,
                                        width: 40.w,
                                        height: 40.w,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Main Character
                      Padding(
                        padding: EdgeInsets.only(top: 8.h, bottom: 8.h),
                        child: AppImageWidget(
                          AppAssets.mainCharacter,
                          width: 240.w,
                          height: 195.w,
                          fit: BoxFit.fill,
                        ),
                      ),
                      // Main Pillow
                      AppImageWidget(
                        AppAssets.mainPillow,
                        width: 250.w,
                        height: 54.w,
                        fit: BoxFit.fill,
                      ),
                    ],
                  ),
                ),
              ),
              //?BOTTOM ELEMENT
              Container(
                padding: EdgeInsets.only(top: 20.h),
                height: 290.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(AppAssets.bottomElement),
                    fit: BoxFit.fill,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Play Button
                    GestureDetector(
                      onTap: () => context.push(Routes.game),
                      child: AppImageWidget(
                        AppAssets.playBtn,
                        width: 90.w,
                        height: 90.w,
                      ),
                    ),
                    //! Flexible(child: ArcCarousel(itemCount: 5)),
                    //SCORE AND SHOP BUTTONS
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 12.0,
                        right: 12.0,
                        bottom: 4.0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Score Button
                          AppImageWidget(
                            AppAssets.scoreBtn,
                            width: 44.w,
                            height: 44.w,
                            fit: BoxFit.fill,
                          ),
                          // Shop Button
                          AppImageWidget(
                            AppAssets.shopBtn,
                            width: 44.w,
                            height: 44.w,
                            fit: BoxFit.fill,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Positioned.fill(
            top: 190.h,
            child: ArcCarousel(
              itemCount: GameConfig.locationCount,
              unlockedCount: unlockedLocations,
              initialIndex: unlockedLocations - 1,
            ),
          ),
        ],
      ),
    );
  }
}
