import 'package:http/http.dart' as http;
import '../models/weather_model.dart';

class WeatherApiService {
  static const String _baseUrl = 'https://api.weatherapi.com/v1';
  static const String _apiKey = 'DEMO_WEATHER_API_KEY';

  final http.Client _client;

  WeatherApiService({http.Client? client}) : _client = client ?? http.Client();

  Future<WeatherModel> getCityWeather(String cityName) async {
    try {
      // في الإنتاج يتم استدعاء الرابط الفعلي
      // final response = await _client.get(Uri.parse('$_baseUrl/forecast.json?key=$_apiKey&q=$cityName&days=7'));
      
      // هنا نرجع بيانات متكاملة محاكية مع معالجة الأخطاء
      await Future.delayed(const Duration(milliseconds: 400));
      return _generateSampleWeatherData(cityName);
    } catch (e) {
      throw Exception('فشل في جلب بيانات الطقس لمدينة: $cityName');
    }
  }

  Future<WeatherModel> getWeatherByCoordinates({
    required double lat,
    required double lng, required double lon,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _generateSampleWeatherData('الموقع الحالي');
  }

  WeatherModel _generateSampleWeatherData(String name) {
    // إرجاع نموذج أولي مكتمل للتجربة والتطوير
    return WeatherModel(
      cityId: name.toLowerCase(),
      cityNameAr: name,
      cityNameEn: name,
      countryAr: 'المملكة العربية السعودية',
      countryEn: 'Saudi Arabia',
      tempC: 34.0,
      feelsLikeC: 35.0,
      tempMinC: 24.0,
      tempMaxC: 38.0,
      condition: WeatherCondition.sunny,
      descriptionAr: 'أجواء صيفية صافية ودافئة',
      descriptionEn: 'Clear sunny sky with warm breeze',
      humidity: 15,
      windSpeedKmh: 18.0,
      windDirectionDeg: 120,
      pressureHpa: 1012.0,
      uvIndex: 9,
      visibilityKm: 10.0,
      aqi: 2,
      sunrise: '05:38 ص',
      sunset: '06:24 م',
      hourly: const [],
      daily: const [],
    );
  }
}