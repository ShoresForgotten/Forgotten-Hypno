import 'package:flutter/material.dart';
import 'shader_provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
        color: const Color(0xD94B4B4B),
        child: Container(
            padding:
                const EdgeInsets.symmetric(vertical: 20.0, horizontal: 15.0),
            constraints: const BoxConstraints(maxWidth: 800),
            child: Column(children: [
              Row(children: const [
                ShaderSelector(),
              ]),
              const Divider(),
              Expanded(
                  child: UniformSettings(
                      shaderInfo: ShaderInherit.of(context).activeType))
            ])));
  }
}

enum TempShaderEnum {
  spiralShader(name: 'Spiral Shader');

  const TempShaderEnum({
    required this.name,
  });

  final String name;
}

class ShaderSelector extends StatefulWidget {
  const ShaderSelector({super.key});

  @override
  State<ShaderSelector> createState() => _ShaderSelectorState();
}

class _ShaderSelectorState extends State<ShaderSelector> {
  late ShaderEnum _selected;

  @override
  Widget build(BuildContext context) {
    _selected = ShaderInherit.of(context).activeType;
    return DropdownButton<ShaderEnum>(
      //icon: const Icon(Icons.arrow_drop_down), Don't have uses_material_design, so I don't think this works
      icon: null,
      value: _selected,
      items: ShaderEnum.values.map((ShaderEnum value) {
        return DropdownMenuItem<ShaderEnum>(
          value: value,
          child: Text(value.name),
        );
      }).toList(),
      onChanged: (ShaderEnum? value) {
        setState(() {
          _selected = value!;
        });
        ShaderInherit.of(context).setShader(value!);
      },
    );
  }
}

class UniformSettings extends StatelessWidget {
  final ShaderEnum shaderInfo;
  const UniformSettings({super.key, required this.shaderInfo});

  //TODO: make this better. also something about coupling, and how high it is here and how low it should be
  @override
  Widget build(BuildContext context) {
    return ListView(
        children: shaderInfo.uniforms.map((FloatUniform uniform) {
      return UniformSlider(
        key: Key('${shaderInfo.name}::${uniform.name}'),
        uniformName: uniform.name,
        uniformAddress: uniform.address,
        min: uniform.min,
        max: uniform.max,
        init: uniform.init,
        //divisions: uniform.divisions,
      );
    }).toList());
  }
}

class UniformSlider extends StatefulWidget {
  final String uniformName;
  final int uniformAddress;
  final double min;
  final double max;
  final int? divisions;
  final double init;
  const UniformSlider(
      {super.key,
      required this.uniformName,
      required this.uniformAddress,
      required this.min,
      required this.max,
      required this.init,
      this.divisions});

  @override
  State<UniformSlider> createState() => _UniformSliderState();
}

class _UniformSliderState extends State<UniformSlider> {
  late double _uniformValue;
  // TODO: Make the value display box editable so you don't have to use sliders?
  //final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    _uniformValue = widget.init;
    super.initState();
  }

  /*
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
   */

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            Text(
              widget.uniformName,
            ),
            Text(
              _uniformValue.toString(),
            )
            /*
            TextField(
              onSubmitted: (String value) {
                setState(() {
                  double? parsedDouble = double.tryParse(value);
                  if (parsedDouble != null) {
                    _uniformValue = parsedDouble;
                  }
                });
              },
              controller: _controller,
            )
             */
          ]),
          Slider.adaptive(
              value: _uniformValue,
              min: widget.min,
              max: widget.max,
              divisions: widget.divisions,
              onChanged: (double value) {
                setState(() {
                  _uniformValue = value;
                  ShaderInherit.of(context)
                      .activeShader
                      .setFloat(widget.uniformAddress, value);
                });
              })
        ]));
  }
}
