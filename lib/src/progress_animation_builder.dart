import 'package:flutter/material.dart';

typedef ProgressBuilder<T> = Widget Function(
  BuildContext context,
  Animation<double> animation,
);

class ProgressAnimationBuilder extends StatefulWidget {
  const ProgressAnimationBuilder({
    Key key,
    @required this.builder,
    @required this.duration,
    this.value = 0,
    this.curve,
    this.child,
  })  : assert(value >= 0 && value <= 1),
        super(key: key);

  final ProgressBuilder builder;
  final Widget child;
  final double value;
  final Duration duration;
  final Curve curve;

  @override
  _ProgressAnimationBuilderState createState() =>
      _ProgressAnimationBuilderState();
}

class _ProgressAnimationBuilderState extends State<ProgressAnimationBuilder>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final diff = (_controller.value - widget.value).abs();
    if (diff != 0) {
      final duration = Duration(
        milliseconds: widget.duration.inMilliseconds ~/
            (_controller.value - widget.value).abs(),
      );
      _controller
        ..duration = duration
        ..animateTo(widget.value);
    }
    return widget.builder(
      context,
      widget.curve == null
          ? _controller
          : _controller.drive(CurveTween(curve: widget.curve)),
    );
  }
}
