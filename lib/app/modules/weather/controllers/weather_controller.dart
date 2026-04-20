import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../components/custom_loading_overlay.dart';
import '../../../../utils/extensions.dart';
import '../../../../config/theme/my_theme.dart';
import '../../../../config/translations/localization_service.dart';
import '../../../../config/translations/strings_enum.dart';
import '../../../../utils/constants.dart';
import '../../../data/local/my_shared_pref.dart';
import '../../../data/models/weather_details_model.dart';
import '../../../services/api_call_status.dart';
import '../../../services/base_client.dart';
import '../../../services/location_service.dart';

class WeatherController extends GetxController {
  static WeatherController get instance => Get.find();

  // current language code
  var currentLanguage = LocalizationService.getCurrentLocal().languageCode;

  // weather data
  late WeatherDetailsModel weatherDetails;

  // The currently-selected forecast day (always today on fresh load)
  late Forecastday forecastday;

  // fetch 7 days from API
  final days = 7;

  // api call status
  ApiCallStatus apiCallStatus = ApiCallStatus.holding;

  // unit preferences
  bool isCelsius = MySharedPref.getTempUnitIsCelsius();
  bool isKmh = MySharedPref.getWindUnitIsKmh();

  // theme
  bool isLightTheme = MySharedPref.getThemeIsLight();

  // whether showing device GPS location or a searched city
  bool isCurrentLocation = true;

  // the coords/name string used for the current load (kept for language refresh)
  String _currentQuery = '';

  bool get isEnLang => currentLanguage == 'en';

  @override
  void onReady() {
    if (Get.arguments != null) {
      _currentQuery = Get.arguments as String;
      isCurrentLocation = true;
      getWeatherDetails();
    }
    super.onReady();
  }

  // ---- Data loading ----

  /// Load weather using [_currentQuery].
  getWeatherDetails() async {
    await showLoadingOverLay(
      asyncFunction: () async => await BaseClient.safeApiCall(
        Constants.forecastWeatherApiUrl,
        RequestType.get,
        queryParameters: {
          Constants.key: Constants.apiKey,
          Constants.q: _currentQuery,
          Constants.days: days,
          Constants.lang: currentLanguage,
        },
        onSuccess: (response) {
          weatherDetails = WeatherDetailsModel.fromJson(response.data);
          forecastday = weatherDetails.forecast.forecastday[0];
          apiCallStatus = ApiCallStatus.success;
          update();
        },
        onError: (error) {
          BaseClient.handleApiError(error);
          apiCallStatus = ApiCallStatus.error;
          update();
        },
      ),
    );
  }

  /// Search any city by name — no PageController, crash-safe.
  searchAndLoadLocation(String cityName) async {
    isCurrentLocation = false;
    _currentQuery = cityName;
    apiCallStatus = ApiCallStatus.holding;
    update();

    await showLoadingOverLay(
      asyncFunction: () async => await BaseClient.safeApiCall(
        Constants.forecastWeatherApiUrl,
        RequestType.get,
        queryParameters: {
          Constants.key: Constants.apiKey,
          Constants.q: cityName,
          Constants.days: days,
          Constants.lang: currentLanguage,
        },
        onSuccess: (response) {
          weatherDetails = WeatherDetailsModel.fromJson(response.data);
          forecastday = weatherDetails.forecast.forecastday[0];
          apiCallStatus = ApiCallStatus.success;
          update();
        },
        onError: (error) {
          BaseClient.handleApiError(error);
          Get.snackbar(
            'Location not found',
            'Could not find weather for "$cityName". Check the spelling.',
            snackPosition: SnackPosition.BOTTOM,
            margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            borderRadius: 16,
            duration: const Duration(seconds: 3),
          );
          apiCallStatus = ApiCallStatus.error;
          update();
        },
      ),
    );
  }

  /// Go back to GPS location.
  reloadCurrentLocation() async {
    isCurrentLocation = true;
    var locationData = await LocationService().getUserLocation();
    if (locationData != null) {
      _currentQuery = '${locationData.latitude},${locationData.longitude}';
      apiCallStatus = ApiCallStatus.holding;
      update();
      await getWeatherDetails();
    }
  }

  /// User taps a day row in the 7-day list.
  selectForecastDay(Forecastday fd) {
    forecastday = fd;
    update();
  }

  // ---- Settings ----

  onChangeThemePressed() {
    MyTheme.changeTheme();
    isLightTheme = MySharedPref.getThemeIsLight();
    update();
  }

  onChangeLanguagePressed() async {
    currentLanguage = currentLanguage == 'ur' ? 'en' : 'ur';
    await LocalizationService.updateLanguage(currentLanguage);
    update();
    await getWeatherDetails();
  }

  onChangeTempUnit() async {
    isCelsius = !isCelsius;
    await MySharedPref.setTempUnitCelsius(isCelsius);
    update();
  }

  onChangeWindUnit() async {
    isKmh = !isKmh;
    await MySharedPref.setWindUnitKmh(isKmh);
    update();
  }

  // ---- Unit helpers ----

  String displayTemp(double tempC) {
    if (isCelsius) return '${tempC.round()}°C';
    return '${((tempC * 9 / 5) + 32).round()}°F';
  }

  String displayTempLarge(double tempC) => displayTemp(tempC);

  String displayWindSpeed(double windKph) {
    if (isKmh) return '${windKph.toInt()} km/h';
    return '${(windKph * 0.621371).toInt()} mph';
  }

  String get windUnitLabel => isKmh ? 'km/h' : 'mph';
  String get tempUnitLabel => isCelsius ? '°C' : '°F';
}