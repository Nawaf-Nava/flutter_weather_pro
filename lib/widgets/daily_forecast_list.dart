import 'package:flutter/material.dart';
import '../models/weather_model.dart';

class DailyForecastList extends StatelessWidget {
  final List<DailyForecastModel> daily;
  final bool isCelsius;

  const DailyForecastList({
    super.key,
    required this.daily,
    required this.isCelsius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: daily.map((item) {
          final maxTemp = isCelsius ? '${item.tempMaxC.round()}°' : '${((item.tempMaxC * 9 / 5) + 32).round()}°';
          final minTemp = isCelsius ? '${item.tempMinC.round()}°' : '${((item.tempMinC * 9 / 5) + 32).round()}°';
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(item.dayNameAr, style: const TextStyle(color: Colors.white, fontSize: 16)),
                Row(
                  children: [
                    Text(maxTemp, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    const SizedBox(width: 12),
                    Text(minTemp, style: const TextStyle(color: Colors.white70)),
                  ],
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}