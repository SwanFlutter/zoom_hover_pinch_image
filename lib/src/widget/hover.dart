import 'package:flutter/material.dart';

/// [Hover] Zoom functionality: Enables zooming in on the child widget when the user hovers over it.
/// Hover behavior: Allows you to define custom actions or visual changes based on mouse hover events.
/// By customizing these properties, you can control the initial zoom level, zoom behavior on hover,
/// and the maximum zoom allowed, tailoring the interaction experience to your specific requirements.
class Hover extends StatefulWidget {
  /// [child] (required Widget):
  /// This is the core widget that will be displayed and interacted with within the Hover.
  /// It can be any valid Flutter widget that you want to apply zoom and hover behavior to.
  final Widget child;

  /// [initialScale] (optional double, defaults to 1.0):
  /// Sets the initial zoom level of the child widget when the Hover is first rendered.
  /// A value of 1.0 represents no zoom,
  /// while values greater than 1.0 indicate magnification.
  final double initialScale;

  /// [zoomedScale] (optional double, defaults to 2.0):
  /// Defines the zoom level that the child widget scales to when the user hovers over the Hover.
  /// Similar to initialScale, values greater than 1.0 result in zooming in.
  final double zoomedScale;

  /// [width] (optional double, defaults to 250.0):
  /// Specifies the width of the Hover in logical pixels.
  /// This value helps determine the area within which mouse hover events are tracked.
  final double? width;

  /// [height] (optional double, defaults to 250.0):
  /// Defines the height of the Hover in logical pixels.
  /// Similar to width, it contributes to the area for tracking mouse hover interactions.
  final double? height;
  const Hover({
    Key? key,
    required this.child,
    this.initialScale = 1.0,
    this.zoomedScale = 2.0,
    this.width = 250.0,
    this.height = 250.0,
  }) : super(key: key);

  @override
  State<Hover> createState() => _HoverState();
}

class _HoverState extends State<Hover> {
  double _scale = 1.0;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      // Use MouseRegion for hover events
      onHover: (event) {
        setState(() {
          _scale = widget.zoomedScale; // Zoom on hover
        });
      },
      onExit: (event) {
        setState(() {
          _scale = widget.initialScale; // Reset on hover exit
        });
      },
      child: GestureDetector(
        onScaleUpdate: (details) {
          setState(() {
            _scale =
                details.scale.clamp(widget.initialScale, widget.zoomedScale);
          });
        },
        onScaleEnd: (details) {
          setState(() {
            _scale = widget.initialScale;
          });
        },
        child: SizedBox(
          width: widget.width,
          height: widget.height,
          child: Transform.scale(
            scale: _scale,
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
