/// MIT License
///
/// Copyright (c) 2023 Mantresh Khurana
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in all
/// copies or substantial portions of the Software.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
/// SOFTWARE.

import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';

extension FPS on Duration {
  double get fps => (1000 / inMilliseconds);
}

/// A widget that shows the current FPS.
class ShowFPS extends StatefulWidget {
  /// Where the [ShowFPS] should be positioned.
  final Alignment alignment;

  /// Whether to show the [ShowFPS].
  /// ```dart
  /// ShowFPS(
  ///   visible: !kReleaseMode,
  ///   child: MyHomePage(),
  /// )
  /// ```
  final bool visible;

  /// Will the [ShowFPS] show the chart.
  final bool showChart;

  /// Where the [ShowFPS] should be assigned with a main widget to monitor.
  final Widget child;

  /// The border radius of the [ShowFPS].
  final BorderRadius borderRadius;

  const ShowFPS({
    Key? key,
    this.alignment = Alignment.topRight,
    this.visible = true,
    this.showChart = true,
    this.borderRadius = const BorderRadius.all(Radius.circular(11)),
    required this.child,
  }) : super(key: key);

  @override
  ShowFPSState createState() => ShowFPSState();
}

class ShowFPSState extends State<ShowFPS> {
  Duration? previous;
  List<Duration> timings = [];
  double width = 50;
  double height = 30;
  double chartWidth = 150;
  double chartHeight = 80;
  late int framesToDisplay = chartWidth ~/ 5;

  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback(update);
    super.initState();
  }

  update(Duration duration) {
    if (!mounted || !widget.visible) {
      return;
    }

    setState(() {
      if (previous != null) {
        timings.add(duration - previous!);
        if (timings.length > framesToDisplay) {
          timings = timings.sublist(timings.length - framesToDisplay - 1);
        }
      }

      previous = duration;
    });

    SchedulerBinding.instance.addPostFrameCallback(update);
  }

  @override
  void didUpdateWidget(covariant ShowFPS oldWidget) {
    if (oldWidget.visible && !widget.visible) {
      previous = null;
    }

    if (!oldWidget.visible && widget.visible) {
      SchedulerBinding.instance.addPostFrameCallback(update);
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: widget.alignment,
      children: [
        widget.child,
        if (widget.visible)
          widget.showChart == true
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: chartHeight,
                    width: chartWidth + 17,
                    padding: const EdgeInsets.all(6.0),
                    decoration: BoxDecoration(
                      color: const Color(0xaa000000),
                      borderRadius: widget.borderRadius,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (timings.isNotEmpty)
                          Text(
                            'FPS: ${timings.last.fps.toStringAsFixed(0)}',
                            style: const TextStyle(
                              color: Color(0xffffffff),
                              fontSize: 14,
                            ),
                          ),
                        const SizedBox(height: 4),
                        Expanded(
                          child: SizedBox(
                            width: chartWidth,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                ...timings.map((timing) {
                                  final p = (timing.fps / 60).clamp(0.0, 1.0);

                                  return Padding(
                                    padding: const EdgeInsets.only(
                                      right: 1.0,
                                    ),
                                    child: Container(
                                      width: 4,
                                      height: p * chartHeight,
                                      decoration: BoxDecoration(
                                        color: Color.lerp(
                                          const Color(0xfff44336),
                                          const Color.fromARGB(
                                              255, 0, 162, 255),
                                          p,
                                        ),
                                        borderRadius: BorderRadius.circular(2),
                                      ),
                                    ),
                                  );
                                })
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: height,
                    width: width + 17,
                    padding: const EdgeInsets.all(6.0),
                    decoration: BoxDecoration(
                      color: const Color(0xaa000000),
                      borderRadius: widget.borderRadius,
                    ),
                    child: timings.isNotEmpty
                        ? Text(
                            'FPS: ${timings.last.fps.toStringAsFixed(0)}',
                            style: const TextStyle(
                              color: Color(0xffffffff),
                              fontSize: 14,
                            ),
                          )
                        : Container(),
                  ),
                ),
      ],
    );
  }
}
