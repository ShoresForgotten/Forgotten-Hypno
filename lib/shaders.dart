import 'dart:ui';

enum ShaderEnum {
  spiral(
    name: 'Spiral',
    assetPath: 'shaders/spiral.frag',
    colors: [
      ColorUniform(
        name: 'Color 1',
        address: 3,
        defaultColor: Color(0xFFFFFFFF),
      ),
      ColorUniform(
        name: 'Color 2',
        address: 6,
        defaultColor: Color(0xFF000000),
      )
    ], // alpha will be ignored, but i'm leaving it at FF for future proofing
    uniforms: [
      FloatUniform(
        name: 'Arms',
        min: 1.0,
        max: 100.0,
        init: 10.0,
        address: 9,
        isInt: true,
      ),
      FloatUniform(
        name: 'Angle',
        min: 0.0,
        max: 100.0,
        init: 5.0,
        address: 10,
        isInt: false,
      ),
      FloatUniform(
        name: 'Speed',
        min: -1.0,
        max: 1.0,
        init: 0.05,
        address: 11,
        isInt: false,
      ),
    ],
    debugOnly: false,
  ),

  testShader(
    name: 'Test Shader',
    assetPath: 'shaders/test.frag',
    colors: [
      ColorUniform(name: 'Color', address: 3, defaultColor: Color(0xFFFF00FF))
    ],
    uniforms: [],
    debugOnly: true,
  );

  const ShaderEnum({
    required this.name,
    required this.assetPath,
    required this.uniforms,
    required this.colors,
    required this.debugOnly,
  });

  final String name;
  final String assetPath;
  final List<ColorUniform> colors;
  final List<FloatUniform> uniforms;
  final bool debugOnly;
}

class FloatUniform {
  final String name;
  final int address;
  final double min;
  final double max;
  final double init;
  final bool isInt;

  const FloatUniform({
    required this.name,
    required this.address,
    required this.min,
    required this.max,
    required this.init,
    required this.isInt,
  });
}

class ColorUniform {
  final String name;
  final int address;
  final Color defaultColor;

  const ColorUniform(
      {required this.name, required this.address, required this.defaultColor});
}
