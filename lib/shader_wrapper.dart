import 'dart:ui';

//todo: prime candidate for a rewrite.
// main issue is FragmentShader has no constructor, so it'd need to be a FragmentProgram extension
class ShaderWrapper {
  final FragmentShader _shader;
  final List<double> _uniformValues = <double>[];

  ShaderWrapper(this._shader);

  void setFloat(int index, double value) {
    while (_uniformValues.length - 1 < index) {
      _uniformValues.add(0.0);
    }
    _uniformValues[index] = value;
    _shader.setFloat(index, value);
  }

  void setColor3(int index, Color color) {
    while (_uniformValues.length - 1 < index + 2) {
      _uniformValues.add(0.0);
    }
    this
      ..setFloat(index, color.red.toDouble() / 255)
      ..setFloat(index + 1, color.green.toDouble() / 255)
      ..setFloat(index + 2, color.blue.toDouble() / 255);
  }

  double? getFloat(int index) {
    if (_uniformValues.length - 1 < index) {
      return null;
    }
    return _uniformValues[index];
  }

  Color? getColor3(int index) {
    if (_uniformValues.length - 1 < index + 2) {
      return null;
    }
    var rgb = _uniformValues
        .getRange(index, index + 3)
        .map((x) => (x * 255).round())
        .toList();
    return Color.fromRGBO(rgb[0], rgb[1], rgb[2], 1.0);
  }

  void dispose() {
    _shader.dispose();
  }

  FragmentShader get shader {
    return _shader;
  }
}