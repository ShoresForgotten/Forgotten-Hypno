import 'dart:ui';
import 'package:flutter/material.dart';

enum InputType { intBox, floatSlider }

//ShaderProvider, but not actually using Provider, because of my phobia of dependencies
class ShaderProvider extends StatefulWidget {
  final Widget child;
  final Map<ShaderEnum, FragmentProgram>
      shaderCache; // Could make the key int for indices
  final FragmentProgram initialProgram;
  final ShaderEnum initialType;
  const ShaderProvider(
      {super.key,
      required this.child,
      required this.shaderCache,
      required this.initialProgram,
      required this.initialType});

  // TODO: Is it possible to get the creation of shaderCache out of the constructor while keeping it const?

  @override
  State<ShaderProvider> createState() => _ShaderProviderState();
}

class _ShaderProviderState extends State<ShaderProvider> {
  //TODO: How to initialize this?
  late FragmentProgram activeProgram;
  late ShaderEnum activeType;
  //TODO: Put getting the initial program in another class, it's too much responsibility to put into just one I think.
  //late Future<FragmentProgram> initialProgram;

  @override
  void initState() {
    activeProgram = widget.initialProgram;
    activeType = widget.initialType;
    cacheProgram(activeType, activeProgram);
    //initialProgram = FragmentProgram.fromAsset(ShaderEnum.logSpiral.assetPath);
    super.initState();
  }

  void cacheProgram(ShaderEnum shaderID, FragmentProgram program) {
    widget.shaderCache[shaderID] = program;
  }

  void setProgram(ShaderEnum shaderID) async {
    var cached = widget.shaderCache[shaderID];
    FragmentProgram program;
    if (cached != null) {
      program = cached;
    } else {
      program = await FragmentProgram.fromAsset(shaderID.assetPath);
      widget.shaderCache[shaderID] = program;
    }
    setState(() {
      activeProgram = program;
      activeType = shaderID;
    });
  }

  @override
  build(BuildContext context) {
    return ShaderInherit(
      activeShader: activeProgram.fragmentShader(),
      activeType: activeType,
      setShader: setProgram,
      child: widget.child,
    );
  }
}

class ShaderInherit extends InheritedWidget {
  final FragmentShader activeShader;
  final ShaderEnum activeType;
  final void Function(ShaderEnum shader) setShader;

  const ShaderInherit(
      {super.key,
      required super.child,
      required this.activeShader,
      required this.setShader,
      required this.activeType});

  static ShaderInherit? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ShaderInherit>();
  }

  static ShaderInherit of(BuildContext context) {
    final ShaderInherit? result = maybeOf(context);
    assert(result != null, 'No ShaderInherit found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return oldWidget != this;
  }
}
//https://stackoverflow.com/questions/49491860/flutter-how-to-correctly-use-an-inherited-widget
