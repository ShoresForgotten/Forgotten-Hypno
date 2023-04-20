import 'package:flutter_test/flutter_test.dart';
import 'package:forgotten_hypno/shader_state.dart';
import 'package:forgotten_hypno/shaders.dart';

void main() {
  group('Shader State object tests', () {
    const typeOne = ShaderEnum.testShader;
    const typeTwo = ShaderEnum.spiral;
    late ShaderState state;

    setUp(() async {
      state = await ShaderState.createState(typeOne);
    });

    test('Initial state creation', () async {
      expect(state.type, typeOne);
      for (var color in typeOne.colors) {
        expect(state.shader.getColor3(color.address), color.defaultColor);
        var size = color.size;
        if (size != null) {
          expect(state.shader.getFloat(size.address), size.defaultSize);
        }
      }
      for (var uniform in typeOne.uniforms) {
        expect(state.shader.getFloat(uniform.address), uniform.init);
      }
    });

    test('Changing state', () async {
      await state.setType(typeTwo);
      expect(state.type, typeTwo);
      for (var color in typeTwo.colors) {
        expect(state.shader.getColor3(color.address), color.defaultColor);
        var size = color.size;
        if (size != null) {
          expect(state.shader.getFloat(size.address), size.defaultSize);
        }
      }
      for (var uniform in typeTwo.uniforms) {
        expect(state.shader.getFloat(uniform.address), uniform.init);
      }
    });
  });
}
