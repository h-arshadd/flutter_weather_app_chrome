import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../utils/extensions.dart';
import '../../../../components/custom_cached_image.dart';
import '../../../../data/models/weather_details_model.dart';
import '../../controllers/weather_controller.dart';

class ForecastHourItem extends StatelessWidget {
  final Hour hour;
  const ForecastHourItem({super.key, required this.hour});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final ctrl = Get.find<WeatherController>();

    return Container(
      // Fixed pixel dimensions — no ScreenUtil so Chrome can't scale them up
      width: 64,
      margin: const EdgeInsetsDirectional.only(end: 10),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            hour.time.convertToTime(),
            style: theme.textTheme.bodySmall?.copyWith(fontSize: 11),
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          CustomCachedImage(
            imageUrl: hour.condition.icon.addHttpPrefix(),
            fit: BoxFit.contain,
            width: 36,
            height: 36,
          ),
          const SizedBox(height: 4),
          Text(
            ctrl.displayTemp(hour.tempC.toDouble()),
            style: theme.textTheme.bodySmall?.copyWith(
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}