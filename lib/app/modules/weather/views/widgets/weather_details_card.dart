import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../utils/extensions.dart';
import '../../../../components/custom_cached_image.dart';
import '../../../../data/models/weather_details_model.dart';
import '../../controllers/weather_controller.dart';

class WeatherDetailsCard extends StatelessWidget {
  final WeatherDetailsModel weatherDetails;
  final Forecastday forecastDay;
  const WeatherDetailsCard({
    super.key,
    required this.weatherDetails,
    required this.forecastDay,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final ctrl = Get.find<WeatherController>();

    return Container(
      padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 24.h),
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.primaryColor,
            theme.primaryColor.withOpacity(0.80),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28.r),
        boxShadow: [
          BoxShadow(
            color: theme.primaryColor.withOpacity(0.30),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          28.verticalSpace,
          CustomCachedImage(
            imageUrl:
                forecastDay.day.condition.icon.toHighRes().addHttpPrefix(),
            fit: BoxFit.cover,
            width: 130.w,
            height: 130.h,
            color: Colors.white,
          ),
          20.verticalSpace,
          Text(
            '${weatherDetails.location.name.toRightCity()}, ${weatherDetails.location.country.toRightCountry()}',
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          10.verticalSpace,
          Text(
            ctrl.displayTempLarge(forecastDay.day.maxtempC.toDouble()),
            style: TextStyle(
              color: Colors.white,
              fontSize: 60.sp,
              fontWeight: FontWeight.w700,
              height: 1,
            ),
          ),
          10.verticalSpace,
          Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Text(
              forecastDay.day.condition.text,
              style: TextStyle(
                color: Colors.white,
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          16.verticalSpace,
          // Min / Max row
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _TempChip(
                label: 'H',
                value: ctrl.displayTemp(forecastDay.day.maxtempC.toDouble()),
              ),
              16.horizontalSpace,
              _TempChip(
                label: 'L',
                value: ctrl.displayTemp(forecastDay.day.mintempC.toDouble()),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TempChip extends StatelessWidget {
  final String label;
  final String value;
  const _TempChip({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '$label: ',
          style: TextStyle(
            color: Colors.white60,
            fontSize: 13.sp,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: Colors.white,
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}