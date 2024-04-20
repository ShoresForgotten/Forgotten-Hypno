import 'dart:ui';

import 'package:flutter/cupertino.dart';

enum ShaderEnum {
  //todo: find some way to automate this (code generation?)
  spiral(
    name: 'Spiral',
    assetPath: 'shaders/spiral.frag',
    colors: [
      ColorUniform(
        name: 'Color One',
        address: 3,
        defaultColor: Color(0xFFFFFFFF),
        size: ColorSize(address: 9, defaultSize: 1.0),
      ),
      ColorUniform(
        name: 'Color Two',
        address: 6,
        defaultColor: Color(0xFF000000),
        size: ColorSize(address: 10, defaultSize: 1.0),
      )
    ], // alpha will be ignored, but i'm leaving it at FF for future proofing
    uniforms: [
      FloatUniform(
        name: 'Arms',
        min: 1.0,
        max: null,
        init: 10.0,
        address: 11,
        isInt: true,
      ),
      FloatUniform(
        name: 'Zoom',
        min: null,
        max: null,
        init: 0.5,
        address: 12,
        isInt: false,
      ),
      FloatUniform(
        name: 'Speed',
        min: null,
        max: null,
        init: 1.0,
        address: 13,
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
          name: 'Color One',
          address: 3,
          defaultColor: Color(0xFFFFFFFF),
          size: ColorSize(address: 9, defaultSize: 1.0)),
      ColorUniform(
          name: 'Color Two',
          address: 6,
          defaultColor: Color(0xFF000000),
          size: ColorSize(address: 10, defaultSize: 1.0)),
    ],
    uniforms: [
      FloatUniform(
        name: 'Zoom',
        address: 11,
        min: 0.0,
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
            name: 'Color One',
            address: 3,
            defaultColor: Color(0xFF000000),
            size: ColorSize(address: 15, defaultSize: 1.0)),
        ColorUniform(
            name: 'Color Two',
            address: 6,
            defaultColor: Color(0xFF76A420),
            size: ColorSize(address: 16, defaultSize: 1.0)),
        ColorUniform(
            name: 'Color Three',
            address: 9,
            defaultColor: Color(0xFF04BAAD),
            size: ColorSize(address: 17, defaultSize: 1.0)),
        ColorUniform(
            name: 'Color Four',
            address: 12,
            defaultColor: Color(0xFF669BE1),
            size: ColorSize(address: 18, defaultSize: 1.0)),
      ],
      uniforms: [
        FloatUniform(
          name: 'Zoom',
          address: 19,
          min: 1.0,
          max: null,
          init: 3.0,
          isInt: false,
        ),
        FloatUniform(
          name: 'Speed',
          address: 20,
          min: null,
          max: null,
          init: -0.1,
          isInt: false,
        ),
      ],
      debugOnly: false),

  sixColorRings(
      name: 'Six Color Rings',
      assetPath: 'shaders/6ring.frag',
      colors: [
        ColorUniform(
            name: 'Color One',
            address: 3,
            defaultColor: Color(0xFF000000),
            size: ColorSize(address: 21, defaultSize: 20.0)),
        ColorUniform(
            name: 'Color Two',
            address: 6,
            defaultColor: Color(0xFF76A420),
            size: ColorSize(address: 22, defaultSize: 20.0)),
        ColorUniform(
            name: 'Color Three',
            address: 9,
            defaultColor: Color(0xFF000000),
            size: ColorSize(address: 23, defaultSize: 1.0)),
        ColorUniform(
            name: 'Color Four',
            address: 12,
            defaultColor: Color(0xFF669BE1),
            size: ColorSize(address: 24, defaultSize: 20.0)),
        ColorUniform(
            name: 'Color Five',
            address: 15,
            defaultColor: Color(0xFF000000),
            size: ColorSize(address: 25, defaultSize: 1.0)),
        ColorUniform(
            name: 'Color Six',
            address: 18,
            defaultColor: Color(0xFF04BAAD),
            size: ColorSize(address: 26, defaultSize: 20.0)),
      ],
      uniforms: [
        FloatUniform(
          name: 'Zoom',
          address: 27,
          min: 1.0,
          max: null,
          init: 1.0,
          isInt: false,
        ),
        FloatUniform(
          name: 'Speed',
          address: 28,
          min: null,
          max: null,
          init: -0.1,
          isInt: false,
        ),
      ],
      debugOnly: false),

  radialFade(
    name: 'Radial Fade',
    assetPath: 'shaders/radial_fade.frag',
    colors: [
      ColorUniform(name: 'Color One', address: 3, defaultColor: Color(0xFFFF00FF)),
      ColorUniform(name: 'Color Two', address: 6, defaultColor: Color(0xFF000000))
    ],
    uniforms: [],
    debugOnly: false
  ),

  testShader(
    name: 'Test Shader',
    assetPath: 'shaders/test.frag',
    colors: [
      ColorUniform(name: 'Color', address: 3, defaultColor: Color(0xFFFF00FF))
    ],
    uniforms: [
      FloatUniform(
        name: 'Dingus',
        address: 6,
        min: null,
        max: null,
        init: 1.0,
        isInt: false,
      )
    ],
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
  final ColorSize? size;

  const ColorUniform(
      {required this.name,
      required this.address,
      required this.defaultColor,
      this.size});
}

class ColorSize {
  final int address;
  final double defaultSize;
  const ColorSize({required this.address, required this.defaultSize});
}
