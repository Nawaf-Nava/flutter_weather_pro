import 'package:equatable/equatable.dart';

enum WeatherCondition {
  sunny,
  clearNight,
  partlyCloudy,
  cloudy,
  rain,
  heavyRain,
  thunderstorm,
  snow,
  fog,
  windy,
}

class WeatherModel extends Equatable {
  final String cityId;
  final String cityNameAr;
  final String cityNameEn;
  final String countryAr;
  final String countryEn;
  final double tempC;
  final double feelsLikeC;
  final double tempMinC;
  final double tempMaxC;
  final WeatherCondition condition;
  final String descriptionAr;
  final String descriptionEn;
  final int humidity;
  final double windSpeedKmh;
  final int windDirectionDeg;
  final double pressureHpa;
  final int uvIndex;
  final double visibilityKm;
  final int aqi;
  final String sunrise;
  final String sunset;
  final List<HourlyForecastModel> hourly;
  final List<DailyForecastModel> daily;

  const WeatherModel({
    required this.cityId,
    required this.cityNameAr,
    required this.cityNameEn,
    required this.countryAr,
    required this.countryEn,
    required this.tempC,
    required this.feelsLikeC,
    required this.tempMinC,
    required this.tempMaxC,
    required this.condition,
    required this.descriptionAr,
    required this.descriptionEn,
    required this.humidity,
    required this.windSpeedKmh,
    required this.windDirectionDeg,
    required this.pressureHpa,
    required this.uvIndex,
    required this.visibilityKm,
    required this.aqi,
    required this.sunrise,
    required this.sunset,
    required this.hourly,
    required this.daily,
  });

  double get tempF => (tempC * 9 / 5) + 32;
  double get feelsLikeF => (feelsLikeC * 9 / 5) + 32;
  double get tempMinF => (tempMinC * 9 / 5) + 32;
  double get tempMaxF => (tempMaxC * 9 / 5) + 32;

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      cityId: json['id'] ?? '',
      cityNameAr: json['nameAr'] ?? '',
      cityNameEn: json['nameEn'] ?? '',
      countryAr: json['countryAr'] ?? '',
      countryEn: json['countryEn'] ?? '',
      tempC: (json['tempC'] as num).toDouble(),
      feelsLikeC: (json['details']['feelsLikeC'] as num).toDouble(),
      tempMinC: (json['tempMinC'] as num).toDouble(),
      tempMaxC: (json['tempMaxC'] as num).toDouble(),
      condition: _parseCondition(json['condition']),
      descriptionAr: json['descriptionAr'] ?? '',
      descriptionEn: json['descriptionEn'] ?? '',
      humidity: (json['details']['humidity'] as num).toInt(),
      windSpeedKmh: (json['details']['windSpeedKmh'] as num).toDouble(),
      windDirectionDeg: (json['details']['windDirectionDeg'] as num).toInt(),
      pressureHpa: (json['details']['pressureHpa'] as num).toDouble(),
      uvIndex: (json['details']['uvIndex'] as num).toInt(),
      visibilityKm: (json['details']['visibilityKm'] as num).toDouble(),
      aqi: (json['details']['aqiData']['aqi'] as num).toInt(),
      sunrise: json['details']['sunrise'] ?? '',
      sunset: json['details']['sunset'] ?? '',
      hourly: (json['hourly'] as List)
          .map((item) => HourlyForecastModel.fromJson(item))
          .toList(),
      daily: (json['daily'] as List)
          .map((item) => DailyForecastModel.fromJson(item))
          .toList(),
    );
  }

  static WeatherCondition _parseCondition(String? conditionStr) {
    switch (conditionStr) {
      case 'sunny':
        return WeatherCondition.sunny;
      case 'clear_night':
        return WeatherCondition.clearNight;
      case 'partly_cloudy':
        return WeatherCondition.partlyCloudy;
      case 'cloudy':
        return WeatherCondition.cloudy;
      case 'rain':
        return WeatherCondition.rain;
      case 'heavy_rain':
        return WeatherCondition.heavyRain;
      case 'thunderstorm':
        return WeatherCondition.thunderstorm;
      case 'snow':
        return WeatherCondition.snow;
      case 'fog':
        return WeatherCondition.fog;
      case 'windy':
        return WeatherCondition.windy;
      default:
        return WeatherCondition.sunny;
    }
  }

  @override
  List<Object?> get props => [cityId, tempC, condition, hourly, daily];
}

class HourlyForecastModel extends Equatable {
  final String time;
  final int hour;
  final double tempC;
  final WeatherCondition condition;
  final int pop; // Probability of precipitation
  final double windSpeedKmh;

  const HourlyForecastModel({
    required this.time,
    required this.hour,
    required this.tempC,
    required this.condition,
    required this.pop,
    required this.windSpeedKmh,
  });

  factory HourlyForecastModel.fromJson(Map<String, dynamic> json) {
    return HourlyForecastModel(
      time: json['time'] ?? '',
      hour: json['hour'] ?? 0,
      tempC: (json['tempC'] as num).toDouble(),
      condition: WeatherModel._parseCondition(json['condition']),
      pop: (json['pop'] as num).toInt(),
      windSpeedKmh: (json['windSpeedKmh'] as num).toDouble(),
    );
  }

  @override
  List<Object?> get props => [time, hour, tempC, condition, pop];
}

class DailyForecastModel extends Equatable {
  final String date;
  final String dayNameAr;
  final String dayNameEn;
  final double tempMaxC;
  final double tempMinC;
  final WeatherCondition condition;
  final int pop;
  final String summaryAr;
  final String summaryEn;

  const DailyForecastModel({
    required this.date,
    required this.dayNameAr,
    required this.dayNameEn,
    required this.tempMaxC,
    required this.tempMinC,
    required this.condition,
    required this.pop,
    required this.summaryAr,
    required this.summaryEn,
  });

  factory DailyForecastModel.fromJson(Map<String, dynamic> json) {
    return DailyForecastModel(
      date: json['date'] ?? '',
      dayNameAr: json['dayNameAr'] ?? '',
      dayNameEn: json['dayNameEn'] ?? '',
      tempMaxC: (json['tempMaxC'] as num).toDouble(),
      tempMinC: (json['tempMinC'] as num).toDouble(),
      condition: WeatherModel._parseCondition(json['condition']),
      pop: (json['pop'] as num).toInt(),
      summaryAr: json['summaryAr'] ?? '',
      summaryEn: json['summaryEn'] ?? '',
    );
  }

  @override
  List<Object?> get props => [date, tempMaxC, tempMinC, condition];
}