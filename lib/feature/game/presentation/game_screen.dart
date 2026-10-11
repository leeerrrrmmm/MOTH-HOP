import 'dart:async';

import 'package:curl_text/curl_text.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:moth_hop/core/app_assets/app_assets.dart';
import 'package:moth_hop/core/components/app_image_widget.dart';
import 'package:moth_hop/core/progress/progress_store.dart';
import 'package:moth_hop/feature/game/engine/game_world/game_world.dart';
import 'package:moth_hop/router/routes.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  int _score = 0;
  int _yarns = 0;
  bool _isGameOver = false;
  bool _roundSaved = false;

  late final GameWorld _game = GameWorld(
    onScoreChanged: (score, yarns) {
      if (!mounted) return;
      if (_score == score && _yarns == yarns) return;
      setState(() {
        _score = score;
        _yarns = yarns;
      });
      unawaited(ProgressStore.instance.recordBestScore(score));
    },
    onGameOver: _onGameOver,
  );

  void _onGameOver() {
    if (!mounted || _isGameOver) return;
    setState(() => _isGameOver = true);
    unawaited(_saveRound());
  }

  Future<void> _saveRound() async {
    if (_roundSaved) return;
    _roundSaved = true;
    await ProgressStore.instance.recordRound(score: _score, yarns: _yarns);
  }

  Future<void> _openPause() async {
    if (_isGameOver) return;
    _game.pauseGame();
    await context.push(Routes.pause);
    if (!mounted) return;
    _game.resumeGame();
  }

  Future<void> _playAgain() async {
    await _saveRound();
    if (!mounted) return;
    setState(() {
      _isGameOver = false;
      _roundSaved = false;
      _score = 0;
      _yarns = 0;
    });
    await _game.restart();
  }

  @override
  void dispose() {
    unawaited(_saveRound());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(child: GameWidget(game: _game)),
          Positioned(
            top: 4.h,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 114.h),
                    width: 60.w,
                    height: 70.w,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(AppAssets.counBtn),
                      ),
                    ),
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                        padding: const EdgeInsets.only(
                          right: 6.0,
                          bottom: 30.0,
                        ),
                        child: SizedBox(
                          width: 30.w,
                          height: 14.w,
                          child: Center(
                            child: Text(
                              '$_yarns',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w400,
                                fontFamily: 'Litia',
                                color: const Color(0xFFFCE6CA),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CurlTextWidget(
                        text: 'Score',
                        fontSize: 26.sp,
                        textColor: const Color(0xFFCB832B),
                        strokeColor: Colors.white,
                        strokeWidth: 2,
                        fontFamily: 'Litia',
                        letterSpacing: 1,
                      ),
                      CurlTextWidget(
                        text: _score.toString().padLeft(4, '0'),
                        fontSize: 18.sp,
                        textColor: const Color(0xFF915B1F),
                        strokeColor: Colors.white,
                        strokeWidth: 2,
                        fontFamily: 'Litia',
                        letterSpacing: 1,
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: _openPause,
                    child: AppImageWidget(
                      AppAssets.pauseBtn,
                      width: 40.w,
                      height: 70.w,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_isGameOver)
            _GameOverOverlay(
              score: _score,
              yarns: _yarns,
              onPlayAgain: _playAgain,
              onHome: () async {
                await _saveRound();
                if (context.mounted) context.go(Routes.home);
              },
            ),
        ],
      ),
    );
  }
}

class _GameOverOverlay extends StatelessWidget {
  const _GameOverOverlay({
    required this.score,
    required this.yarns,
    required this.onPlayAgain,
    required this.onHome,
  });

  final int score;
  final int yarns;
  final VoidCallback onPlayAgain;
  final VoidCallback onHome;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: ColoredBox(
        color: Colors.black.withValues(alpha: 0.55),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CurlTextWidget(
                text: 'Game Over',
                fontSize: 36.sp,
                textColor: const Color(0xFFCB832B),
                strokeColor: Colors.white,
                strokeWidth: 2,
                fontFamily: 'Litia',
                letterSpacing: 1,
              ),
              SizedBox(height: 8.h),
              CurlTextWidget(
                text: 'Score  ${score.toString().padLeft(4, '0')}',
                fontSize: 20.sp,
                textColor: const Color(0xFF915B1F),
                strokeColor: Colors.white,
                strokeWidth: 2,
                fontFamily: 'Litia',
                letterSpacing: 1,
              ),
              SizedBox(height: 12.h),
              Container(
                width: 60.w,
                height: 70.w,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(AppAssets.counBtn),
                  ),
                ),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 6.0, bottom: 30.0),
                    child: SizedBox(
                      width: 30.w,
                      height: 14.w,
                      child: Center(
                        child: Text(
                          '$yarns',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: yarns.toString().length > 3
                                ? 12.sp
                                : 14.sp,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Litia',
                            color: const Color(0xFFFCE6CA),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 28.h),
              _MenuButton(label: 'Play Again', onTap: onPlayAgain),
              SizedBox(height: 12.h),
              _MenuButton(label: 'Home', onTap: onHome),
            ],
          ),
        ),
      ),
    );
  }
}

class _MenuButton extends StatelessWidget {
  const _MenuButton({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 180.w,
        height: 48.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: const Color(0xFFCB832B),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.white, width: 2),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 20.sp,
            fontFamily: 'Litia',
            color: const Color(0xFFFCE6CA),
          ),
        ),
      ),
    );
  }
}
