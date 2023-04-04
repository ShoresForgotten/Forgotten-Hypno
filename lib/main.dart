import 'dart:collection';
import 'dart:ui';

import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'settings_page.dart';
import 'hypno_widget.dart';
import 'shader_state.dart';
import 'shaders.dart';

void main() async {
  var state = await ShaderState.createState(ShaderEnum.testShader);

  runApp(HypnoApp(
    state: state,
  ));
}

class HypnoApp extends StatelessWidget {
  const HypnoApp({super.key, required this.state});
  final ShaderState state;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Forgotten Hypnosis",
      home: Scaffold(
        appBar: null,
        body: ChangeNotifierProvider<ShaderState>(
            create: (_) => state,
            child: Stack(alignment: Alignment.center, children: [
              Consumer<ShaderState>(
                builder: (_, state, __) {
                  state.activeShader
                    ..setFloat(3, 1.0)
                    ..setFloat(4, 0.0)
                    ..setFloat(5, 1.0);
                  return HypnoWidget(state.activeShader);
                },
              )
            ])),
      ),
    );
  }
}

/*
Okay, so here's the big (ordered) todo:
Rewrite settings page. Make it use provider's state to remake the settings when needed
Make settings page work
Make the settings page retractable
 */
