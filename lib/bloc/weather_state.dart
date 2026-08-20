// TODO Implement this library.import 'package:equatable/equatable.dart';
import 'package:equatable/equatable.dart';
import '../models/weather_model.dart';

enum WeatherStatus { initial, loading, success, failure }
enum TemperatureUnit { celsius, fahrenheit }

class WeatherState extends Equatable {
  final WeatherStatus status;
  final WeatherModel? weather;
  final String selectedCity;
  final TemperatureUnit temperatureUnit;
  final String language;
  final String? errorMessage;

  const WeatherState({
    this.status = WeatherStatus.initial,
    this.weather,
    this.selectedCity = 'Riyadh',
    this.temperatureUnit = TemperatureUnit.celsius,
    this.language = 'ar',
    this.errorMessage,
  });

  const WeatherState.initial() : this();

  WeatherState copyWith({
    WeatherStatus? status,
    WeatherModel? weather,
    String? selectedCity,
    TemperatureUnit? temperatureUnit,
    String? language,
    String? errorMessage,
  }) {
    return WeatherState(
      status: status ?? this.status,
      weather: weather ?? this.weather,
      selectedCity: selectedCity ?? this.selectedCity,
      temperatureUnit: temperatureUnit ?? this.temperatureUnit,
      language: language ?? this.language,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        weather,
        selectedCity,
        temperatureUnit,
        language,
        errorMessage,
      ];
}