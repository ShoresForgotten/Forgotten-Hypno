import 'package:flutter/material.dart';
import 'dart:ui';
import 'shaders.dart';
import 'shader_wrapper.dart';

//todo: look into providing a separate type provider for less rebuilds
class ShaderState with ChangeNotifier {
  late ShaderEnum type;
  late ShaderWrapper shader;

  late final Map<ShaderEnum, ShaderWrapper> _shaderCache;
  // not sure if a program cache is needed but putting it here just in case
  late final Map<ShaderEnum, FragmentProgram> _programCache;

  static Future<ShaderState> createState(ShaderEnum type) async {
    var state = ShaderState();
    state.type = type;
    var program = await FragmentProgram.fromAsset(type.assetPath);
    state._programCache = {type: program};
    var shader = ShaderWrapper(program.fragmentShader());
    state._shaderCache = {type: shader};
    state.shader = shader;

    _setDefaultColors(shader, type);
    _setDefaultUniforms(shader, type);

    return state;
  }

  Future<void> compileShader(ShaderEnum type) async {
    // if shader is already compiled, don't
    // otherwise compile

    // is this check needed? lets find out what happens if we don't

    var program = await FragmentProgram.fromAsset(type.assetPath);
    _programCache[type] = program;
    var shader = ShaderWrapper(program.fragmentShader());
    _shaderCache[type] = shader;
    _setDefaultColors(shader, type);
    _setDefaultUniforms(shader, type);
  }

  void changeShader(ShaderEnum type) async {
    if (_shaderCache[type] == null) {
      await compileShader(type);
    }
    this.type = type;
    shader = _shaderCache[type]!;
    notifyListeners();
  }

  static void _setDefaultColors(ShaderWrapper shader, ShaderEnum type) {
    int offset = 3; // first 3 uniforms are always size (xy) and time
    for (var color in type.colors) {
      shader.setColor3(offset, color.defaultColor);
      offset += 3;
    }
  }

  static void _setDefaultUniforms(ShaderWrapper shader, ShaderEnum type) {
    int index = 3 + type.colors.length * 3;
    for (var uniform in type.uniforms) {
      shader.setFloat(index, uniform.init);
      ++index;
    }
  }
}

