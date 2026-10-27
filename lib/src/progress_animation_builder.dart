import 'package:flutter/widgets.dart';

typedef ProgressBuilder = Widget Function(
  BuildContext context,
  Animation<double> animation,
);

class const ProgressAnimationBuilder({
  super.key,
  required final ProgressBuilder builder,
  required final Duration duration,
  final double value = 0,
  final Curve? curve,
  final Widget? child,
}) extends StatefulWidget {
  this : assert(value >= 0 && value <= 1);

  @override
  State<ProgressAnimationBuilder> createState() =>
      _ProgressAnimationBuilderState();
}

class _ProgressAnimationBuilderState()
    extends State<ProgressAnimationBuilder>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
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
        milliseconds:
            widget.duration.inMilliseconds ~/
            (_controller.value - widget.value).abs(),
      );
      _controller
        ..duration = duration
        ..animateTo(widget.value);
    }
    final curve = widget.curve;
    return widget.builder(
      context,
      curve == null ? _controller : _controller.drive(CurveTween(curve: curve)),
    );
  }
}
