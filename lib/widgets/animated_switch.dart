import 'package:flutter/material.dart';

class AnimatedSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final Duration duration;
  final Curve curve;
  final Color activeColor;
  final Color inactiveColor;
  final Color activeTrackColor;
  final Color inactiveTrackColor;
  final Color activeColorIcon;
  final Color inactiveColorIcon;

  const AnimatedSwitch({
    Key? key,
    required this.value,
    required this.onChanged,
    this.duration = const Duration(milliseconds: 200),
    this.curve = Curves.easeInOut,
    this.activeColor = Colors.blue,
    this.inactiveColor = Colors.grey,
    this.activeTrackColor = Colors.blue,
    this.inactiveTrackColor = Colors.grey,
    this.activeColorIcon = Colors.white,
    this.inactiveColorIcon = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: duration,
      curve: curve,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: value ? activeTrackColor : inactiveTrackColor,
      ),
      child: Container(
        width: 50,
        height: 28,
        padding: const EdgeInsets.all(2),
        child: Stack(
          children: [
            AnimatedPositioned(
              duration: duration,
              curve: curve,
              left: value ? 22 : 2,
              top: 0,
              bottom: 0,
              child: AnimatedContainer(
                duration: duration,
                curve: curve,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: value ? activeColor : inactiveColor,
                ),
                child: Container(
                  width: 24,
                  height: 24,
                  child: Center(
                    child: Icon(
                      value ? Icons.check : Icons.close,
                      color: value ? activeColorIcon : inactiveColorIcon,
                      size: 14,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AnimatedContainer extends StatelessWidget {
  final Widget child;
  final Duration duration;
  final Curve curve;
  final BoxDecoration? decoration;

  const AnimatedContainer({
    Key? key,
    required this.child,
    this.duration = const Duration(milliseconds: 200),
    this.curve = Curves.easeInOut,
    this.decoration,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: duration,
      curve: curve,
      decoration: decoration ?? BoxDecoration(color: Colors.transparent),
      child: child,
    );
  }
}

class AnimatedPositioned extends StatelessWidget {
  final Widget child;
  final Duration duration;
  final Curve curve;
  final double? left;
  final double? right;
  final double? top;
  final double? bottom;

  const AnimatedPositioned({
    Key? key,
    required this.child,
    this.duration = const Duration(milliseconds: 200),
    this.curve = Curves.easeInOut,
    this.left,
    this.right,
    this.top,
    this.bottom,
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