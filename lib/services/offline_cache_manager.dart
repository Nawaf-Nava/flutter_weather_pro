import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/weather_model.dart';

class OfflineCacheManager {
  static const String _boxName = 'weather_offline_box';
  static late Box<String> _cacheBox;

  static Future<void> initialize() async {
    await Hive.initFlutter();
    _cacheBox = await Hive.openBox<String>(_boxName);
  }

  /// حفظ بيانات الطقس محلياً مع طابع زمني
  static Future<void> cacheCityWeather(WeatherModel city) async {
    final payload = {
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'data': city.props, // أو التخزين المباشر حسب طريقة التعامل مع الحقول
    };
    await _cacheBox.put(city.cityId, jsonEncode(payload));
  }

  /// جلب الطقس المخزن محلياً لمدينة معينة
  static WeatherModel? getCachedWeather(String cityId) {
    final rawJson = _cacheBox.get(cityId);
    if (rawJson == null) return null;

    try {
      final decoded = jsonDecode(rawJson) as Map<String, dynamic>;
      final cityMap = decoded['data'] as Map<String, dynamic>;
      return WeatherModel.fromJson(cityMap);
    } catch (e) {
      return null;
    }
  }

  /// تفريغ الذاكرة المؤقتة
  static Future<void> clearAllCache() async {
    await _cacheBox.clear();
  }
}