import 'dart:collection';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'settings_page.dart';
import 'shader_provider.dart';
import 'hypno_painter.dart';

// NOTE: Asynchronous loading of shader can be done using FutureBuilder
void main() {
  runApp(const HypnoApp());
}

class HypnoApp extends StatelessWidget {
  const HypnoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MyHomePage(title: 'Flutter Demo Home Page',
    initialType: ShaderEnum.testShader);
  }
}

class MyHomePage extends StatefulWidget {
  final ShaderEnum initialType;
  const MyHomePage({super.key, required this.title, required this.initialType});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<FragmentProgram> initialShader;
  @override
  void initState() {
    initialShader = FragmentProgram.fromAsset(widget.initialType.assetPath);
    super.initState();
  }

  //TODO: maybe figure out somewhere else to put the FutureBuilder
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: FutureBuilder(
      builder: (BuildContext context, AsyncSnapshot<FragmentProgram> snapshot) {
        if (snapshot.hasData) {
          return ShaderProvider(
              shaderCache: HashMap(),
              initialType: widget.initialType,
              initialProgram: snapshot.data!,
              child: Stack(alignment: Alignment.center, children: const [
                HypnoPaint(),
                SettingsPage()
              ]));
        } else if (snapshot.hasError) {
          throw Exception(snapshot.error);
        } else {
          return const Placeholder();
        }
      },
      future: initialShader,
    ));
  }
}
