import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:moth_hop/core/app_assets/app_assets.dart';
import 'package:moth_hop/core/components/app_image_widget.dart';
import 'package:moth_hop/core/progress/progress_store.dart';
import 'package:moth_hop/core/progress/yarn_count_formatter.dart';
import 'package:moth_hop/feature/game/engine/game_cfg/game_config.dart';

class ScoreScreen extends StatelessWidget {
  const ScoreScreen({super.key});

  static const _cream = Color(0xFFFCE6CA);
  static const _gold = Color(0xFFCB832B);

  @override
  Widget build(BuildContext context) {
    final store = ProgressStore.instance;
    return ListenableBuilder(
      listenable: store,
      builder: (context, _) => Scaffold(
        backgroundColor: const Color(0xFF251B19),
        body: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            final height = constraints.maxHeight;
            return Stack(
              fit: StackFit.expand,
              children: [
                AppImageWidget(AppAssets.fBackgroundSelector, fit: BoxFit.fill),
                ColoredBox(color: Colors.black.withValues(alpha: 0.62)),
                SafeArea(
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: width * 0.05,
                          vertical: height * 0.02,
                        ),
                        child: Row(
                          children: [
                            _backButton(context),
                            const Spacer(),
                            Text(
                              'YOUR SCORE',
                              style: TextStyle(
                                fontFamily: 'Litia',
                                fontSize: (width * 0.07).clamp(23.0, 36.0),
                                color: _cream,
                                shadows: const [
                                  Shadow(color: _gold, blurRadius: 5),
                                ],
                              ),
                            ),
                            const Spacer(),
                            const SizedBox(width: 42, height: 42),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(
                            width * 0.05,
                            height * 0.04,
                            width * 0.05,
                            height * 0.05,
                          ),
                          child: Container(
                            width: double.infinity,

                            padding: EdgeInsets.symmetric(
                              horizontal: width * 0.08,
                              vertical: height * 0.06,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _scoreRow(
                                  icon: Icons.emoji_events_rounded,
                                  label: 'BEST SCORE',
                                  value: '${store.bestScore}',
                                  width: width,
                                ),
                                SizedBox(height: height * 0.035),
                                _scoreRow(
                                  icon: Icons.auto_awesome_rounded,
                                  label: 'YARNS',
                                  value: YarnCountFormatter.format(
                                    store.totalYarns,
                                  ),
                                  width: width,
                                ),
                                SizedBox(height: height * 0.035),
                                _scoreRow(
                                  icon: Icons.map_rounded,
                                  label: 'LOCATIONS OPEN',
                                  value:
                                      '${store.unlockedLocationCount} / ${GameConfig.locationCount}',
                                  width: width,
                                ),
                                SizedBox(height: height * 0.035),
                                _scoreRow(
                                  icon: Icons.bedtime_rounded,
                                  label: 'EQUIPPED SKIN',
                                  value: [
                                    'Classic',
                                    'Sky',
                                    'Honey',
                                  ][store.selectedSkin],
                                  width: width,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _scoreRow({
    required IconData icon,
    required String label,
    required String value,
    required double width,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: width * 0.075,
          color: const Color.fromARGB(255, 243, 244, 244),
        ),
        SizedBox(width: width * 0.04),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontFamily: 'Litia',
              color: const Color.fromARGB(255, 231, 228, 226),
              fontSize: (width * 0.038).clamp(13.0, 19.0),
            ),
          ),
        ),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: TextStyle(
              fontFamily: 'Litia',
              color: const Color.fromARGB(255, 216, 214, 211),
              fontSize: (width * 0.05).clamp(16.0, 24.0),
            ),
          ),
        ),
      ],
    );
  }

  Widget _backButton(BuildContext context) {
    return GestureDetector(
      onTap: context.pop,
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: _gold,
          shape: BoxShape.circle,
          border: Border.all(color: _cream, width: 2),
        ),
        child: const Icon(Icons.arrow_back, color: _cream),
      ),
    );
  }
}
