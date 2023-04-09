import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'shader_state.dart';
import 'shaders.dart';

import 'package:flutter/foundation.dart' as Foundation;

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shader Settings'),
      ),
      //todo: consumers in main or in widgets. pick one.
      body: Consumer<ShaderState>(builder: (_, state, __) {
        return Column(
          children: [
            DropdownButton<ShaderEnum>(
              value: state.type,
              items: ShaderEnum.values.where((element) {
                // disallow debugOnly shaders, unless kDebugMode is true
                return (!element.debugOnly || Foundation.kDebugMode);
              }).map((var value) {
                return DropdownMenuItem(value: value, child: Text(value.name));
              }).toList(),
              onChanged: (ShaderEnum? value) {
                if (value != null) {
                  state.changeShader(value);
                }
              },
            ),
            const Divider(),
            Expanded(
              child: ShaderSettings(type: state.type),
            )
          ],
        );
      }),
    );
  }
}

class ShaderSettings extends StatelessWidget {
  final ShaderEnum type;
  const ShaderSettings({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = [];
    int currentIndex = 3; // 3 is always the first non-resolution/time uniform
    for (var color in type.colors) {
      widgets.add(ColorSelector(index: currentIndex, name: color.name));
      currentIndex += 3;
    }
    for (var uniform in type.uniforms) {
      if (uniform.isInt == false) {
        // float changing widget here
        widgets.add(FloatSelector(index: uniform.address, name: uniform.name));
      } else {
        // int changing widget here
        widgets.add(IntSelector(index: uniform.address, name: uniform.name,));
      }
    }
    return ListView(
      //todo: look into listview builder to see if it's better than the list
      //shrinkWrap: true,
      children: widgets,
    );
  }
}

class ColorSelector extends StatelessWidget {
  final int index;
  final String name;
  const ColorSelector({super.key, required this.index, required this.name});

  @override
  Widget build(BuildContext context) {
    return Consumer<ShaderState>(builder: (_, state, __) {
        return TextField(
          //todo: there's a null assertion here
          //todo: monospace font
          //todo: TextEditingController needs to be disposed
          controller: TextEditingController()
            ..text = state.shader.getColor3(index)!.toHexString(),
          onChanged: (value) {
            final hexRegex = RegExp(r'^#?[\da-fA-F]{6}$');
            if (hexRegex.hasMatch(value)) {
              state.shader.setColor3(index, ColorHex.fromHexString(value));
            }
          },
          inputFormatters: [
            FilteringTextInputFormatter.singleLineFormatter,
            FilteringTextInputFormatter(RegExp(r'[\da-fA-F]'), allow: true),
            LengthLimitingTextInputFormatter(6)
          ],
        );
    });
  }
}

extension ColorHex on Color {
  static Color fromHexString(String hexString) {
    //todo: what if bad hex string
    if (hexString.isNotEmpty && hexString[0] == '#') {
      return Color(
          int.parse(hexString.substring(1, 7), radix: 16) + 0xFF000000);
    }
    return Color(int.parse(hexString.substring(0, 6), radix: 16) + 0xFF000000);
  }

  String toHexString() {
    return value.toRadixString(16).substring(2);
  }
}

class IntSelector extends StatelessWidget {
  final int index;
  final String name;
  const IntSelector({super.key, required this.index, required this.name});

  @override
  Widget build(BuildContext context) {
    return Consumer<ShaderState>(
      builder: (_, state, __) {
        return TextField(
          //todo: dispose
          //todo: maximum/minimum input validation
          controller: TextEditingController()
            ..text = state.shader.getFloat(index)!.toInt().toString(),
          onChanged: (value) {
            state.shader.setFloat(index, int.parse(value).toDouble());
          },
          inputFormatters: [
            FilteringTextInputFormatter.singleLineFormatter,
            FilteringTextInputFormatter.digitsOnly
          ],
        );
      },
    );
  }
}

class FloatSelector extends StatelessWidget {
  final int index;
  final String name;
  const FloatSelector({super.key, required this.index, required this.name});

  @override
  Widget build(BuildContext context) {
    return Consumer<ShaderState>(builder: (_, state, __) {
      return TextField(
        //todo: dispose
        //todo: maximum/minimum input validation
        controller: TextEditingController()
          ..text = state.shader.getFloat(index)!.toString(),
        onChanged: (value) {
          // todo: how to handle an invalid input?
          state.shader.setFloat(index, double.parse(value));
        },
        inputFormatters: [
          FilteringTextInputFormatter.singleLineFormatter,
          FilteringTextInputFormatter(RegExp(r'[\d.-]'), allow: true)
        ],
      );
    });
  }
}
