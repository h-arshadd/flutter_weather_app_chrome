import 'condition_model.dart';
import 'current_model.dart';
import 'location_model.dart';

class WeatherDetailsModel {
  Location location;
  Current current;
  Forecast forecast;

  WeatherDetailsModel({
    required this.location,
    required this.current,
    required this.forecast,
  });

  factory WeatherDetailsModel.fromJson(Map<String, dynamic> json) => WeatherDetailsModel(
    location: Location.fromJson(json['location']),
    current: Current.fromJson(json['current']),
    forecast: Forecast.fromJson(json['forecast']),
  );

  Map<String, dynamic> toJson() => {
    'location': location.toJson(),
    'current': current.toJson(),
    'forecast': forecast.toJson(),
  };
}

class Forecast {
  List<Forecastday> forecastday;

  Forecast({required this.forecastday});

  factory Forecast.fromJson(Map<String, dynamic> json) => Forecast(
    forecastday: List<Forecastday>.from(json['forecastday'].map((x) => Forecastday.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    'forecastday': List<dynamic>.from(forecastday.map((x) => x.toJson())),
  };
}

class Forecastday {
  DateTime date;
  num dateEpoch;
  Day day;
  Astro astro;
  List<Hour> hour;

  Forecastday({
    required this.date,
    required this.dateEpoch,
    required this.day,
    required this.astro,
    required this.hour,
  });

  factory Forecastday.fromJson(Map<String, dynamic> json) => Forecastday(
    date: DateTime.parse(json['date']),
    dateEpoch: json['date_epoch'],
    day: Day.fromJson(json['day']),
    astro: Astro.fromJson(json['astro']),
    hour: List<Hour>.from(json['hour'].map((x) => Hour.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    'date': '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}',
    'date_epoch': dateEpoch,
    'day': day.toJson(),
    'astro': astro.toJson(),
    'hour': List<dynamic>.from(hour.map((x) => x.toJson())),
  };
}

class Astro {
  String sunrise;
  String sunset;
  String moonrise;
  String moonset;
  String moonPhase;
  String moonIllumination;
  num isMoonUp;
  num isSunUp;

  Astro({
    required this.sunrise,
    required this.sunset,
    required this.moonrise,
    required this.moonset,
    required this.moonPhase,
    required this.moonIllumination,
    required this.isMoonUp,
    required this.isSunUp,
  });

  factory Astro.fromJson(Map<String, dynamic> json) => Astro(
    sunrise: json['sunrise'].toString(),
    sunset: json['sunset'].toString(),
    moonrise: json['moonrise'].toString(),
    moonset: json['moonset'].toString(),
    moonPhase: json['moon_phase'].toString(),
    moonIllumination: json['moon_illumination'].toString(), // ← THE CRASH FIX
    isMoonUp: json['is_moon_up'],
    isSunUp: json['is_sun_up'],
  );

  Map<String, dynamic> toJson() => {
    'sunrise': sunrise,
    'sunset': sunset,
    'moonrise': moonrise,
    'moonset': moonset,
    'moon_phase': moonPhase,
    'moon_illumination': moonIllumination,
    'is_moon_up': isMoonUp,
    'is_sun_up': isSunUp,
  };
}

class Day {
  double maxtempC;
  double maxtempF;
  double mintempC;
  double mintempF;
  double avgtempC;
  double avgtempF;
  double maxwindMph;
  double maxwindKph;
  double totalprecipMm;
  double totalprecipIn;
  double totalsnowCm;
  double avgvisKm;
  double avgvisMiles;
  int avghumidity;
  int dailyWillItRain;
  int dailyChanceOfRain;
  int dailyWillItSnow;
  int dailyChanceOfSnow;
  Condition condition;
  double uv;

  Day({
    required this.maxtempC,
    required this.maxtempF,
    required this.mintempC,
    required this.mintempF,
    required this.avgtempC,
    required this.avgtempF,
    required this.maxwindMph,
    required this.maxwindKph,
    required this.totalprecipMm,
    required this.totalprecipIn,
    required this.totalsnowCm,
    required this.avgvisKm,
    required this.avgvisMiles,
    required this.avghumidity,
    required this.dailyWillItRain,
    required this.dailyChanceOfRain,
    required this.dailyWillItSnow,
    required this.dailyChanceOfSnow,
    required this.condition,
    required this.uv,
  });

  factory Day.fromJson(Map<String, dynamic> json) => Day(
    maxtempC: (json['maxtemp_c'] as num).toDouble(),
    maxtempF: (json['maxtemp_f'] as num).toDouble(),
    mintempC: (json['mintemp_c'] as num).toDouble(),
    mintempF: (json['mintemp_f'] as num).toDouble(),
    avgtempC: (json['avgtemp_c'] as num).toDouble(),
    avgtempF: (json['avgtemp_f'] as num).toDouble(),
    maxwindMph: (json['maxwind_mph'] as num).toDouble(),
    maxwindKph: (json['maxwind_kph'] as num).toDouble(),
    totalprecipMm: (json['totalprecip_mm'] as num).toDouble(),
    totalprecipIn: (json['totalprecip_in'] as num).toDouble(),
    totalsnowCm: (json['totalsnow_cm'] as num).toDouble(),
    avgvisKm: (json['avgvis_km'] as num).toDouble(),
    avgvisMiles: (json['avgvis_miles'] as num).toDouble(),
    avghumidity: (json['avghumidity'] as num).toInt(),
    dailyWillItRain: (json['daily_will_it_rain'] as num).toInt(),
    dailyChanceOfRain: (json['daily_chance_of_rain'] as num).toInt(),
    dailyWillItSnow: (json['daily_will_it_snow'] as num).toInt(),
    dailyChanceOfSnow: (json['daily_chance_of_snow'] as num).toInt(),
    condition: Condition.fromJson(json['condition']),
    uv: (json['uv'] as num).toDouble(),
  );

  Map<String, dynamic> toJson() => {
    'maxtemp_c': maxtempC,
    'maxtemp_f': maxtempF,
    'mintemp_c': mintempC,
    'mintemp_f': mintempF,
    'avgtemp_c': avgtempC,
    'avgtemp_f': avgtempF,
    'maxwind_mph': maxwindMph,
    'maxwind_kph': maxwindKph,
    'totalprecip_mm': totalprecipMm,
    'totalprecip_in': totalprecipIn,
    'totalsnow_cm': totalsnowCm,
    'avgvis_km': avgvisKm,
    'avgvis_miles': avgvisMiles,
    'avghumidity': avghumidity,
    'daily_will_it_rain': dailyWillItRain,
    'daily_chance_of_rain': dailyChanceOfRain,
    'daily_will_it_snow': dailyWillItSnow,
    'daily_chance_of_snow': dailyChanceOfSnow,
    'condition': condition.toJson(),
    'uv': uv,
  };
}

class Hour {
  int timeEpoch;
  String time;
  double tempC;
  double tempF;
  int isDay;
  Condition condition;
  double windMph;
  double windKph;
  int windDegree;
  String windDir;
  double pressureMb;
  double pressureIn;
  double precipMm;
  double precipIn;
  int humidity;
  int cloud;
  double feelslikeC;
  double feelslikeF;
  double windchillC;
  double windchillF;
  double heatindexC;
  double heatindexF;
  double dewpointC;
  double dewpointF;
  int willItRain;
  int chanceOfRain;
  int willItSnow;
  int chanceOfSnow;
  double visKm;
  double visMiles;
  double gustMph;
  double gustKph;
  double uv;

  Hour({
    required this.timeEpoch,
    required this.time,
    required this.tempC,
    required this.tempF,
    required this.isDay,
    required this.condition,
    required this.windMph,
    required this.windKph,
    required this.windDegree,
    required this.windDir,
    required this.pressureMb,
    required this.pressureIn,
    required this.precipMm,
    required this.precipIn,
    required this.humidity,
    required this.cloud,
    required this.feelslikeC,
    required this.feelslikeF,
    required this.windchillC,
    required this.windchillF,
    required this.heatindexC,
    required this.heatindexF,
    required this.dewpointC,
    required this.dewpointF,
    required this.willItRain,
    required this.chanceOfRain,
    required this.willItSnow,
    required this.chanceOfSnow,
    required this.visKm,
    required this.visMiles,
    required this.gustMph,
    required this.gustKph,
    required this.uv,
  });

  factory Hour.fromJson(Map<String, dynamic> json) => Hour(
    timeEpoch: (json['time_epoch'] as num).toInt(),
    time: json['time'].toString(),
    tempC: (json['temp_c'] as num).toDouble(),
    tempF: (json['temp_f'] as num).toDouble(),
    isDay: (json['is_day'] as num).toInt(),
    condition: Condition.fromJson(json['condition']),
    windMph: (json['wind_mph'] as num).toDouble(),
    windKph: (json['wind_kph'] as num).toDouble(),
    windDegree: (json['wind_degree'] as num).toInt(),
    windDir: json['wind_dir'].toString(),
    pressureMb: (json['pressure_mb'] as num).toDouble(),
    pressureIn: (json['pressure_in'] as num).toDouble(),
    precipMm: (json['precip_mm'] as num).toDouble(),
    precipIn: (json['precip_in'] as num).toDouble(),
    humidity: (json['humidity'] as num).toInt(),
    cloud: (json['cloud'] as num).toInt(),
    feelslikeC: (json['feelslike_c'] as num).toDouble(),
    feelslikeF: (json['feelslike_f'] as num).toDouble(),
    windchillC: (json['windchill_c'] as num).toDouble(),
    windchillF: (json['windchill_f'] as num).toDouble(),
    heatindexC: (json['heatindex_c'] as num).toDouble(),
    heatindexF: (json['heatindex_f'] as num).toDouble(),
    dewpointC: (json['dewpoint_c'] as num).toDouble(),
    dewpointF: (json['dewpoint_f'] as num).toDouble(),
    willItRain: (json['will_it_rain'] as num).toInt(),
    chanceOfRain: (json['chance_of_rain'] as num).toInt(),
    willItSnow: (json['will_it_snow'] as num).toInt(),
    chanceOfSnow: (json['chance_of_snow'] as num).toInt(),
    visKm: (json['vis_km'] as num).toDouble(),
    visMiles: (json['vis_miles'] as num).toDouble(),
    gustMph: (json['gust_mph'] as num).toDouble(),
    gustKph: (json['gust_kph'] as num).toDouble(),
    uv: (json['uv'] as num).toDouble(),
  );

  Map<String, dynamic> toJson() => {
    'time_epoch': timeEpoch,
    'time': time,
    'temp_c': tempC,
    'temp_f': tempF,
    'is_day': isDay,
    'condition': condition.toJson(),
    'wind_mph': windMph,
    'wind_kph': windKph,
    'wind_degree': windDegree,
    'wind_dir': windDir,
    'pressure_mb': pressureMb,
    'pressure_in': pressureIn,
    'precip_mm': precipMm,
    'precip_in': precipIn,
    'humidity': humidity,
    'cloud': cloud,
    'feelslike_c': feelslikeC,
    'feelslike_f': feelslikeF,
    'windchill_c': windchillC,
    'windchill_f': windchillF,
    'heatindex_c': heatindexC,
    'heatindex_f': heatindexF,
    'dewpoint_c': dewpointC,
    'dewpoint_f': dewpointF,
    'will_it_rain': willItRain,
    'chance_of_rain': chanceOfRain,
    'will_it_snow': willItSnow,
    'chance_of_snow': chanceOfSnow,
    'vis_km': visKm,
    'vis_miles': visMiles,
    'gust_mph': gustMph,
    'gust_kph': gustKph,
    'uv': uv,
  };
}