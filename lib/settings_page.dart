import 'package:flutter/material.dart';
import 'package:forgotten_hypno/input_widgets.dart';
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
                Expanded(
                child: Consumer<ShaderState>(builder: (_, state, __) {
                    return ShaderSettings(state: state);
                  }
                  )
                ),
              ],
            )));
  }
}

/// Uses a Consumer to build the list of required settings widgets for the uniforms
class ShaderSettings extends StatelessWidget {
  final ShaderState state;
  const ShaderSettings({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = [];
    for (var color in state.type.colors) {
      widgets.add(ColorSelector(
          uniform: color, initColor: state.shader.getColor3(color.address)!));
    }
    for (var uniform in state.type.uniforms) {
      if (uniform.isInt == false) {
        // float changing widget here
        widgets.add(FloatSelector(uniform: uniform));
      } else {
        // int changing widget here
        widgets.add(IntSelector(
          uniform: uniform,
        ));
      }
    }
    return ListView(
      children: widgets,
    );
  }
}

/// A widget for selecting color in the current state. Currently uses 6-character hex codes.
class ColorSelector extends StatefulWidget {
  final ColorUniform uniform;
  final Color initColor;

  const ColorSelector(
      {super.key, required this.uniform, required this.initColor});

  @override
  State<ColorSelector> createState() => _ColorSelectorState();
}

class _ColorSelectorState extends State<ColorSelector> {
  final _formKey = GlobalKey<FormState>();
  late Color color;

  @override
  void initState() {
    super.initState();
    color = widget.initColor;
  }

  @override
  Widget build(BuildContext context) {
    // Using a list here to reduce code duplication
    List<Widget> widgets = [
      Expanded(
          flex: 1,
          child: ColorInput(
              uniform: widget.uniform,
              formKey: _formKey,
              colorCallback: (Color color) {
                setState(() {
                  this.color = color;
                });
              }))
    ];
    if (widget.uniform.size != null) {
      widgets.add(Expanded(
          flex: 1,
          child:
              SizeInput(colorSize: widget.uniform.size!, formKey: _formKey)));
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: SizedBox(
        height: 85.0 * widgets.length,
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
              child: Container(
                width: 8,
                height: 172,
                color: color,
              ),
            ),
            Expanded(
              child: Form(
                key: _formKey,
                child: Column(
                  children: widgets,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

/// Widget for setting positive whole number uniforms in the current state
class IntSelector extends StatelessWidget {
  final FloatUniform uniform;
  final _formKey = GlobalKey<FormState>();
  IntSelector({super.key, required this.uniform});

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: IntInput(
          uniform: uniform,
          formKey: _formKey,
        ));
  }
}

/// Widget for setting floating-point number uniforms for the current state.
class FloatSelector extends StatelessWidget {
  final FloatUniform uniform;
  final _formKey = GlobalKey<FormState>();
  FloatSelector({super.key, required this.uniform});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: FloatInput(
        uniform: uniform,
        formKey: _formKey,
      ),
    );
  }
}
