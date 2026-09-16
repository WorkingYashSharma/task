import 'package:flutter/material.dart';

class FadeSlideIn extends StatelessWidget {
  const FadeSlideIn({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.duration = const Duration(milliseconds: 480),
    this.dy = 14,
    this.scaleBegin = 1,
  });

  final Widget child;
  final Duration delay;
  final Duration duration;
  final double dy;
  final double scaleBegin;

  @override
  Widget build(BuildContext context) {
    final total = delay + duration;
    final start = total.inMilliseconds == 0
        ? 0.0
        : delay.inMilliseconds / total.inMilliseconds;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: total,
      curve: Interval(start.clamp(0, 0.95), 1, curve: Curves.easeOutCubic),
      builder: (context, t, child) {
        return Opacity(
          opacity: t,
          child: Transform.translate(
            offset: Offset(0, dy * (1 - t)),
            child: Transform.scale(
              scale: scaleBegin + (1 - scaleBegin) * t,
              child: child,
            ),
          ),
        );
      },
      child: child,
    );
  }
}
