import 'package:flutter/material.dart';

class ResizableSplitWidget extends StatefulWidget {
  const ResizableSplitWidget({
    super.key,
    required this.leftChild,
    required this.rigthChild,
    this.minLeftWidth = 100.0,
    this.minRightWidth = 100.0,
  });

  final Widget leftChild;
  final Widget rigthChild;
  final double minLeftWidth;
  final double minRightWidth;

  @override
  State<ResizableSplitWidget> createState() => _ResizableSplitWidgetState();
}

class _ResizableSplitWidgetState extends State<ResizableSplitWidget> {
  double _leftWidth = 300; // Initial width for the left panel
  bool _isHover = false;
  bool _isDragging = false;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final totalWidth = constraints.maxWidth;
        final maxLeftWidth = totalWidth - 8 - widget.minRightWidth;

        // Ensure _leftWidth stays within valid bounds
        _leftWidth = _leftWidth.clamp(widget.minLeftWidth, maxLeftWidth);

        return MouseRegion(
          cursor: _isHover || _isDragging
              ? SystemMouseCursors.resizeLeftRight
              : MouseCursor.defer,
          child: Row(
            children: [
              // Left Panel
              SizedBox(
                width: _leftWidth,
                child: widget.leftChild,
              ),

              // Resizable Divider
              GestureDetector(
                onHorizontalDragUpdate: (details) {
                  setState(() {
                    _leftWidth = (_leftWidth + details.delta.dx)
                        .clamp(widget.minLeftWidth, maxLeftWidth);
                  });
                },
                onHorizontalDragStart: (_) =>
                    setState(() => _isDragging = true),
                onHorizontalDragEnd: (_) => setState(() => _isDragging = false),
                child: MouseRegion(
                  onEnter: (_) => setState(() => _isHover = true),
                  onExit: (_) => setState(() => _isHover = false),
                  cursor: SystemMouseCursors.resizeLeftRight,
                  child: const VerticalDivider(width: 2),
                ),
              ),

              // Right Panel (Expands to remaining space)
              Expanded(
                child: widget.rigthChild,
              ),
            ],
          ),
        );
      },
    );
  }
}
