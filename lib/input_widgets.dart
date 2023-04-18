import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:forgotten_hypno/color_hex_extension.dart';
import 'package:forgotten_hypno/shader_state.dart';
import 'package:forgotten_hypno/shaders.dart';
import 'package:provider/provider.dart';

class SizeInput extends StatelessWidget {
  final ColorSize colorSize;
  final GlobalKey<FormState> formKey;
  const SizeInput({super.key, required this.colorSize, required this.formKey});
  @override
  Widget build(BuildContext context) {
    return Consumer<ShaderState>(builder: (_, state, __) {
      return TextFormField(
        initialValue: state.shader.getFloat(colorSize.address)!.toString(),
        onChanged: (value) {
          if (formKey.currentState!.validate()) {
            state.shader.setFloat(colorSize.address, double.parse(value));
          }
        },
        inputFormatters: [
          FilteringTextInputFormatter.singleLineFormatter,
          FilteringTextInputFormatter(RegExp(r'[\d.]'), allow: true)
        ],
        keyboardType: const TextInputType.numberWithOptions(
          signed: false,
          decimal: true,
        ),
        validator: (String? value) {
          if (value != null) {
            try {
              var number = double.parse(value);
              if (number < 0) {
                return "Size can't be smaller than 0";
              }
              return null;
            } on FormatException {
              return 'Invalid number';
            }
          }
          return null;
        },
        decoration: const InputDecoration(
          labelText: 'Size Ratio',
          hintText: 'Whole number',
        ),
      );
    });
  }
}

class IntInput extends StatelessWidget {
  final FloatUniform uniform;
  final GlobalKey<FormState> formKey;
  const IntInput({super.key, required this.uniform, required this.formKey});
  @override
  Widget build(BuildContext context) {
    return Consumer<ShaderState>(builder: (_, state, __) {
      return TextFormField(
        //todo: maximum/minimum input validation
        initialValue:
            state.shader.getFloat(uniform.address)!.toInt().toString(),
        onChanged: (value) {
          if (formKey.currentState!.validate()) {
            state.shader.setFloat(uniform.address, double.parse(value));
          }
        },
        inputFormatters: [
          FilteringTextInputFormatter.singleLineFormatter,
          FilteringTextInputFormatter(RegExp(r'[\d-]'), allow: true)
        ],
        keyboardType: const TextInputType.numberWithOptions(
          signed: true,
          decimal: false,
        ),
        validator: (String? value) {
          if (value != null) {
            try {
              var number = int.parse(value);
              if (uniform.min != null && number < uniform.min!) {
                return 'Value smaller than minimum (${uniform.min!.toInt()})';
              } else if (uniform.max != null && number > uniform.max!) {
                return 'Value greater than maximum (${uniform.max!.toInt()})';
              }
              return null;
            } on FormatException {
              return 'Invalid number';
            }
          }
          return null;
        },
        decoration: InputDecoration(
          labelText: uniform.name,
          hintText: 'Whole number',
        ),
      );
    });
  }
}

class FloatInput extends StatelessWidget {
  final FloatUniform uniform;
  final GlobalKey<FormState> formKey;
  const FloatInput({super.key, required this.uniform, required this.formKey});
  @override
  Widget build(BuildContext context) {
    return Consumer<ShaderState>(builder: (_, state, __) {
      return TextFormField(
        //todo: maximum/minimum input validation
        initialValue: state.shader.getFloat(uniform.address)!.toString(),
        onChanged: (value) {
          if (formKey.currentState!.validate()) {
            state.shader.setFloat(uniform.address, double.parse(value));
          }
        },
        inputFormatters: [
          FilteringTextInputFormatter.singleLineFormatter,
          FilteringTextInputFormatter(RegExp(r'[\d.-]'), allow: true)
        ],
        keyboardType: const TextInputType.numberWithOptions(
          signed: true,
          decimal: true,
        ),
        validator: (String? value) {
          if (value != null) {
            try {
              var number = double.parse(value);
              if (uniform.min != null && number < uniform.min!) {
                return 'Value smaller than minimum (${uniform.min})';
              } else if (uniform.max != null && number > uniform.max!) {
                return 'Value greater than maximum (${uniform.max})';
              }
              return null;
            } on FormatException {
              return 'Invalid floating point number';
            }
          }
          return null;
        },
        decoration: InputDecoration(
          labelText: uniform.name,
          hintText: 'Decimal number',
        ),
      );
    });
  }
}

class ColorInput extends StatelessWidget {
  final ColorUniform uniform;
  final GlobalKey<FormState> formKey;
  final Function? colorCallback;
  const ColorInput(
      {super.key,
      required this.uniform,
      required this.formKey,
      this.colorCallback});

  @override
  Widget build(BuildContext context) {
    return Consumer<ShaderState>(builder: (_, state, __) {
      return TextFormField(
        //todo: there's a null assertion here
        //todo: monospace font
        initialValue: state.shader.getColor3(uniform.address)!.toHexString(),
        onChanged: (value) {
          if (formKey.currentState!.validate()) {
            var color = ColorHex.fromHexString(value)!;
            state.shader.setColor3(uniform.address, color);
            colorCallback?.call(color);
          }
        },
        inputFormatters: [
          FilteringTextInputFormatter.singleLineFormatter,
          FilteringTextInputFormatter(RegExp(r'[\da-fA-F]'), allow: true),
          LengthLimitingTextInputFormatter(6)
        ],
        validator: (String? value) {
          final hexRegex = RegExp(r'^#?[\da-fA-F]{6}$');
          return (value != null && hexRegex.hasMatch(value))
              ? null
              : 'Invalid hex code';
        },
        decoration: InputDecoration(
          labelText: uniform.name,
          hintText: 'Hex color code',
        ),
      );
    });
  }
}
