import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../services/weather_api_service.dart';
import '../services/location_service.dart';
import 'weather_event.dart';
import 'weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final WeatherApiService apiService;
  final LocationService locationService;
  Timer? _autoRefreshTimer;

  WeatherBloc({
    required this.apiService,
    required this.locationService,
  }) : super(const WeatherState.initial()) {
    on<FetchWeatherForDefaultCityEvent>(_onFetchWeatherForCity);
    on<FetchWeatherByGpsEvent>(_onFetchWeatherByGps);
    on<SearchCityWeatherEvent>(_onSearchCity);
    on<ToggleTemperatureUnitEvent>(_onToggleUnit);
    on<ChangeLanguageEvent>(_onChangeLanguage);
    on<RefreshCurrentWeatherEvent>(_onRefresh);

    _autoRefreshTimer = Timer.periodic(
      const Duration(minutes: 15),
      (_) => add(const RefreshCurrentWeatherEvent()),
    );
  }

  Future<void> _onFetchWeatherForCity(
    FetchWeatherForDefaultCityEvent event,
    Emitter<WeatherState> emit,
  ) async {
    emit(state.copyWith(status: WeatherStatus.loading));
    try {
      final weather = await apiService.getCityWeather(event.cityName);
      emit(state.copyWith(
        status: WeatherStatus.success,
        weather: weather,
        selectedCity: event.cityName,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: WeatherStatus.failure,
        errorMessage: 'تعذر جلب بيانات الطقس: ${e.toString()}',
      ));
    }
  }

  Future<void> _onFetchWeatherByGps(
    FetchWeatherByGpsEvent event,
    Emitter<WeatherState> emit,
  ) async {
    emit(state.copyWith(status: WeatherStatus.loading));
    try {
      final position = await locationService.getCurrentPosition();
      final weather = await apiService.getWeatherByCoordinates(
        lat: position.latitude,
        lon: position.longitude, lng: position.longitude, // استخدام lon هنا بدلاً من lng
      );
      emit(state.copyWith(
        status: WeatherStatus.success,
        weather: weather,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: WeatherStatus.failure,
        errorMessage: 'تعذر تحديد موقع GPS الحالي',
      ));
    }
  }

  Future<void> _onSearchCity(
    SearchCityWeatherEvent event,
    Emitter<WeatherState> emit,
  ) async {
    emit(state.copyWith(status: WeatherStatus.loading));
    try {
      final weather = await apiService.getCityWeather(event.query);
      emit(state.copyWith(
        status: WeatherStatus.success,
        weather: weather,
        selectedCity: event.query,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: WeatherStatus.failure,
        errorMessage: 'المدينة المطلوبة غير موجودة',
      ));
    }
  }

  void _onToggleUnit(
    ToggleTemperatureUnitEvent event,
    Emitter<WeatherState> emit,
  ) {
    final nextUnit = state.temperatureUnit == TemperatureUnit.celsius
        ? TemperatureUnit.fahrenheit
        : TemperatureUnit.celsius;
    emit(state.copyWith(temperatureUnit: nextUnit));
  }

  void _onChangeLanguage(
    ChangeLanguageEvent event,
    Emitter<WeatherState> emit,
  ) {
    emit(state.copyWith(language: event.languageCode));
  }

  Future<void> _onRefresh(
    RefreshCurrentWeatherEvent event,
    Emitter<WeatherState> emit,
  ) async {
    if (state.weather == null) return;
    try {
      final refreshed = await apiService.getCityWeather(state.selectedCity);
      emit(state.copyWith(weather: refreshed));
    } catch (_) {}
  }

  @override
  Future<void> close() {
    _autoRefreshTimer?.cancel();
    return super.close();
  }
}