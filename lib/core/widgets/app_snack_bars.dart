import 'package:flutter/material.dart';
import 'package:task/core/theme/app_colors.dart';

enum AppSnackBarType { error, warning, missing }

abstract final class AppSnackBars {
  static OverlayEntry? _entry;

  static void error(BuildContext context, String message) {
    show(context, message: message, type: AppSnackBarType.error);
  }

  static void warning(BuildContext context, String message) {
    show(context, message: message, type: AppSnackBarType.warning);
  }

  static void missing(BuildContext context, String message) {
    show(context, message: message, type: AppSnackBarType.missing);
  }

  static void show(
    BuildContext context, {
    required String message,
    required AppSnackBarType type,
  }) {
    hide();

    final overlay = Overlay.maybeOf(context, rootOverlay: true);
    if (overlay == null) return;

    _entry = OverlayEntry(
      builder: (_) =>
          _TopSnackBar(message: message, type: type, onDismiss: hide),
    );
    overlay.insert(_entry!);
  }

  static void hide() {
    _entry?.remove();
    _entry = null;
  }
}

class _TopSnackBar extends StatefulWidget {
  const _TopSnackBar({
    required this.message,
    required this.type,
    required this.onDismiss,
  });

  final String message;
  final AppSnackBarType type;
  final VoidCallback onDismiss;

  @override
  State<_TopSnackBar> createState() => _TopSnackBarState();
}

class _TopSnackBarState extends State<_TopSnackBar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _offset;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
    );
    _offset = Tween(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    _controller.forward();
    Future<void>.delayed(const Duration(seconds: 3), _dismiss);
  }

  bool _closing = false;

  Future<void> _dismiss() async {
    if (_closing || !mounted) return;
    _closing = true;
    await _controller.reverse();
    if (mounted) widget.onDismiss();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color get _background {
    return switch (widget.type) {
      AppSnackBarType.error => AppColors.snackError,
      AppSnackBarType.warning => AppColors.snackWarning,
      AppSnackBarType.missing => AppColors.snackMissing,
    };
  }

  IconData get _icon {
    return switch (widget.type) {
      AppSnackBarType.error => Icons.error_outline_rounded,
      AppSnackBarType.warning => Icons.warning_amber_rounded,
      AppSnackBarType.missing => Icons.info_outline_rounded,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 16,
      right: 16,
      child: SlideTransition(
        position: _offset,
        child: FadeTransition(
          opacity: _controller,
          child: SafeArea(
            bottom: false,
            child: Material(
              color: Colors.transparent,
              child: GestureDetector(
                onTap: _dismiss,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: _background,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.16),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Icon(_icon, color: Colors.white, size: 20),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          widget.message,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            height: 1.3,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
