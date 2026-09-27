import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';

class PulseRadarWidget extends StatefulWidget {
  final double size;
  final Widget? centerChild;
  final Color pulseColor;
  final int rings;

  const PulseRadarWidget({
    super.key,
    this.size = 240,
    this.centerChild,
    this.pulseColor = AppColors.primary,
    this.rings = 3,
  });

  @override
  State<PulseRadarWidget> createState() => _PulseRadarWidgetState();
}

class _PulseRadarWidgetState extends State<PulseRadarWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return CustomPaint(
                size: Size(widget.size, widget.size),
                painter: _RadarWavePainter(
                  progress: _controller.value,
                  color: widget.pulseColor,
                  rings: widget.rings,
                ),
              );
            },
          ),
          if (widget.centerChild != null) widget.centerChild!,
        ],
      ),
    );
  }
}

class _RadarWavePainter extends CustomPainter {
  final double progress;
  final Color color;
  final int rings;

  _RadarWavePainter({
    required this.progress,
    required this.color,
    required this.rings,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = math.min(size.width, size.height) / 2;

    for (int i = 0; i < rings; i++) {
      final ringProgress = (progress + (i / rings)) % 1.0;
      final radius = ringProgress * maxRadius;
      final opacity = (1.0 - ringProgress).clamp(0.0, 1.0);

      final paintFill = Paint()
        ..color = color.withValues(alpha: opacity * 0.14)
        ..style = PaintingStyle.fill;

      final paintStroke = Paint()
        ..color = color.withValues(alpha: opacity * 0.45)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5;

      canvas.drawCircle(center, radius, paintFill);
      canvas.drawCircle(center, radius, paintStroke);
    }
  }

  @override
  bool shouldRepaint(covariant _RadarWavePainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.color != color ||
        oldDelegate.rings != rings;
  }
}
