import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../utils/extensions.dart';
import '../../../../config/translations/strings_enum.dart';
import '../../../../utils/constants.dart';
import '../../../components/api_error_widget.dart';
import '../../../components/custom_cached_image.dart';
import '../../../components/my_widgets_animator.dart';
import '../../../data/models/weather_details_model.dart';
import '../controllers/weather_controller.dart';
import 'widgets/forecast_hour_item.dart';
import 'widgets/sun_rise_set_item.dart';
import 'widgets/weather_details_item.dart';
import 'widgets/weather_row_data.dart';

class WeatherView extends GetView<WeatherController> {
  const WeatherView({Key? key}) : super(key: key);

  // ---- Search sheet ----
  void _showSearchSheet(BuildContext context) {
    final theme = context.theme;
    final textCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: theme.cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
      ),
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          left: 24.w,
          right: 24.w,
          top: 20.h,
          bottom: MediaQuery.of(context).viewInsets.bottom + 32.h,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40.w, height: 4.h,
                decoration: BoxDecoration(
                  color: theme.dividerColor,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
            ),
            20.verticalSpace,
            Text('Search Location',
                style: theme.textTheme.displayMedium?.copyWith(fontSize: 18.sp)),
            8.verticalSpace,
            Text('Enter any city name to view its weather',
                style: theme.textTheme.bodyMedium),
            20.verticalSpace,
            TextField(
              controller: textCtrl,
              autofocus: true,
              textInputAction: TextInputAction.search,
              style: theme.textTheme.bodyLarge,
              decoration: InputDecoration(
                hintText: 'e.g. London, Dubai, Tokyo...',
                hintStyle: theme.textTheme.bodyMedium,
                prefixIcon: Icon(Icons.search_rounded,
                    color: theme.primaryColor, size: 22.sp),
                filled: true,
                fillColor: theme.canvasColor,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.r),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.r),
                  borderSide: BorderSide(color: theme.primaryColor, width: 1.5),
                ),
              ),
              onSubmitted: (value) {
                if (value.trim().isNotEmpty) {
                  Navigator.pop(context);
                  controller.searchAndLoadLocation(value.trim());
                }
              },
            ),
            20.verticalSpace,
            Text('Popular cities',
                style: theme.textTheme.bodyMedium
                    ?.copyWith(fontWeight: FontWeight.w600)),
            12.verticalSpace,
            Wrap(
              spacing: 8.w,
              runSpacing: 8.h,
              children: [
                'London', 'New York', 'Tokyo', 'Dubai',
                'Paris', 'Sydney', 'Singapore', 'Istanbul',
              ].map((city) {
                return GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    controller.searchAndLoadLocation(city);
                  },
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 12.w, vertical: 7.h),
                    decoration: BoxDecoration(
                      color: theme.primaryColor.withOpacity(0.10),
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(
                          color: theme.primaryColor.withOpacity(0.25)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.location_on_outlined,
                            size: 13.sp, color: theme.primaryColor),
                        3.horizontalSpace,
                        Text(city,
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                              color: theme.primaryColor,
                            )),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
            16.verticalSpace,
          ],
        ),
      ),
    );
  }

  // ---- Settings sheet ----
  void _showSettingsSheet(BuildContext context) {
    final theme = context.theme;
    showModalBottomSheet(
      context: context,
      backgroundColor: theme.cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (_) => GetBuilder<WeatherController>(
        builder: (_) => SingleChildScrollView(
          child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 36),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40, height: 4,
                  decoration: BoxDecoration(
                    color: theme.dividerColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(Strings.settings.tr, style: theme.textTheme.displayMedium),
              24.verticalSpace,
              Text(Strings.theme.tr, style: theme.textTheme.bodyLarge),
              12.verticalSpace,
              _SettingToggleRow(
                labelOn: Strings.lightMode.tr,
                labelOff: Strings.darkMode.tr,
                isOn: controller.isLightTheme,
                icon: Icons.brightness_6_outlined,
                onTap: () {
                  controller.onChangeThemePressed();
                  Navigator.of(context).pop();
                  _showSettingsSheet(context);
                },
              ),
              20.verticalSpace,
              Text(Strings.language.tr, style: theme.textTheme.bodyLarge),
              12.verticalSpace,
              _SettingToggleRow(
                labelOn: 'English',
                labelOff: 'اردو',
                isOn: controller.currentLanguage == 'en',
                icon: Icons.language,
                onTap: () {
                  Navigator.of(context).pop();
                  controller.onChangeLanguagePressed();
                },
              ),
              20.verticalSpace,
              Text(Strings.tempUnit.tr, style: theme.textTheme.bodyLarge),
              12.verticalSpace,
              _SettingToggleRow(
                labelOn: '°C  Celsius',
                labelOff: '°F  Fahrenheit',
                isOn: controller.isCelsius,
                icon: Icons.thermostat_outlined,
                onTap: () => controller.onChangeTempUnit(),
              ),
              20.verticalSpace,
              Text(Strings.windUnit.tr, style: theme.textTheme.bodyLarge),
              12.verticalSpace,
              _SettingToggleRow(
                labelOn: 'km/h',
                labelOff: 'mph',
                isOn: controller.isKmh,
                icon: Icons.air,
                onTap: () => controller.onChangeWindUnit(),
              ),
            ],
          ),
        ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 430),
          child: SafeArea(
            child: GetBuilder<WeatherController>(
              builder: (_) => MyWidgetsAnimator(
                apiCallStatus: controller.apiCallStatus,
                loadingWidget: () => _LoadingView(theme: theme),
                errorWidget: () => ApiErrorWidget(
                  retryAction: () => controller.getWeatherDetails(),
                ),
                successWidget: () => _SuccessBody(
                  controller: controller,
                  onSearch: () => _showSearchSheet(context),
                  onSettings: () => _showSettingsSheet(context),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================
// Success body — extracted widget so it can use context nicely
// ============================================================
class _SuccessBody extends StatelessWidget {
  final WeatherController controller;
  final VoidCallback onSearch;
  final VoidCallback onSettings;

  const _SuccessBody({
    required this.controller,
    required this.onSearch,
    required this.onSettings,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final loc = controller.weatherDetails.location;
    final fd = controller.forecastday;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          16.verticalSpace,

          // ── Top bar ──────────────────────────────────────
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            controller.isCurrentLocation
                                ? Icons.my_location_rounded
                                : Icons.location_on_rounded,
                            color: theme.primaryColor,
                            size: 13.sp,
                          ),
                          4.horizontalSpace,
                          Text(
                            controller.isCurrentLocation
                                ? 'My Location'
                                : 'Searched',
                            style: TextStyle(
                              color: theme.primaryColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 11.sp,
                            ),
                          ),
                        ],
                      ),
                      3.verticalSpace,
                      Text(
                        '${loc.name.toRightCity()}, ${loc.country.toRightCountry()}',
                        style: theme.textTheme.displayMedium
                            ?.copyWith(fontSize: 14.sp),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                _TopBarBtn(icon: Icons.search_rounded, onTap: onSearch),
                8.horizontalSpace,
                _TopBarBtn(icon: Icons.tune_rounded, onTap: onSettings),
              ],
            ),
          ),
          20.verticalSpace,

          // ── Single weather card (today) ───────────────────
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: _WeatherCard(controller: controller, fd: fd),
          ),
          24.verticalSpace,

          // ── 24-hour forecast ──────────────────────────────
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Text(Strings.hoursForecast.tr,
                style: theme.textTheme.displayMedium),
          ),
          12.verticalSpace,
          SizedBox(
            height: 110,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              itemCount: fd.hour.length,
              itemBuilder: (context, i) => ForecastHourItem(hour: fd.hour[i]),
            ),
          ),
          24.verticalSpace,

          // ── 7-day forecast list ───────────────────────────
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Text('7-Day Forecast',
                style: theme.textTheme.displayMedium),
          ),
          12.verticalSpace,
          ...controller.weatherDetails.forecast.forecastday
              .map((dayFd) => _DayForecastRow(
                    fd: dayFd,
                    controller: controller,
                    isSelected: dayFd.date == controller.forecastday.date,
                  ))
              .toList(),
          24.verticalSpace,

          // ── Detail panel ──────────────────────────────────
          Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(20.w, 22.h, 20.w, 30.h),
            decoration: BoxDecoration(
              color: theme.canvasColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(28.r),
                topRight: Radius.circular(28.r),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(Strings.weatherNow.tr,
                    style: theme.textTheme.displayMedium),
                16.verticalSpace,

                // Wind + Pressure
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  child: Row(
                    children: [
                      WeatherDetailsItem(
                        title: Strings.wind.tr,
                        icon: Constants.wind,
                        value: controller.isKmh
                            ? controller
                                .weatherDetails.current.windKph
                                .toInt()
                                .toString()
                            : (controller.weatherDetails.current.windKph *
                                    0.621371)
                                .toInt()
                                .toString(),
                        text: controller.windUnitLabel,
                      ),
                      16.horizontalSpace,
                      WeatherDetailsItem(
                        title: Strings.pressure.tr,
                        icon: Constants.pressure,
                        value: controller.weatherDetails.current.pressureIn
                            .toInt()
                            .toString(),
                        text: 'inHg',
                        isHalfCircle: true,
                      ),
                    ],
                  ),
                ),
                24.verticalSpace,

                // Wind direction + sunrise + stats grid
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Left column
                    Expanded(
                      flex: 5,
                      child: Column(
                        children: [
                          // Wind direction
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 14),
                            decoration: BoxDecoration(
                              color: theme.cardColor,
                              borderRadius: BorderRadius.circular(18.r),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        controller.weatherDetails.current
                                            .windDir
                                            .getWindDir(),
                                        style: theme.textTheme.displaySmall
                                            ?.copyWith(fontSize: 12),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        controller.displayWindSpeed(
                                            fd.day.maxwindKph),
                                        style: theme.textTheme.displaySmall
                                            ?.copyWith(fontSize: 12),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                RotationTransition(
                                  turns: AlwaysStoppedAnimation(
                                      controller.weatherDetails.current
                                              .windDegree /
                                          360),
                                  child: Icon(Icons.north,
                                      size: 24,
                                      color: theme.iconTheme.color),
                                ),
                              ],
                            ),
                          ),
                          10.verticalSpace,

                          // Sunrise / sunset
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 14),
                            decoration: BoxDecoration(
                              color: theme.cardColor,
                              borderRadius: BorderRadius.circular(18.r),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SunRiseSetItem(
                                  text: Strings.sunrise.tr,
                                  value: fd.astro.sunrise.formatTime(),
                                ),
                                6.verticalSpace,
                                SunRiseSetItem(
                                  text: Strings.sunset.tr,
                                  value: fd.astro.sunset.formatTime(),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    10.horizontalSpace,

                    // Right column — stats
                    Expanded(
                      flex: 6,
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(14, 12, 14, 8),
                        decoration: BoxDecoration(
                          color: theme.cardColor,
                          borderRadius: BorderRadius.circular(18.r),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            WeatherRowData(
                              text: Strings.humidity.tr,
                              value: '${fd.day.avghumidity.toInt()}%',
                            ),
                            5.verticalSpace,
                            WeatherRowData(
                              text: Strings.realFeel.tr,
                              value: controller
                                  .displayTemp(fd.day.avgtempC.toDouble()),
                            ),
                            5.verticalSpace,
                            WeatherRowData(
                              text: Strings.uv.tr,
                              value: '${fd.day.uv.toInt()}',
                            ),
                            5.verticalSpace,
                            WeatherRowData(
                              text: Strings.chanceOfRain.tr,
                              value: '${fd.day.dailyChanceOfRain}%',
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Single weather card (replaces carousel) ──────────────────
class _WeatherCard extends StatelessWidget {
  final WeatherController controller;
  final Forecastday fd;
  const _WeatherCard({required this.controller, required this.fd});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 24.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.primaryColor,
            theme.primaryColor.withOpacity(0.78),
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Left: temp + condition
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  controller.displayTempLarge(
                      fd.day.maxtempC.toDouble()),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 58.sp,
                    fontWeight: FontWeight.w700,
                    height: 1,
                  ),
                ),
                8.verticalSpace,
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.20),
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Text(
                    fd.day.condition.text,
                    style: TextStyle(
                        color: Colors.white, fontSize: 12.sp),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                14.verticalSpace,
                Row(
                  children: [
                    _TempPill('H', controller.displayTemp(
                        fd.day.maxtempC.toDouble())),
                    10.horizontalSpace,
                    _TempPill('L', controller.displayTemp(
                        fd.day.mintempC.toDouble())),
                  ],
                ),
              ],
            ),
          ),
          // Right: weather icon
          CustomCachedImage(
            imageUrl:
                fd.day.condition.icon.toHighRes().addHttpPrefix(),
            fit: BoxFit.contain,
            width: 100.w,
            height: 100.h,
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}

class _TempPill extends StatelessWidget {
  final String label;
  final String value;
  const _TempPill(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('$label: ',
            style: TextStyle(color: Colors.white60, fontSize: 12.sp)),
        Text(value,
            style: TextStyle(
                color: Colors.white,
                fontSize: 12.sp,
                fontWeight: FontWeight.w600)),
      ],
    );
  }
}

