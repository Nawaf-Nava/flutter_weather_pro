import 'package:flutter/material.dart';
import '../models/weather_model.dart';

class WeatherDetailsGrid extends StatelessWidget {
  final WeatherModel weather;
  final bool isCelsius;

  const WeatherDetailsGrid({
    super.key,
    required this.weather,
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
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        childAspectRatio: 2.5,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        children: [
          _buildDetailTile('الرطوبة', '${weather.humidity}%'),
          _buildDetailTile('الرياح', '${weather.windSpeedKmh} كم/س'),
          _buildDetailTile('الضغط', '${weather.pressureHpa} hPa'),
          _buildDetailTile('الأشعة UV', '${weather.uvIndex}'),
        ],
      ),
    );
  }

  Widget _buildDetailTile(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(title, style: const TextStyle(color: Colors.white70, fontSize: 12)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
      ],
    );
  }
}