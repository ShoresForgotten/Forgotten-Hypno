import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:forgotten_hypno/image_state.dart';
import 'package:forgotten_hypno/input_widgets.dart';

class ImageSettings extends StatelessWidget {
  final _formKeyScale = GlobalKey<FormState>();
  final _formKeyRotation = GlobalKey<FormState>();
  final _formKeyTranslateX = GlobalKey<FormState>();
  final _formKeyTranslateY = GlobalKey<FormState>();

  ImageSettings({super.key});
  @override
  Widget build(BuildContext context) {
    return Consumer<ImageState>(
      builder: (_, state, __) {
        return Column(
          children: [
            Form(
              key: _formKeyScale,
              child: FloatInput(
                formKey: _formKeyScale,
                init: state.scale,
                min: 0.0,
                name: 'Scale',
                callback: (double val) {
                  state.scale = val;
                },
              ),
            ),
            Form(
              key: _formKeyRotation,
              child: FloatInput(
                formKey: _formKeyRotation,
                init: state.rotation,
                name: 'Rotation',
                callback: (double val) {
                  state.rotation = val;
                },
              ),
            ),
            Form(
              key: _formKeyTranslateX,
              child: FloatInput(
                formKey: _formKeyTranslateX,
                init: state.offsetX,
                name: 'Offset X',
                callback: (double val) {
                  state.offsetX = val;
                },
              ),
            ),
            Form(
              key: _formKeyTranslateY,
              child: FloatInput(
                formKey: _formKeyTranslateY,
                init: state.offsetY,
                name: 'Offset Y',
                callback: (double val) {
                  state.offsetY = val;
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

class ImageList extends StatelessWidget {
  const ImageList({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Expanded(
      child: ListView(
        children: const [
          ImageSelector(
              image: Placeholder(),
              name: 'Placeholder',
              description: 'builtin'),
        ],
      ),
    );
  }
}

class ImageSelector extends StatelessWidget {
  final String name;
  final String description;
  final Widget? image;

  const ImageSelector(
      {super.key,
      required this.image,
      required this.name,
      required this.description});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Row(children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: 100,
              height: 100,
              child: image,
            ),
          ),
          Column(
            children: [Text(name), Text(description)],
          )
        ]),
      ),
    );
  }
}
