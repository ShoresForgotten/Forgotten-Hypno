import 'dart:ui';

import 'package:flutter/cupertino.dart';

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
        max: null,
        init: 10.0,
        address: 9,
        isInt: true,
      ),
      FloatUniform(
        name: 'Zoom',
        min: null,
        max: null,
        init: 0.5,
        address: 10,
        isInt: false,
      ),
      FloatUniform(
        name: 'Speed',
        min: null,
        max: null,
        init: 1.0,
        address: 11,
        isInt: false,
      ),
    ],
    debugOnly: false,
  ),

  twoColorRings(
    name: 'Two Color Rings',
    assetPath: 'shaders/2ring.frag',
    colors: [
      ColorUniform(
          name: 'Color One', address: 3, defaultColor: Color(0xFFFFFFFF)),
      ColorUniform(
          name: 'Color Two', address: 6, defaultColor: Color(0xFF000000)),
    ],
    uniforms: [
      FloatUniform(
        name: 'Size Color One',
        address: 9,
        min: 0.0,
        max: null,
        init: 1.0,
        isInt: false,
      ),
      FloatUniform(
        name: 'Size Color Two',
        address: 10,
        min: 0.0,
        max: null,
        init: 1.0,
        isInt: false,
      ),
      FloatUniform(
          name: 'Zoom',
          address: 11,
          min: 1.0,
          max: null,
          init: 5.0,
          isInt: false,
      ),
      FloatUniform(
        name: 'Speed',
        address: 12,
        min: null,
        max: null,
        init: 0.1,
        isInt: false,
      )
    ],
    debugOnly: false,
  ),

  fourColorRings(
    name: 'Four Color Rings',
    assetPath: 'shaders/4ring.frag',
    colors: [
      ColorUniform(
        name: 'Color One', address: 3, defaultColor: Color(0xFF000000)),
      ColorUniform(
          name: 'Color Two', address: 6, defaultColor: Color(0xFF76A420)),
      ColorUniform(
          name: 'Color Three', address: 9, defaultColor: Color(0xFF04BAAD)),
      ColorUniform(
          name: 'Color Four', address: 12, defaultColor: Color(0xFF669BE1)),
    ],
  uniforms: [
    FloatUniform(
      name: 'Zoom',
      address: 15,
      min: 1.0,
      max: null,
      init: 3.0,
      isInt: false,
    ),
    FloatUniform(
      name: 'Speed',
      address: 16,
      min: null,
      max: null,
      init: 0.1,
      isInt: false,
    ),
  ],
  debugOnly: false
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
  final double? min;
  final double? max;
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
