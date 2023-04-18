import 'dart:ui';
import 'shader_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

// https://medium.com/flutter-community/flutter-widgets-with-shaders-94e6e9a9640d
/// StatefulWidget just to hold the pointer to the fragment shader
class ShaderWidget extends StatefulWidget {
  /// The active FragmentShader
  final ShaderWrapper _shader;
  const ShaderWidget(this._shader, {super.key});
  @override
  State<ShaderWidget> createState() => _ShaderWidgetState();
}

class _ShaderWidgetState extends State<ShaderWidget> {
  Duration _previous = Duration.zero;

  late final Ticker _ticker;
  double dt = 0;

  @override
  void initState() {
    super.initState();
    _ticker = Ticker(_tick);
    _ticker.start();
  }

  @override
  void dispose() {
    _ticker.stop();
    _ticker.dispose();
    super.dispose();
  }

  void _tick(Duration timestamp) {
    final durationDelta = timestamp - _previous;
    _previous = timestamp;
    setState(() {
      dt += durationDelta.inMicroseconds / Duration.microsecondsPerSecond;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return CustomPaint(
      painter: _ShaderPainter(
          dt, widget._shader.shader), //extra shader because wrapper
      size: size,
    );
  }
}

class _ShaderPainter extends CustomPainter {
  double iTime;
  FragmentShader shader;

  _ShaderPainter(this.iTime, this.shader);
  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Offset.zero & size;
    shader
      ..setFloat(0, size.width)
      ..setFloat(1, size.height)
      ..setFloat(2, iTime);
    canvas.drawRect(
      rect,
      Paint()..shader = shader,
    );
  }

  @override
  shouldRepaint(_ShaderPainter oldDelegate) => true;
}
