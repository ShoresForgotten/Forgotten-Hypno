import 'dart:ui';

import 'shader_provider.dart';
import 'package:flutter/material.dart';

class HypnoPaint extends StatelessWidget {
  const HypnoPaint({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: HypnoPainter(0.0, ShaderInherit.of(context).activeShader),
    );
  }
}
class HypnoPainter extends CustomPainter {
  double iTime;
  FragmentShader shader;

  HypnoPainter(this.iTime, this.shader);
  @override
  void paint(Canvas canvas, Size size) {
    shader
      ..setFloat(0, size.width)
      ..setFloat(1, size.height)
      ..setFloat(2, iTime);
    final paint = Paint()..shader = shader;
    canvas.drawRect(
      Rect.fromLTWH(
        0,
        0,
        size.width,
        size.height,
      ),
      paint,
    );
  }

  @override
  shouldRepaint(HypnoPainter oldDelegate) => true;
}
