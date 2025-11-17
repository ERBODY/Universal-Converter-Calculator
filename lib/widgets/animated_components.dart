import 'package:flutter/material.dart';

/// Animated components for modern UI
class AnimatedSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final Duration duration;
  final Color activeColor;
  final Color inactiveColor;

  const AnimatedSwitch({
    Key? key,
    required this.value,
    required this.onChanged,
    this.duration = const Duration(milliseconds: 300),
    this.activeColor = Colors.blue,
    this.inactiveColor = Colors.grey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: duration,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: value ? activeColor.withOpacity(0.8) : inactiveColor.withOpacity(0.3),
          border: Border.all(
            color: value ? activeColor : inactiveColor,
            width: 2,
          ),
        ),
        child: Container(
          width: 50,
          height: 28,
          child: Stack(
            children: [
              AnimatedPositioned(
                duration: duration,
                left: value ? 22 : 2,
                curve: Curves.easeInOut,
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: value ? activeColor : Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              AnimatedPositioned(
                duration: duration,
                left: value ? 22 : 2,
                curve: Curves.easeInOut,
                child: Center(
                  child: Icon(
                    value ? Icons.check : Icons.circle,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AnimatedContainer extends StatelessWidget {
  final Widget child;
  final Duration duration;
  final BoxDecoration? decoration;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  const AnimatedContainer({
    Key? key,
    required this.child,
    this.duration = const Duration(milliseconds: 300),
    this.decoration,
    this.padding,
    this.margin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: duration,
      curve: Curves.easeInOut,
      decoration: decoration ?? BoxDecoration(color: Colors.transparent),
      padding: padding,
      margin: margin,
      child: child,
    );
  }
}

class AnimatedPositioned extends StatelessWidget {
  final Widget child;
  final Duration duration;
  final double? left;
  final double? right;
  final double? top;
  final double? bottom;
  final Curve curve;

  const AnimatedPositioned({
    Key? key,
    required this.child,
    this.duration = const Duration(milliseconds: 300),
    this.left,
    this.right,
    this.top,
    this.bottom,
    this.curve = Curves.easeInOut,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: duration,
      curve: curve,
      left: left,
      right: right,
      top: top,
      bottom: bottom,
      child: child,
    );
  }
}