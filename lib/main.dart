import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:forgotten_hypno/image_state.dart';
import 'package:forgotten_hypno/settings_page.dart';
import 'package:forgotten_hypno/shader_widget.dart';
import 'package:forgotten_hypno/shader_state.dart';
import 'package:forgotten_hypno/shaders.dart';

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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ShaderState>.value(value: state),
        ChangeNotifierProvider<ImageState>(create: (_) => ImageState()),
      ],
      child: MaterialApp(
        title: "Forgotten Hypnosis",
        theme: ThemeData(
            appBarTheme: const AppBarTheme(
          color: Color(0xFF222222),
        )),
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
            onDoubleTap: () => Navigator.pushNamed(context, '/shader_settings'), // todo: make this remember what page the user was on
            child: Consumer2<ShaderState, ImageState>(
                builder: (_, shader, image, __) {
                  var size = View.of(context).physicalSize;
              return ShaderWidget(shader.shader, image.getOverlay(size));
            })));
  }
}
