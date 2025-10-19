import 'dart:math';
import 'package:flutter/material.dart';

class CustomFlipTransition extends StatelessWidget {
  const CustomFlipTransition({
    super.key,
    required this.animation,
    required this.child,
    required this.isFlipped,
  });

  final Animation<double> animation;
  final Widget child;
  final bool isFlipped;

  @override
  Widget build(BuildContext context) {
    final rotate = Tween(begin: pi, end: 0.0).animate(animation);
    return AnimatedBuilder(
      animation: rotate,
      child: child,
      builder: (context, child) {
        final isUnder = (ValueKey(isFlipped) != child?.key);
        var tilt = (animation.value - 0.5).abs() - 0.5;
        tilt *= isUnder ? -0.003 : 0.003;
        final value = isUnder ? min(rotate.value, pi / 2) : rotate.value;
        return Transform(
          transform: Matrix4.rotationY(value)..setEntry(3, 0, tilt),
          alignment: Alignment.center,
          child: child,
        );
      },
    );
  }
}
