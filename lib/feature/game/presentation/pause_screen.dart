import 'package:curl_text/curl_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:moth_hop/router/routes.dart';

class PauseScreen extends StatelessWidget {
  const PauseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withValues(alpha: 0.55),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CurlTextWidget(
              text: 'Paused',
              fontSize: 36.sp,
              textColor: const Color(0xFFCB832B),
              strokeColor: Colors.white,
              strokeWidth: 2,
              fontFamily: 'Litia',
              letterSpacing: 1,
            ),
            SizedBox(height: 28.h),
            _PauseButton(label: 'Resume', onTap: () => context.pop()),
            SizedBox(height: 12.h),
            _PauseButton(label: 'Home', onTap: () => context.go(Routes.home)),
          ],
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
