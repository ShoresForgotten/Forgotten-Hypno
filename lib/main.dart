import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'settings_page.dart';
import 'shader_widget.dart';
import 'shader_state.dart';
import 'shaders.dart';

void main() async {
  var state = await ShaderState.createState(ShaderEnum.spiral);

  runApp(HypnoApp(
    state: state,
  ));
}

class HypnoApp extends StatelessWidget {
  const HypnoApp({super.key, required this.state});
  final ShaderState state;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ShaderState>(
      create: (_) => state,
      child: MaterialApp(
        title: "Forgotten Hypnosis",
        routes: {
          '/': (BuildContext context) {
            return const HomePage();
          },
          '/shader_settings': (BuildContext context) {
            return const SettingsPage();
          }
        },
      ),
    );
  }
}

//todo: come up with a better name
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
        elevation: 0.0,
        child: GestureDetector(
            onDoubleTap: () => Navigator.pushNamed(context, '/shader_settings'),
            child: Consumer<ShaderState>(builder: (_, state, __) {
              return ShaderWidget(state.shader);
            })));
  }
}
