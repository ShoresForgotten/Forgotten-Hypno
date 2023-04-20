import 'dart:ui';

import 'package:forgotten_hypno/shader_wrapper.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Shader Wrapper', () {
    test('Set and retrieve float',() async {
      final program = await FragmentProgram.fromAsset('shaders/test.frag');
      final shader = program.fragmentShader();
      final wrapper = ShaderWrapper(shader);

      wrapper.setFloat(6, 2.0);
      expect(wrapper.getFloat(6), 2.0);
    });

    test('Set and retrieve color', () async {
      final program = await FragmentProgram.fromAsset('shaders/test.frag');
      final shader = program.fragmentShader();
      final wrapper = ShaderWrapper(shader);

      wrapper.setColor3(3, const Color(0xFFFF00FF));
      expect(wrapper.getColor3(3), const Color(0xFFFF00FF));
    });

    test('Retrieve shader object', () async {
      final program = await FragmentProgram.fromAsset('shaders/test.frag');
      final shader = program.fragmentShader();
      final wrapper = ShaderWrapper(shader);

      expect(wrapper.shader, shader);
    });
  });
}
