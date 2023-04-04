import 'package:flutter/material.dart';
import 'dart:ui';
import 'shaders.dart';

class ShaderState extends ChangeNotifier {
  late ShaderEnum activeType;
  late FragmentShader activeShader;

  late final Map<ShaderEnum, FragmentShader> _shaderCache;
  // not sure if a program cache is needed but putting it here just in case
  late final Map<ShaderEnum, FragmentProgram> _programCache;

  static Future<ShaderState> createState(ShaderEnum shader) async {
    var state = ShaderState();
    state.activeType = shader;
    var program = await FragmentProgram.fromAsset(shader.assetPath);
    state._programCache = {shader: program};
    var fragmentShader = program.fragmentShader();
    state._shaderCache = {shader: fragmentShader};
    state.activeShader = fragmentShader;
    return state;
  }

  Future<void> compileShader(ShaderEnum shader) async {
    // if shader is already compiled, don't
    // otherwise compile

    // is this check needed? lets find out what happens if we don't

    //if (!shaderCache.containsKey(shader)) {
    var program = await FragmentProgram.fromAsset(shader.assetPath);
    _programCache[shader] = program;
    _shaderCache[shader] = program.fragmentShader();
    //}
  }

  void changeShader(ShaderEnum shader) async {
    if (_shaderCache[shader] == null) {
      await compileShader(shader);
    }
    activeType = shader;
    activeShader = _shaderCache[shader]!;
    notifyListeners();
  }
}
