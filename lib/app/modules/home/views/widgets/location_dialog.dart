import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../config/translations/strings_enum.dart';
import '../../../../components/custom_button.dart';
import '../../controllers/home_controller.dart';

class LocationDialog extends StatelessWidget {
  const LocationDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    return Dialog(
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(30.r),
        ),
      ),
      insetPadding: EdgeInsets.symmetric(horizontal: 26.w),
      child: Container(
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(30.r),
        ),
        padding: EdgeInsets.symmetric(horizontal: 35.w, vertical: 28.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Location icon in a styled circle
            Container(
              width: 110.r,
              height: 110.r,
              decoration: BoxDecoration(
                color: theme.primaryColor.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(
                  Icons.my_location_rounded,
                  size: 52.sp,
                  color: theme.primaryColor,
                ),
              ),
            ).animate().fade().scale(
                  duration: 350.ms,
                  curve: Curves.easeOutBack,
                ),
            28.verticalSpace,
            Text(
              Strings.locationPermissionNeeded.tr,
              style: theme.textTheme.displayMedium?.copyWith(fontSize: 18.sp),
              textAlign: TextAlign.center,
            ).animate().fade().slideY(
              duration: 300.ms,
              begin: 0.3,
              curve: Curves.easeOut,
            ),
            14.verticalSpace,
            Text(
              Strings.pleaseEnableLocationPermission.tr,
              style: theme.textTheme.bodyMedium?.copyWith(height: 1.55),
              textAlign: TextAlign.center,
            ).animate().fade().slideY(
              duration: 300.ms,
              begin: 0.3,
              curve: Curves.easeOut,
            ),
            36.verticalSpace,
            CustomButton(
              onPressed: () {
                Get.back();
                HomeController.instance.getUserLocation();
              },
              text: Strings.allowLocation.tr,
              fontSize: 16.sp,
              backgroundColor: theme.primaryColor,
              foregroundColor: Colors.white,
              width: double.infinity,
              radius: 30.r,
              verticalPadding: 18.h,
            ).animate().fade().slideY(
              duration: 300.ms,
              begin: 0.5,
              curve: Curves.easeOut,
            ),
          ],
        ),
      ),
    );
  }
}