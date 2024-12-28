import 'package:flutter/material.dart';

class ColorChangingLoader extends StatefulWidget {
  const ColorChangingLoader({super.key});

  @override
  State<ColorChangingLoader> createState() => _ColorChangingLoaderState();
}

class _ColorChangingLoaderState extends State<ColorChangingLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();

    _colorAnimation = ColorTweenSequence().animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _colorAnimation,
      builder: (context, child) {
        return CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation(_colorAnimation.value),
        );
      },
    );
  }
}

class ColorTweenSequence extends TweenSequence<Color?> {
  ColorTweenSequence()
      : super([
    TweenSequenceItem(
      tween: ColorTween(begin: Colors.red, end: Colors.blue),
      weight: 1,
    ),
    TweenSequenceItem(
      tween: ColorTween(begin: Colors.blue, end: Colors.green),
      weight: 1,
    ),
    TweenSequenceItem(
      tween: ColorTween(begin: Colors.green, end: Colors.orange),
      weight: 1,
    ),
    TweenSequenceItem(
      tween: ColorTween(begin: Colors.orange, end: Colors.red),
      weight: 1,
    ),
  ]);
}