// ── 7-day forecast row ────────────────────────────────────────
class _DayForecastRow extends StatelessWidget {
  final Forecastday fd;
  final WeatherController controller;
  final bool isSelected;
  const _DayForecastRow(
      {required this.fd,
      required this.controller,
      required this.isSelected});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final dayLabel = fd.date.convertToDay();

    return GestureDetector(
      onTap: () => controller.selectForecastDay(fd),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: EdgeInsets.fromLTRB(20.w, 0, 20.w, 8.h),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.primaryColor.withOpacity(0.12)
              : theme.cardColor,
          borderRadius: BorderRadius.circular(18.r),
          border: isSelected
              ? Border.all(
                  color: theme.primaryColor.withOpacity(0.4), width: 1.2)
              : null,
        ),
        child: Row(
          children: [
            // Day name
            SizedBox(
              width: 72.w,
              child: Text(
                dayLabel,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight:
                      isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected ? theme.primaryColor : null,
                ),
              ),
            ),
            // Weather icon
            CustomCachedImage(
              imageUrl:
                  fd.day.condition.icon.toHighRes().addHttpPrefix(),
              width: 32.w,
              height: 32.h,
              fit: BoxFit.contain,
            ),
            const Spacer(),
            // Rain chance
            if (fd.day.dailyChanceOfRain > 0) ...[
              Icon(Icons.water_drop_outlined,
                  size: 13.sp, color: Colors.blueAccent),
              3.horizontalSpace,
              Text(
                '${fd.day.dailyChanceOfRain}%',
                style: TextStyle(
                    fontSize: 11.sp, color: Colors.blueAccent),
              ),
              10.horizontalSpace,
            ],
            // High temp
            Text(
              controller.displayTemp(fd.day.maxtempC.toDouble()),
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: 14.sp,
              ),
            ),
            6.horizontalSpace,
            // Low temp
            Text(
              controller.displayTemp(fd.day.mintempC.toDouble()),
              style: theme.textTheme.bodyMedium?.copyWith(fontSize: 13.sp),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Shared helper widgets ─────────────────────────────────────

class _TopBarBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _TopBarBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    return Material(
      color: theme.primaryColor.withOpacity(0.10),
      borderRadius: BorderRadius.circular(13.r),
      child: InkWell(
        borderRadius: BorderRadius.circular(13.r),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(9.r),
          child: Icon(icon, color: theme.primaryColor, size: 20.sp),
        ),
      ),
    );
  }
}

class _LoadingView extends StatelessWidget {
  final ThemeData theme;
  const _LoadingView({required this.theme});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: theme.primaryColor, strokeWidth: 3),
          20.verticalSpace,
          Text('Fetching weather...', style: theme.textTheme.bodyMedium),
        ],
      ),
    );
  }
}

class _SettingToggleRow extends StatelessWidget {
  final String labelOn;
  final String labelOff;
  final bool isOn;
  final IconData icon;
  final VoidCallback onTap;

  const _SettingToggleRow({
    required this.labelOn,
    required this.labelOff,
    required this.isOn,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: theme.canvasColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Icon(icon, color: theme.primaryColor, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(isOn ? labelOn : labelOff,
                  style: theme.textTheme.displaySmall),
            ),
            // Fixed-size toggle switch — no ScreenUtil units
            SizedBox(
              width: 44,
              height: 26,
              child: GestureDetector(
                onTap: onTap,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  decoration: BoxDecoration(
                    color: isOn ? theme.primaryColor : theme.dividerColor,
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: AnimatedAlign(
                    duration: const Duration(milliseconds: 200),
                    alignment:
                        isOn ? Alignment.centerRight : Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(3),
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: const BoxDecoration(
                            color: Colors.white, shape: BoxShape.circle),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}