import 'package:home_widget/home_widget.dart';
import '../models/weather_model.dart';

class HomeWidgetService {
  static const String androidWidgetName = 'WeatherAppWidgetProvider';
  static const String iOSWidgetName = 'WeatherWidgetEntryView';

  /// مزامنة أحدث بيانات الطقس مع ودجت الشاشة الرئيسية
  static Future<void> updateHomeScreenWidget(WeatherModel city) async {
    try {
      await HomeWidget.saveWidgetData<String>('city_name', city.cityNameAr);
      await HomeWidget.saveWidgetData<String>('temp_c', '${city.tempC.round()}°');
      await HomeWidget.saveWidgetData<String>('temp_max_min', 'H:${city.tempMaxC.round()}° L:${city.tempMinC.round()}°');
      await HomeWidget.saveWidgetData<String>('condition_text', city.descriptionAr);
      await HomeWidget.saveWidgetData<String>('condition_code', city.condition.name);
      await HomeWidget.saveWidgetData<int>('rain_pop', city.hourly.isNotEmpty ? city.hourly.first.pop : 0);
      await HomeWidget.saveWidgetData<String>('last_updated', DateTime.now().toIso8601String());

      // إشعار نظام التشغيل لإعادة رسم الودجت فورياً
      await HomeWidget.updateWidget(
        name: androidWidgetName,
        iOSName: iOSWidgetName,
      );
    } catch (e) {
      // التعامل مع أخطاء مزامنة النظام
    }
  }
}