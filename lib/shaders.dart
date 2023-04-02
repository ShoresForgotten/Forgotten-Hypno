enum ShaderEnum {
  logSpiral(
      name: 'Logarithmic Spiral',
      assetPath: 'shaders/log_spiral.frag',
      colors: 2,
      uniforms: [
        FloatUniform(
          name: 'Arms',
          min: 1.0,
          max: 100.0,
          init: 5.0,
          address: 7,
          isInt: true,
        ),
        FloatUniform(
          name: 'Angle',
          min: 0.0,
          max: 100.0,
          init: 5.0,
          address: 8,
          isInt: false,
        ),
        FloatUniform(
          name: 'Zoom',
          min: 0.0,
          max: 100.0,
          init: 5.0,
          address: 9,
          isInt: false,
        ),
      ]),

  testShader(
      name: 'Test Shader',
      assetPath: 'shaders/test.frag',
      colors: 1,
      uniforms: []);

  const ShaderEnum({
    required this.name,
    required this.assetPath,
    required this.uniforms,
    required this.colors,
  });

  final String name;
  final String assetPath;
  final int colors;
  final List<FloatUniform> uniforms;
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
