import 'dart:ui' as ui;

import 'package:flutter/material.dart';

/// すりガラス風のコンテナ。
class GlassContainer extends StatelessWidget {
  const GlassContainer({
    super.key,
    required this.child,
    this.color = Colors.white,
    this.radius = 12,
    this.padding,
    this.width,
    this.height,
  });

  final Widget child;
  final Color color;
  final double radius;
  final EdgeInsetsGeometry? padding;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: ShapeDecoration(
        shadows: radius > 0
            ? const [
                BoxShadow(
                  color: Colors.black12,
                  offset: Offset(0, 0),
                  blurRadius: 15,
                  blurStyle: BlurStyle.outer,
                )
              ]
            : null,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(radius)),
        ),
      ),
      width: width,
      height: height,
      child: ClipRect(
        child: BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: CustomPaint(
            painter: radius > 0
                ? _GradientPainter(
                    strokeWidth: 1,
                    radius: radius,
                    gradient: RadialGradient(
                      radius: 1.6,
                      center: Alignment.topLeft,
                      colors: [
                        color.withOpacity(0.5),
                        color.withOpacity(0.1),
                      ],
                    ),
                  )
                : null,
            child: Container(
              alignment: Alignment.center,
              width: width,
              height: height,
              padding: padding,
              decoration: ShapeDecoration(
                gradient: RadialGradient(
                  radius: 1.6,
                  center: Alignment.topLeft,
                  colors: [
                    color.withOpacity(0.3),
                    color.withOpacity(0.1),
                  ],
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(radius)),
                ),
              ),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}

class _GradientPainter extends CustomPainter {
  _GradientPainter({
    required this.strokeWidth,
    required this.radius,
    required this.gradient,
  });

  final Paint _paint = Paint();
  final double radius;
  final double strokeWidth;
  final Gradient gradient;

  @override
  void paint(Canvas canvas, Size size) {
    final outerRect = Offset.zero & size;
    final outerRRect =
        RRect.fromRectAndRadius(outerRect, Radius.circular(radius));

    final innerRect = Rect.fromLTWH(
      strokeWidth,
      strokeWidth,
      size.width - strokeWidth * 2,
      size.height - strokeWidth * 2,
    );
    final innerRadius = (radius - strokeWidth).clamp(0.0, double.infinity);
    final innerRRect =
        RRect.fromRectAndRadius(innerRect, Radius.circular(innerRadius));

    _paint.shader = gradient.createShader(outerRect);

    final path1 = Path()..addRRect(outerRRect);
    final path2 = Path()..addRRect(innerRRect);
    final path = Path.combine(PathOperation.difference, path1, path2);
    canvas.drawPath(path, _paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
