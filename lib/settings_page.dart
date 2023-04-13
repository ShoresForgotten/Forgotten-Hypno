import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'shader_state.dart';
import 'shaders.dart';

import 'package:flutter/foundation.dart' as foundation;

/// Uses Consumers to construct a settings menu based on the current shader type
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Shader Settings'),
        ),
        //todo: consumers in main or in widgets. pick one.
        body: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 5.0, horizontal: 25.0),
            child: Column(
              children: [
                Consumer<ShaderState>(builder: (_, state, __) {
                  return DropdownButton<ShaderEnum>(
                    value: state.type,
                    items: ShaderEnum.values.where((element) {
                      // disallow debugOnly shaders, unless kDebugMode is true
                      return (!element.debugOnly || foundation.kDebugMode);
                    }).map((var value) {
                      return DropdownMenuItem(
                          value: value, child: Text(value.name));
                    }).toList(),
                    onChanged: (ShaderEnum? value) {
                      if (value != null) {
                        state.changeShader(value);
                        //todo: this, but better
                        Navigator.popAndPushNamed(context, '/shader_settings');
                      }
                    },
                  );
                }),
                const Divider(),
                const Expanded(
                  child: ShaderSettings(),
                ),
              ],
            )));
  }
}

/// Uses a Consumer to build the list of required settings widgets for the uniforms
class ShaderSettings extends StatelessWidget {
  const ShaderSettings({super.key});

  @override
  Widget build(BuildContext context) {
    //todo: reorganize this to make better use of Consumer<T>
    return Consumer<ShaderState>(builder: (_, state, __) {
      List<Widget> widgets = [];
      for (var color in state.type.colors) {
        widgets.add(ColorSelector(index: color.address, name: color.name));
      }
      for (var uniform in state.type.uniforms) {
        if (uniform.isInt == false) {
          // float changing widget here
          widgets
              .add(FloatSelector(index: uniform.address, name: uniform.name));
        } else {
          // int changing widget here
          widgets.add(IntSelector(
            index: uniform.address,
            name: uniform.name,
          ));
        }
      }
      return ListView(
        children: widgets,
      );
    });
  }
}

/// A widget for selecting color in the current state. Currently uses 6-character hex codes.
class ColorSelector extends StatelessWidget {
  /// The index of the uniform
  final int index;
  /// The name of the uniform
  final String name;
  const ColorSelector({super.key, required this.index, required this.name});

  @override
  Widget build(BuildContext context) {
    return Consumer<ShaderState>(builder: (_, state, __) {
      return TextFormField(
        //todo: there's a null assertion here
        //todo: monospace font
        initialValue: state.shader.getColor3(index)!.toHexString(),
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
        //todo: make validators work (might be a larger refactor)
        /*
        validator: (String? value) {
          final hexRegex = RegExp(r'^#?[\da-fA-F]{6}$');
          return (value != null && hexRegex.hasMatch(value))
              ? 'Invalid hex code'
              : null;
        },
        */
        decoration: InputDecoration(
          labelText: name,
          hintText: 'Hex color code',
        ),
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

/// Widget for setting positive whole number uniforms in the current state
class IntSelector extends StatelessWidget {
  /// The index of the uniform
  final int index;
  /// The name of the uniform
  final String name;
  const IntSelector({super.key, required this.index, required this.name});

  @override
  Widget build(BuildContext context) {
    return Consumer<ShaderState>(
      builder: (_, state, __) {
        return TextFormField(
          //todo: maximum/minimum input validation
          initialValue: state.shader.getFloat(index)!.toInt().toString(),
          onChanged: (value) {
            state.shader.setFloat(index, int.parse(value).toDouble());
          },
          inputFormatters: [
            FilteringTextInputFormatter.singleLineFormatter,
            FilteringTextInputFormatter.digitsOnly
          ],
          keyboardType: const TextInputType.numberWithOptions(
            signed: false,
            decimal: false,
          ),
          decoration: InputDecoration(
            labelText: name,
            hintText: 'Whole number',
          ),
        );
      },
    );
  }
}

/// Widget for setting floating-point number uniforms for the current state.
class FloatSelector extends StatelessWidget {
  final int index;
  final String name;
  const FloatSelector({super.key, required this.index, required this.name});

  @override
  Widget build(BuildContext context) {
    return Consumer<ShaderState>(builder: (_, state, __) {
      return TextFormField(
        //todo: maximum/minimum input validation
        initialValue: state.shader.getFloat(index)!.toString(),
        onChanged: (value) {
          // todo: how to handle an invalid input?

          state.shader.setFloat(index, double.parse(value));
        },
        inputFormatters: [
          FilteringTextInputFormatter.singleLineFormatter,
          FilteringTextInputFormatter(RegExp(r'[\d.-]'), allow: true)
        ],
        keyboardType: const TextInputType.numberWithOptions(
          signed: true,
          decimal: true,
        ),
        /*
        validator: (String? value) {
          if (value != null) {
            try {
              double.parse(value);
              return null;
            } on FormatException {
              return 'Invalid floating point number';
            }
          }
          return null;
        },
        */
        decoration: InputDecoration(
          labelText: name,
          hintText: 'Decimal number',
        ),
      );
    });
  }
}

/*
class FullscreenSwitch extends StatefulWidget {
  const FullscreenSwitch({super.key});

  @override
  State<StatefulWidget> createState() => _FullscreenSwitchState()
}

class _FullscreenSwitchState extends State<FullscreenSwitch> {
  bool value = false;
  @override
  void initState() {
    if (SystemChrome.latestStyle == SystemUiMode.immersive) {

    }
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }

}*/
