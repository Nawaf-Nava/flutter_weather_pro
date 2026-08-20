// ==========================================
//  تطبيق الطقس المتكامل بلغة دارت و فلاتر
//  Flutter & Dart Production Weather App
// ==========================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';

import 'bloc/weather_bloc.dart';
import 'bloc/weather_event.dart';
import 'bloc/weather_state.dart';
import 'screens/weather_home_screen.dart'; 
import 'services/weather_api_service.dart';
import 'services/location_service.dart';
import 'services/offline_cache_manager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await OfflineCacheManager.initialize();

  // ضبط شريط الحالة ليكون شفافاً متناسقاً مع خلفية الطقس
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  runApp(const DartWeatherApplication());
}

class DartWeatherApplication extends StatelessWidget {
  const DartWeatherApplication({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (_) => LocationService()),
        RepositoryProvider(create: (_) => WeatherApiService()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => WeatherBloc(
              apiService: context.read<WeatherApiService>(),
              locationService: context.read<LocationService>(),
            )..add(const FetchWeatherForDefaultCityEvent(cityName: 'الرياض')),
          ),
        ],
        child: BlocBuilder<WeatherBloc, WeatherState>(
          builder: (context, state) {
            return MaterialApp(
              title: 'طقس دارت | Dart Weather',
              debugShowCheckedModeBanner: false,
              locale: Locale(state.language),
              supportedLocales: const [
                Locale('ar', 'SA'),
                Locale('en', 'US'),
              ],
              localizationsDelegates: const [
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              theme: ThemeData(
                useMaterial3: true,
                brightness: Brightness.dark,
                colorSchemeSeed: const Color(0xFF38BDF8), // Sky Blue Accent
                scaffoldBackgroundColor: const Color(0xFF0F172A),
                textTheme: GoogleFonts.cairoTextTheme(
                  ThemeData.dark().textTheme,
                ),
              ),
              home: const WeatherHomeScreen(),
            );
          },
        ),
      ),
    );
  }
}