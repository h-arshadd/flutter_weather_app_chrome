import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class WeatherDetailsItem extends StatelessWidget {
  final String title;
  final String icon; // kept for API compat, ignored internally
  final String value;
  final String text;
  final bool isHalfCircle;

  const WeatherDetailsItem({
    super.key,
    required this.title,
    required this.icon,
    required this.value,
    required this.text,
    this.isHalfCircle = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    // Wind → tornado/swirl icon. Pressure → compress/gauge icon.
    // Using distinct icons so they look different from each other.
    final IconData iconData =
        isHalfCircle ? Icons.compress_rounded : Icons.tornado_rounded;

    return Container(
      width: 180.w,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(30.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header chip ──────────────────────────────────
          Container(
            height: 32,  // fixed height — no .h scaling
            padding: const EdgeInsetsDirectional.only(end: 10),
            decoration: BoxDecoration(
              color: theme.canvasColor,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Square-rounded icon badge
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: theme.primaryColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    iconData,
                    color: Colors.white,
                    size: 17,
                  ),
                ),
                const SizedBox(width: 7),
                Text(title, style: theme.textTheme.bodyLarge),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // ── Circular ring ────────────────────────────────
          CircularStepProgressIndicator(
            totalSteps: 32,
            currentStep: 16,
            stepSize: 20,
            selectedColor: theme.primaryColor,
            unselectedColor: theme.primaryColorLight,
            padding: pi / 80,
            width: 150.w,
            height: 150.h,
            startingAngle: pi * 2 / 3,
            arcSize: isHalfCircle ? pi * 2 / 3 * 2 : pi * 2,
            gradientColor: LinearGradient(
              colors: [theme.primaryColor, theme.primaryColorLight],
            ),
            child: Padding(
              padding: EdgeInsets.all(15.r),
              child: CircleAvatar(
                backgroundColor: theme.primaryColor,
                radius: 30.r,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      value,
                      style: theme.textTheme.displayMedium?.copyWith(
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      text,
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontSize: 12.sp,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}