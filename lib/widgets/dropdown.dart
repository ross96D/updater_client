import 'package:flutter/material.dart';

class DropdownWidget extends StatefulWidget {
  const DropdownWidget({super.key, required this.child});

  final Widget child;

  @override
  _DropdownWidgetState createState() => _DropdownWidgetState();
}

class _DropdownWidgetState extends State<DropdownWidget> {
  bool _isExpanded = false;
  final double _containerWidth = 200;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Header
        GestureDetector(
          onTap: () => setState(() => _isExpanded = !_isExpanded),
          child: Container(
            color: Colors.red,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Test', style: TextStyle(fontSize: 16)),
                AnimatedRotation(
                  turns: _isExpanded ? 0.5 : 0,
                  duration: Duration(milliseconds: 200),
                  child: const Icon(Icons.arrow_drop_down, size: 24),
                ),
              ],
            ),
          ),
        ),
        // Dropdown content
        AnimatedCrossFade(
          duration: const Duration(milliseconds: 200),
          crossFadeState: _isExpanded
              ? CrossFadeState.showFirst
              : CrossFadeState.showSecond,
          firstChild: widget.child,
          secondChild: Container(height: 0),
          alignment: Alignment.topCenter,
          sizeCurve: Curves.easeInOut,
        ),
      ],
    );
  }
}
