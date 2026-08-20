import 'package:flutter/material.dart';
import '../models/weather_model.dart';

class HourlyForecastCard extends StatelessWidget {
  final List<HourlyForecastModel> hourly;
  final bool isCelsius;

  const HourlyForecastCard({
    super.key,
    required this.hourly,
    required this.isCelsius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: hourly.length,
        itemBuilder: (context, index) {
          final item = hourly[index];
          final temp = isCelsius ? '${item.tempC.round()}°' : '${((item.tempC * 9 / 5) + 32).round()}°';
          return Container(
            width: 70,
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(item.time, style: const TextStyle(color: Colors.white70, fontSize: 12)),
                const SizedBox(height: 8),
                Text(temp, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ],
            ),
          );
        },
      ),
    );
  }
}