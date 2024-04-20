import 'package:flutter/material.dart';
import 'package:forgotten_hypno/shader_state.dart';
import 'package:forgotten_hypno/shaders.dart';
import 'package:provider/provider.dart';

import 'package:flutter/foundation.dart' as foundation;

import 'package:forgotten_hypno/input_widgets.dart';

class ShaderSelector extends StatelessWidget {
  const ShaderSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ShaderState>(builder: (_, state, __) {
      return DropdownButton<ShaderEnum>(
        value: state.type,
        items: ShaderEnum.values.where((element) {
          // disallow debugOnly shaders unless we're in debug mode
          return (!element.debugOnly || foundation.kDebugMode);
        }).map((var value) {
          return DropdownMenuItem(value: value, child: Text(value.name));
        }).toList(),
        onChanged: (ShaderEnum? value) {
          if (value != null) {
            state.setType(value);
          }
        },
      );
    });
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
        uniform: color,
        initColor: state.shader.getColor3(color.address)!,
        name: color.name,
      ));
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
  final String name;

  const ColorSelector(
      {super.key,
        required this.uniform,
        required this.initColor,
        required this.name});

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
    return Consumer<ShaderState>(builder: (_, state, __) {
      List<Widget> widgets = [
        Expanded(
            flex: 1,
            child: ColorInput(
              formKey: _formKey,
              callback: (Color color) {
                setState(() {
                  this.color = color;
                  state.shader.setColor3(widget.uniform.address, color);
                });
              },
              initValue: widget.initColor,
              name: widget.name,
            ))
      ];
      if (widget.uniform.size != null) {
        widgets.add(Expanded(
            flex: 1,
            child: FloatInput(
              formKey: _formKey,
              max: null,
              min: 0.0,
              init: state.shader.getFloat(widget.uniform.size!.address)!,
              name: 'Size',
              callback: (double val) {
                state.shader.setFloat(widget.uniform.size!.address, val);
              },
            )));
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
    });
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
        child: Consumer<ShaderState>(builder: (_, state, __) {
          return IntInput(
            formKey: _formKey,
            name: uniform.name,
            max: uniform.max?.toInt(),
            min: uniform.min?.toInt(),
            init: state.shader.getFloat(uniform.address)!.toInt(),
            callback: (int val) {
              state.shader.setFloat(uniform.address, val.toDouble());
            },
          );
        }));
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
      child: Consumer<ShaderState>(
        builder: (_, state, __) {
          return FloatInput(
              formKey: _formKey,
              init: state.shader.getFloat(uniform.address)!,
              min: uniform.min,
              max: uniform.max,
              name: uniform.name,
              callback: (double val) {
                state.shader.setFloat(uniform.address, val);
              });
        },
      ),
    );
  }
}
