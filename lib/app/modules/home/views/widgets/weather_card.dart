import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../utils/extensions.dart';
import '../../../../../config/translations/strings_enum.dart';
import '../../../../components/custom_cached_image.dart';
import '../../../../data/models/weather_model.dart';
import '../../../../routes/app_pages.dart';

class WeatherCard extends StatelessWidget {
  final WeatherModel weather;
  final bool isCelsius;
  const WeatherCard({super.key, required this.weather, this.isCelsius = true});

  String _tempDisplay(double tempC) {
    if (isCelsius) return '${tempC.round()}°C';
    return '${((tempC * 9 / 5) + 32).round()}°F';
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    return GestureDetector(
      onTap: () => Get.toNamed(
        Routes.WEATHER,
        arguments: '${weather.location.lat},${weather.location.lon}',
      ),
      child: Container(
        padding: EdgeInsets.all(18.r),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              theme.primaryColor,
              theme.primaryColor.withOpacity(0.75),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24.r),
          boxShadow: [
            BoxShadow(
              color: theme.primaryColor.withOpacity(0.25),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Left info column
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.location_on_rounded,
                          color: Colors.white70, size: 14.sp),
                      4.horizontalSpace,
                      Flexible(
                        child: Text(
                          weather.location.country.toRightCountry(),
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  6.verticalSpace,
                  Text(
                    weather.location.name.toRightCity(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  8.verticalSpace,
                  Text(
                    _tempDisplay(weather.current.tempC.toDouble()),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32.sp,
                      fontWeight: FontWeight.w700,
                      height: 1,
                    ),
                  ),
                  6.verticalSpace,
                  Text(
                    weather.current.condition.text,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.85),
                      fontSize: 12.sp,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ).animate().slideX(
                    duration: 200.ms, begin: -0.2, curve: Curves.easeOut),
            ),
            16.horizontalSpace,
            // Right icon column
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomCachedImage(
                  imageUrl: weather.current.condition.icon
                      .toHighRes()
                      .addHttpPrefix(),
                  fit: BoxFit.cover,
                  width: 80.w,
                  height: 80.h,
                  color: Colors.white,
                ),
                // Small tap hint
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Details',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 11.sp,
                      ),
                    ),
                    2.horizontalSpace,
                    Icon(Icons.arrow_forward_ios_rounded,
                        color: Colors.white70, size: 10.sp),
                  ],
                ),
              ],
            ).animate().slideX(
                  duration: 200.ms, begin: 0.2, curve: Curves.easeOut),
          ],
        ),
      ),
    );
  }
}