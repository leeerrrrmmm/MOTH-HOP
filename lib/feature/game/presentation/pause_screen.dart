import 'package:curl_text/curl_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:moth_hop/core/app_assets/app_assets.dart';
import 'package:moth_hop/core/components/app_image_widget.dart';
import 'package:moth_hop/router/routes.dart';

class PauseScreen extends StatefulWidget {
  const PauseScreen({super.key});

  @override
  State<PauseScreen> createState() => _PauseScreenState();
}

class _PauseScreenState extends State<PauseScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final panelWidth = size.width * 0.88;
    final panelHeight = size.height * 0.72;
    return Scaffold(
      backgroundColor: Colors.black.withValues(alpha: 0.68),
      body: Center(
        child: SizedBox(
          width: panelWidth,
          height: panelHeight,
          child: Stack(
            alignment: Alignment.center,
            children: [
              AppImageWidget(
                height: 180.h,
                width: double.infinity,
                AppAssets.bottomElement,
                fit: BoxFit.fill,
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: panelWidth * 0.12,
                  vertical: panelHeight * 0.08,
                ),
                child: Column(
                  spacing: 10.h,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CurlTextWidget(
                      text: 'PAUSED',
                      fontSize: 36.sp,
                      textColor: const Color(0xFFCB832B),
                      strokeColor: Colors.white,
                      strokeWidth: 2,
                      fontFamily: 'Litia',
                      letterSpacing: 1,
                    ),
                    Expanded(
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                              bottom: panelHeight * 0.03,
                            ),
                            child: AppImageWidget(
                              AppAssets.mainPillow,
                              width: panelWidth * 0.76,
                              fit: BoxFit.contain,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              bottom: panelHeight * 0.09,
                            ),
                            child: AppImageWidget(
                              AppAssets.mainCharacter,
                              width: panelWidth * 0.52,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ],
                      ),
                    ),
                    _PauseButton(label: 'RESUME', onTap: () => context.pop()),

                    _PauseButton(
                      label: 'HOME',
                      onTap: () => context.go(Routes.home),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PauseButton extends StatelessWidget {
  const _PauseButton({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 180.w,
        height: 46.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: const Color(0xFFCB832B),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFFCE6CA), width: 2),
          boxShadow: const [
            BoxShadow(
              color: Color(0x663B1D0D),
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
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
