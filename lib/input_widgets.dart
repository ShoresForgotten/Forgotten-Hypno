import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class IntInput extends StatelessWidget {
  final String name;
  final int? min;
  final int? max;
  final int init;
  final Function(int) callback;
  final GlobalKey<FormState> formKey;

  const IntInput(
      {super.key,
      required this.formKey,
      required this.name,
      this.max,
      this.min,
      required this.init,
      required this.callback});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: init.toString(),
      onChanged: (value) {
        if (formKey.currentState!.validate()) {
          callback.call(int.parse(value));
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
            if (min != null && number < min!) {
              return 'Value smaller than minimum value (${min!})';
            } else if (max != null && number > max!) {
              return 'Value greater than maximum value (${max!})';
            }
            return null;
          } on FormatException {
            return 'Invalid number';
          }
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: name,
        hintText: 'Whole number',
      ),
    );
  }
}

class FloatInput extends StatelessWidget {
  final String name;
  final double? min;
  final double? max;
  final double init;
  final Function(double) callback;
  final GlobalKey<FormState> formKey;

  const FloatInput(
      {super.key,
      required this.formKey,
      this.max,
      this.min,
      required this.init,
      required this.callback,
      required this.name});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: init.toString(),
      onChanged: (value) {
        if (formKey.currentState!.validate()) {
          callback.call(double.parse(value));
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
            if (min != null && number < min!) {
              // Don't know why dart needs a null assertion here, && should short-circuit if min is null
              return 'Value smaller than minimum (${min!})';
            } else if (max != null && number > max!) {
              return 'Value greater than maximum (${max!})';
            }
            return null;
          } on FormatException {
            return 'Invalid floating point number';
          }
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: name,
        hintText: 'Decimal number',
      ),
    );
  }
}

class ColorInput extends StatelessWidget {
  final String name;
  final Color initValue;
  final Function(Color) callback;
  final GlobalKey<FormState> formKey;

  const ColorInput(
      {super.key,
      required this.formKey,
      required this.callback,
      required this.initValue,
      required this.name});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      //todo: there's a null assertion here
      //todo: monospace font
      initialValue: initValue.value.toRadixString(16).substring(2),
      onChanged: (value) {
        if (formKey.currentState!.validate()) {
          var color = Color(int.parse(value, radix: 16) + 0xFF000000);
          callback.call(color);
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
        labelText: name,
        hintText: 'Hex color code',
      ),
    );
  }
}
