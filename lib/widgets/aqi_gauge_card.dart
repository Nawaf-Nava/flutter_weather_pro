import 'package:flutter/material.dart';

class AqiGaugeCard extends StatelessWidget {
  final int aqi;

  const AqiGaugeCard({
    super.key,
    required this.aqi,
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('جودة الهواء (AQI)', style: TextStyle(color: Colors.white, fontSize: 16)),
          Text('$aqi', style: const TextStyle(color: Colors.lightBlueAccent, fontWeight: FontWeight.bold, fontSize: 18)),
        ],
      ),
    );
  }
}