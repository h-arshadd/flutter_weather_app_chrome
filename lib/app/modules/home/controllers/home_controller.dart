import 'package:get/get.dart';

import '../../../../config/theme/my_theme.dart';
import '../../../../config/translations/localization_service.dart';
import '../../../../utils/constants.dart';
import '../../../data/local/my_shared_pref.dart';
import '../../../data/models/weather_model.dart';
import '../../../routes/app_pages.dart';
import '../../../services/api_call_status.dart';
import '../../../services/base_client.dart';
import '../../../services/location_service.dart';
import '../views/widgets/location_dialog.dart';

class HomeController extends GetxController {
  static HomeController get instance => Get.find();

  // get the current language code
  var currentLanguage = LocalizationService.getCurrentLocal().languageCode;

  // hold current weather data
  late WeatherModel currentWeather;

  // for update
  final dotIndicatorsId = 'DotIndicators';
  final themeId = 'Theme';
  final unitId = 'Unit';

  // api call status
  ApiCallStatus apiCallStatus = ApiCallStatus.loading;

  // for app theme
  var isLightTheme = MySharedPref.getThemeIsLight();

  // temperature unit: true = Celsius, false = Fahrenheit
  var isCelsius = MySharedPref.getTempUnitIsCelsius();

  // wind speed unit: true = km/h, false = mph
  var isKmh = MySharedPref.getWindUnitIsKmh();

  @override
  void onInit() async {
    if (!await LocationService().hasLocationPermission()) {
      Get.dialog(const LocationDialog());
    } else {
      getUserLocation();
    }
    super.onInit();
  }

  /// get the user location and navigate directly to weather detail
  getUserLocation() async {
    apiCallStatus = ApiCallStatus.loading;
    update();
    var locationData = await LocationService().getUserLocation();
    if (locationData != null) {
      final coords = '${locationData.latitude},${locationData.longitude}';
      await getCurrentWeather(coords);
    }
  }

  /// get current weather then navigate directly to WeatherView
  getCurrentWeather(String location) async {
    await BaseClient.safeApiCall(
      Constants.currentWeatherApiUrl,
      RequestType.get,
      queryParameters: {
        Constants.key: Constants.apiKey,
        Constants.q: location,
        Constants.lang: currentLanguage,
      },
      onSuccess: (response) async {
        currentWeather = WeatherModel.fromJson(response.data);
        apiCallStatus = ApiCallStatus.success;
        update();
        // Navigate directly to full weather detail screen
        Get.offNamed(
          Routes.WEATHER,
          arguments: location,
        );
      },
      onError: (error) {
        BaseClient.handleApiError(error);
        apiCallStatus = ApiCallStatus.error;
        update();
      },
    );
  }

  /// when the user presses on change theme icon
  onChangeThemePressed() {
    MyTheme.changeTheme();
    isLightTheme = MySharedPref.getThemeIsLight();
    update([themeId]);
  }

  /// when the user presses on change language icon
  onChangeLanguagePressed() async {
    currentLanguage = currentLanguage == 'ur' ? 'en' : 'ur';
    await LocalizationService.updateLanguage(currentLanguage);
    await getUserLocation();
  }

  /// toggle temperature unit between Celsius and Fahrenheit
  onChangeTempUnit() async {
    isCelsius = !isCelsius;
    await MySharedPref.setTempUnitCelsius(isCelsius);
    update([unitId]);
  }

  /// toggle wind speed unit between km/h and mph
  onChangeWindUnit() async {
    isKmh = !isKmh;
    await MySharedPref.setWindUnitKmh(isKmh);
    update([unitId]);
  }

  /// get display temperature based on unit
  String getDisplayTemp(double tempC) {
    if (isCelsius) {
      return '${tempC.round()}°C';
    } else {
      return '${((tempC * 9 / 5) + 32).round()}°F';
    }
  }

  /// get display wind speed based on unit
  String getDisplayWindSpeed(double windKph) {
    if (isKmh) {
      return '${windKph.toInt()} km/h';
    } else {
      return '${(windKph * 0.621371).toInt()} mph';
    }
  }
}