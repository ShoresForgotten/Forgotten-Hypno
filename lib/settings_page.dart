import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:forgotten_hypno/image_settings.dart';
import 'package:forgotten_hypno/shader_settings.dart';
import 'package:forgotten_hypno/shader_state.dart';
import 'package:forgotten_hypno/shaders.dart';

/// Uses Consumers to construct a settings menu based on the current shader type
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      //todo: look into non-default tab controller
      length: 2,
      child: Scaffold(
          appBar: AppBar(
            title: const Text('Settings'),
            bottom: const TabBar(
              tabs: [
                Tab(
                  text: 'Shader',
                ),
                Tab(
                  text: 'Image',
                )
              ],
            ),
            actions: [
              PopupMenuButton(
                itemBuilder: (BuildContext context) =>
                    <PopupMenuEntry<Function>>[
                  PopupMenuItem(
                    value: () => showAboutDialog(context: context),
                    child: const Text('About'),
                  )
                ],
                onSelected: (Function fun) {
                  fun.call();
                },
              )
            ],
          ),
          //todo: consumers in main or in widgets. pick one.
          body: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 5.0, horizontal: 25.0),
              child: TabBarView(
                children: [
                  Column(
                    children: [
                      const ShaderSelector(),
                      const Divider(),
                      Expanded(
                          child: Consumer<ShaderState>(builder: (_, state, __) {
                        return ShaderSettings(
                            key: ValueKey<ShaderEnum>(state.type),
                            state: state);
                      })),
                    ],
                  ),
                  Column(
                    children: [
                      ImageSettings(),
                      const Divider(),
                      ImageList(),
                    ],
                  ),
                ],
              ))),
    );
  }
}
