import 'dart:ui';

extension ColorSettings on FragmentShader {
  // this could be generalized to all vectors, but i'll deal with that when needed
  void setColor3(int location, Color color) {
    this
      ..setFloat(location, color.red.toDouble() / 255)
      ..setFloat(location + 1, color.green.toDouble() / 255)
      ..setFloat(location + 2, color.blue.toDouble() / 255);
  }
}
