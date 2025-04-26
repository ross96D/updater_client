import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:toastification/toastification.dart';
import 'package:updater_client/widgets/button.dart';

enum ToastType {
  error,
  warning,
  info,
  success;

  IconData icon() {
    return switch (this) {
      ToastType.error => Icons.error,
      ToastType.warning => Icons.warning,
      ToastType.info => Icons.info,
      ToastType.success => Icons.check_circle,
    };
  }

  (Color bg, Color fg, Color buttonBg, Color buttonFg) colors(BuildContext context) {
    final theme = Theme.of(context);
    return switch (this) {
      ToastType.error => (
          theme.colorScheme.error,
          theme.colorScheme.onError,
          Colors.transparent,
          theme.colorScheme.onError,
        ),
      ToastType.warning => (
          theme.colorScheme.tertiary,
          theme.colorScheme.onTertiary,
          Colors.transparent,
          theme.colorScheme.onTertiary,
        ),
      ToastType.info => (
          theme.colorScheme.secondary,
          theme.colorScheme.onSecondary,
          Colors.transparent,
          theme.colorScheme.onSecondary,
        ),
      ToastType.success => (
          theme.colorScheme.primary,
          theme.colorScheme.onPrimary,
          Colors.transparent,
          theme.colorScheme.onPrimary,
        ),
    };
  }
}

class ToastWidget extends StatelessWidget {
  const ToastWidget({
    super.key,
    required this.item,
    required this.title,
    required this.message,
    this.type = ToastType.info,
  });

  final ToastificationItem item;

  final ToastType type;

  final String title;

  final String message;

  @override
  Widget build(BuildContext context) {
    final (bg, fg, buttonBg, buttonFg) = type.colors(context);

    return MouseRegion(
      onHover: (_) => item.pause(),
      onExit: (_) => item.start(),
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: bg,
        ),
        child: Row(
          children: [
            Icon(type.icon(), color: fg),
            const SizedBox(width: 10),
            Flexible(
              fit: FlexFit.tight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(color: fg, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    message,
                    style: TextStyle(color: fg),
                  ),
                  const SizedBox(height: 10),
                  _ProgressIndicator(item: item, color: fg),
                ],
              ),
            ),
            const SizedBox(width: 10),
            SmallIconButton(
              icon: Icon(Icons.close, size: 15, color: buttonFg),
              onTap: () => toastification.dismiss(item),
              backgroundColor: buttonBg,
              hoverColor: buttonBg.withAlpha(120),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProgressIndicator extends StatefulWidget {
  final ToastificationItem item;

  final Color color;

  final Color? backgroundColor;

  _ProgressIndicator({
    required this.item,
    required this.color,
    this.backgroundColor,
  }) : assert(item.originalDuration != null, "progress indicator needs a duration");

  @override
  State<_ProgressIndicator> createState() => _ProgressIndicatorState();
}

class _ProgressIndicatorState extends State<_ProgressIndicator> {
  double _value = 0;

  @override
  void initState() {
    _value = (widget.item.elapsedDuration ?? const Duration()).inMicroseconds /
        widget.item.originalDuration!.inMicroseconds;

    SchedulerBinding.instance.addPostFrameCallback(_update);
    super.initState();
  }

  void _update(Duration _) {
    if (!mounted) {
      return;
    }
    setState(() {
      _value = (widget.item.elapsedDuration ?? const Duration()).inMicroseconds /
          widget.item.originalDuration!.inMicroseconds;
    });

    SchedulerBinding.instance.addPostFrameCallback(_update);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return LinearProgressIndicator(
      value: _value,
      backgroundColor: widget.backgroundColor ?? theme.colorScheme.outline,
      color: widget.color,
    );
  }
}
