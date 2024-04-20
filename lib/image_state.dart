import 'dart:math';
import 'package:vector_math/vector_math_64.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ImageState with ChangeNotifier {
  Widget? _svg;
  double _rotation = 0.0;
  double _scale = 1.0;
  double _xOffset = 0.0;
  double _yOffset = 0.0;
  final Map<String, Widget> _widgetCache = {}; // (path, svg widget)

  ImageState();

  ImageState.fromAsset(String assetPath) {
    _svg = SvgPicture.asset(assetPath);
  }

  Widget getOverlay(Size size) {
    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.compose(
          //todo: make this feel more right
          Vector3(_xOffset * size.width * 0.5, -_yOffset * size.height * 0.5,
              0.0), // translation (why is Y+ down?)
          Quaternion.axisAngle(Vector3(0.0, 0.0, 1.0), _rotation), // rotation
          Vector3.all(sqrt(_scale)) // scale
          ),
      child: _svg,
    );
  }

/*
  get widgetList {
    return assets;
  }
*/

  set scale(double scale) {
    _scale = scale;
    notifyListeners();
  }

  double get scale {
    return _scale;
  }

  set rotation(double rotation) {
    _rotation = rotation * pi * 2;
    notifyListeners();
  }

  double get rotation {
    return _rotation / (pi * 2);
  }

  set offsetX(double offset) {
    _xOffset = offset;
    notifyListeners();
  }

  double get offsetX {
    return _xOffset;
  }

  set offsetY(double offset) {
    _yOffset = offset;
    notifyListeners();
  }

  double get offsetY {
    return _yOffset;
  }
}
