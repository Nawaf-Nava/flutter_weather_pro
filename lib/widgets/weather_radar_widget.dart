import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../models/weather_model.dart';
import '../services/haptic_service.dart';

class WeatherRadarWidget extends StatefulWidget {
  final WeatherModel currentCity;
  final bool isArabic;

  const WeatherRadarWidget({
    super.key,
    required this.currentCity,
    required this.isArabic,
  });

  @override
  State<WeatherRadarWidget> createState() => _WeatherRadarWidgetState();
}

class _WeatherRadarWidgetState extends State<WeatherRadarWidget> with SingleTickerProviderStateMixin {
  double _zoomLevel = 1.0;
  Offset _offset = Offset.zero;
  bool _isSatellite = false;
  late AnimationController _radarController;

  @override
  void initState() {
    super.initState();
    _radarController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _radarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white10),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // 1. Radar Map Layer (Provinces & Grid)
          GestureDetector(
            onScaleUpdate: (details) {
              setState(() {
                _zoomLevel = (_zoomLevel * details.scale).clamp(0.5, 4.0);
                _offset += details.focalPointDelta;
              });
            },
            child: Transform.scale(
              scale: _zoomLevel,
              child: Transform.translate(
                offset: _offset,
                child: CustomPaint(
                  painter: RadarMapPainter(
                    isSatellite: _isSatellite,
                    sweepAngle: _radarController.value * 2 * math.pi,
                  ),
                  size: Size.infinite,
                ),
              ),
            ),
          ),

          // 2. Control Buttons
          Positioned(
            top: 16,
            right: 16,
            child: Column(
              children: [
                _buildControlButton(
                  icon: Icons.layers_outlined,
                  onPressed: () {
                    HapticService.trigger();
                    setState(() => _isSatellite = !_isSatellite);
                  },
                ),
                const SizedBox(height: 8),
                _buildControlButton(
                  icon: Icons.add,
                  onPressed: () => setState(() => _zoomLevel += 0.2),
                ),
                _buildControlButton(
                  icon: Icons.remove,
                  onPressed: () => setState(() => _zoomLevel -= 0.2),
                ),
              ],
            ),
          ),

          // 3. Status Badge (تم التعديل بفك خاصية backdropFilter الخاطئة من BoxDecoration)
          Positioned(
            top: 16,
            left: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.54),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.radar, size: 14, color: Colors.blue),
                  const SizedBox(width: 6),
                  Text(
                    widget.isArabic ? 'رادار مباشر' : 'Live Radar',
                    style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton({required IconData icon, required VoidCallback onPressed}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.black45,
        borderRadius: BorderRadius.circular(12),
      ),
      child: IconButton(
        icon: Icon(icon, size: 20, color: Colors.white70),
        onPressed: onPressed,
      ),
    );
  }
}

class RadarMapPainter extends CustomPainter {
  final bool isSatellite;
  final double sweepAngle;

  RadarMapPainter({required this.isSatellite, required this.sweepAngle});

  @override
  void paint(Canvas canvas, Size size) {
    final paintGrid = Paint()
      ..color = Colors.blue.withValues(alpha: 0.05)
      ..style = PaintingStyle.stroke;

    // Draw Grid
    for (double i = 0; i < size.width; i += 60) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paintGrid);
    }
    for (double i = 0; i < size.height; i += 60) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paintGrid);
    }

    // Detailed Yemen Border (Simplified for Dart but more accurate than before)
    final paintBorder = Paint()
      ..color = Colors.blue.withValues(alpha: 0.4)
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    final borderPath = Path()
      ..moveTo(size.width * 0.3, size.height * 0.25)
      ..lineTo(size.width * 0.7, size.height * 0.2)
      ..lineTo(size.width * 0.85, size.height * 0.5)
      ..lineTo(size.width * 0.75, size.height * 0.8)
      ..lineTo(size.width * 0.4, size.height * 0.85)
      ..lineTo(size.width * 0.15, size.height * 0.6)
      ..close();
    
    canvas.drawPath(borderPath, paintBorder);

    // Draw Major Provinces Outlines
    final paintProv = Paint()
      ..color = Colors.blue.withValues(alpha: 0.1)
      ..strokeWidth = 0.8
      ..style = PaintingStyle.stroke;

    canvas.drawRect(Rect.fromLTWH(size.width * 0.35, size.height * 0.35, 40, 40), paintProv);
    canvas.drawRect(Rect.fromLTWH(size.width * 0.6, size.height * 0.4, 60, 50), paintProv);

    // Draw Radar Sweep
    final sweepPaint = Paint()
      ..shader = SweepGradient(
        colors: [Colors.blue.withValues(alpha: 0.3), Colors.transparent],
        stops: const [0.1, 0.4],
        transform: GradientRotation(sweepAngle),
      ).createShader(Rect.fromCenter(center: Offset(size.width / 2, size.height * 0.45), width: 400, height: 400));
    
    canvas.drawCircle(Offset(size.width / 2, size.height * 0.45), 200, sweepPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}