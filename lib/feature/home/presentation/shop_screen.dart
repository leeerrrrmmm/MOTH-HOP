import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:moth_hop/core/app_assets/app_assets.dart';
import 'package:moth_hop/core/components/app_image_widget.dart';
import 'package:moth_hop/core/progress/progress_store.dart';
import 'package:moth_hop/core/progress/yarn_count_formatter.dart';

class ShopScreen extends StatelessWidget {
  const ShopScreen({super.key});

  static const _skinCosts = [0, 300, 600];
  static const _skinNames = ['Classic', 'Sky', 'Honey'];
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
                          vertical: height * 0.015,
                        ),
                        child: Row(
                          children: [
                            _backButton(context),
                            const Spacer(),
                            Text(
                              'SHOP',
                              style: TextStyle(
                                fontFamily: 'Litia',
                                fontSize: (width * 0.075).clamp(24.0, 38.0),
                                color: _cream,
                                shadows: const [
                                  Shadow(color: _gold, blurRadius: 5),
                                ],
                              ),
                            ),
                            const Spacer(),
                            _yarnCount(store.totalYarns, width),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(
                            width * 0.035,
                            height * 0.015,
                            width * 0.035,
                            height * 0.025,
                          ),
                          child: Stack(
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: width * 0.035,
                                  vertical: height * 0.04,
                                ),
                                child: Row(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: List.generate(
                                    _skinCosts.length,
                                    (skin) => Expanded(
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: width * 0.012,
                                        ),
                                        child: _skinCard(
                                          context,
                                          store: store,
                                          skin: skin,
                                          width: width,
                                          height: height,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
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

  Widget _skinCard(
    BuildContext context, {
    required ProgressStore store,
    required int skin,
    required double width,
    required double height,
  }) {
    final owned = store.ownsSkin(skin);
    final selected = store.selectedSkin == skin;
    final previewSize = (width * 0.23).clamp(64.0, 130.0);
    final labelSize = (width * 0.045).clamp(14.0, 21.0);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          child: AppImageWidget(
            AppAssets.characterForSkin(skin),
            width: previewSize,
            height: previewSize,
            fit: BoxFit.contain,
          ),
        ),
        SizedBox(height: height * 0.012),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            _skinNames[skin],
            style: TextStyle(
              fontFamily: 'Litia',
              color: const Color.fromARGB(255, 253, 252, 252),
              fontSize: labelSize,
            ),
          ),
        ),
        SizedBox(height: height * 0.012),
        SizedBox(
          width: double.infinity,
          child: _goldButton(
            label: owned
                ? (selected ? 'SELECTED' : 'SELECT')
                : '${_skinCosts[skin]} YARNS',
            width: width,
            onTap: () async {
              if (owned) {
                await store.selectSkin(skin);
                return;
              }
              final purchased = await store.purchaseSkin(
                skin: skin,
                cost: _skinCosts[skin],
              );
              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    purchased
                        ? '${_skinNames[skin]} is now yours!'
                        : 'Not enough yarns yet.',
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _yarnCount(int total, double width) {
    return SizedBox(
      width: width * 0.19,
      height: width * 0.09,
      child: Stack(
        alignment: Alignment.center,
        children: [
          AppImageWidget(AppAssets.counBtn, fit: BoxFit.fill),
          Padding(
            padding: EdgeInsets.only(left: width * 0.035),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                YarnCountFormatter.format(total),
                style: TextStyle(
                  fontFamily: 'Litia',
                  fontSize: width * 0.038,
                  color: _cream,
                ),
              ),
            ),
          ),
        ],
      ),
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

  Widget _goldButton({
    required String label,
    required double width,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        constraints: const BoxConstraints(minHeight: 40),
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
        decoration: BoxDecoration(
          color: _gold,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: _cream, width: 2),
          boxShadow: const [
            BoxShadow(
              color: Color(0x663B1D0D),
              blurRadius: 4,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Litia',
              fontSize: (width * 0.033).clamp(11.0, 16.0),
              color: _cream,
            ),
          ),
        ),
      ),
    );
  }
}
