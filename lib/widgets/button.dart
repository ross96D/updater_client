import 'package:flutter/material.dart';

class Button extends StatefulWidget {
  const Button({super.key, required this.child, required this.onTap});

  final Widget child;

  final void Function() onTap;

  @override
  State<StatefulWidget> createState() => _Button();
}

class _Button extends State<Button> {
  bool _isHovered = false;

  Color _color(ThemeData theme) {
    if (_isHovered) {
      return theme.colorScheme.primary.withAlpha(150);
    } else {
      return theme.colorScheme.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        color: _color(theme),
      ),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onHover: (_) => setState(() {_isHovered = true;}),
        onExit: (_) => setState(() {_isHovered = false;}),

        child: Material(
          type: MaterialType.transparency,
          textStyle: theme.textTheme.titleMedium?.copyWith(
            inherit: true,
            color: theme.colorScheme.onPrimary,
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: widget.onTap,
            child: widget.child,
          ),
        ),
      ),
    );
  }
}

class SmallIconButton extends StatefulWidget {
  const SmallIconButton({super.key, required this.icon, required this.onTap});

  final Icon icon;

  final void Function() onTap;

  @override
  State<StatefulWidget> createState() => _SmallIconButtonState();
}

class _SmallIconButtonState extends State<SmallIconButton> {
  bool _isHovered = false;

  Color _color(ThemeData theme) {
    if (_isHovered) {
      return theme.hoverColor;
    } else {
      return Colors.transparent;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: _color(theme),
        shape: BoxShape.circle,
      ),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onHover: (_) => setState(() {_isHovered = true;}),
        onExit: (_) => setState(() {_isHovered = false;}),
        child: Material(
          type: MaterialType.transparency,
          textStyle: theme.textTheme.titleMedium?.copyWith(
            inherit: true,
            color: theme.colorScheme.onPrimary,
          ),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: widget.onTap,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: widget.icon,
            ),
          ),
        ),
      ),
    );
  }

}
