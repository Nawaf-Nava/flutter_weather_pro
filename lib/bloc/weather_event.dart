import 'package:equatable/equatable.dart';

abstract class WeatherEvent extends Equatable {
  const WeatherEvent();

  @override
  List<Object?> get props => [];
}

class FetchWeatherForDefaultCityEvent extends WeatherEvent {
  final String cityName;

  const FetchWeatherForDefaultCityEvent({this.cityName = 'Riyadh'});

  @override
  List<Object?> get props => [cityName];
}

class FetchWeatherByGpsEvent extends WeatherEvent {
  const FetchWeatherByGpsEvent();
}

class SearchCityWeatherEvent extends WeatherEvent {
  final String query;

  const SearchCityWeatherEvent(this.query);

  @override
  List<Object?> get props => [query];
}

class ToggleTemperatureUnitEvent extends WeatherEvent {
  const ToggleTemperatureUnitEvent();
}

class ChangeLanguageEvent extends WeatherEvent {
  final String languageCode;

  const ChangeLanguageEvent(this.languageCode);

  @override
  List<Object?> get props => [languageCode];
}

class RefreshCurrentWeatherEvent extends WeatherEvent {
  const RefreshCurrentWeatherEvent();
}