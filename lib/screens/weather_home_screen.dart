import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/weather_bloc.dart';
import '../bloc/weather_state.dart';
import '../bloc/weather_event.dart';
import '../widgets/weather_canvas_animator.dart';
import '../widgets/hourly_forecast_card.dart';
import "../widgets/daily_forecast_list.dart";
import '../widgets/weather_details_grid.dart';
import '../widgets/aqi_gauge_card.dart';

class WeatherHomeScreen extends StatelessWidget {
  const WeatherHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WeatherBloc, WeatherState>(
      builder: (context, state) {
        if (state.status == WeatherStatus.loading && state.weather == null) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(color: Color(0xFF38BDF8)),
            ),
          );
        }

        final weather = state.weather;
        if (weather == null) {
          return Scaffold(
            body: Center(
              child: Text(
                state.errorMessage ?? 'لا توجد بيانات متاحة',
                style: const TextStyle(color: Colors.white),
              ),
            ),
          );
        }

        final isArabic = state.language == 'ar';
        final isCelsius = state.temperatureUnit == TemperatureUnit.celsius;
        final currentTemp = isCelsius ? '${weather.tempC.round()}°' : '${weather.tempF.round()}°';

        return Scaffold(
          body: Stack(
            children: [
              // 1. خلفية السماء ورسوم الطقس المتحركة (CustomPainter)
              Positioned.fill(
                child: WeatherCanvasAnimator(condition: weather.condition),
              ),

              // 2. المحتوى القابل للتمرير
              SafeArea(
                child: RefreshIndicator(
                  onRefresh: () async {
                    context.read<WeatherBloc>().add(const RefreshCurrentWeatherEvent());
                  },
                  child: CustomScrollView(
                    physics: const BouncingScrollPhysics(),
                    slivers: [
                      // شريط التطبيق العلوي مع اسم المدينة والتحكم
                      SliverAppBar(
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        floating: true,
                        leading: IconButton(
                          icon: const Icon(Icons.location_on_outlined, color: Colors.white),
                          onPressed: () {
                            context.read<WeatherBloc>().add(const FetchWeatherByGpsEvent());
                          },
                        ),
                        title: Column(
                          children: [
                            Text(
                              isArabic ? weather.cityNameAr : weather.cityNameEn,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              isArabic ? weather.countryAr : weather.countryEn,
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.white.withValues(alpha: 0.7),
                              ),
                            ),
                          ],
                        ),
                        actions: [
                          IconButton(
                            icon: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                isCelsius ? '°C' : '°F',
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            onPressed: () {
                              context.read<WeatherBloc>().add(const ToggleTemperatureUnitEvent());
                            },
                          ),
                        ],
                      ),

                      // البطاقة الرئيسية لدرجة الحرارة وحالة الطقس
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 24),
                          child: Column(
                            children: [
                              Text(
                                currentTemp,
                                style: const TextStyle(
                                  fontSize: 84,
                                  fontWeight: FontWeight.w200,
                                  color: Colors.white,
                                  letterSpacing: -2,
                                ),
                              ),
                              Text(
                                isArabic ? weather.descriptionAr : weather.descriptionEn,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white70,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'ع: ${isCelsius ? weather.tempMaxC.round() : weather.tempMaxF.round()}°',
                                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                                  ),
                                  const SizedBox(width: 16),
                                  Text(
                                    'ص: ${isCelsius ? weather.tempMinC.round() : weather.tempMinF.round()}°',
                                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),

                      // شريط التوقعات الساعية (Hourly Carousel)
                      SliverToBoxAdapter(
                        child: HourlyForecastCard(hourly: weather.hourly, isCelsius: isCelsius),
                      ),

                      const SliverToBoxAdapter(child: SizedBox(height: 16)),

                      // قائمة توقعات الـ 7 أيام القادمة (Daily Forecast)
                      SliverToBoxAdapter(
                        child: DailyForecastList(daily: weather.daily, isCelsius: isCelsius),
                      ),

                      const SliverToBoxAdapter(child: SizedBox(height: 16)),

                      // مؤشر جودة الهواء (AQI Card)
                      SliverToBoxAdapter(
                        child: AqiGaugeCard(aqi: weather.aqi),
                      ),

                      const SliverToBoxAdapter(child: SizedBox(height: 16)),

                      // شبكة تفاصيل الطقس (الرطوبة، الرياح، الضغط، الأشعة فوق البنفسجية)
                      SliverToBoxAdapter(
                        child: WeatherDetailsGrid(weather: weather, isCelsius: isCelsius),
                      ),

                      const SliverToBoxAdapter(child: SizedBox(height: 32)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}