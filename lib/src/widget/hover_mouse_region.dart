import 'package:flutter/material.dart';

///[HoverMouseRegion] Zoom functionality: Enables zooming in on the child widget when the user hovers over it.
///Hover behavior: Allows you to define custom actions or visual changes based on mouse hover events.
///By customizing these properties, you can control the initial zoom level, zoom behavior on hover,
/// and the maximum zoom allowed, tailoring the interaction experience to your specific requirements.
class HoverMouseRegion extends StatefulWidget {
  ///[child] (required Widget):
  ///This is the core widget that will be displayed and interacted with within the HoverMouseRegion.
  /// It can be any valid Flutter widget that you want to apply zoom and hover behavior to.
  final Widget child;

  ///[initialScale] (optional double, defaults to 1.0):
  ///Sets the initial zoom level of the child widget when the HoverMouseRegion is first rendered.
  /// A value of 1.0 represents no zoom,
  /// while values greater than 1.0 indicate magnification.
  final double initialScale;

  ///[zoomedScale] (optional double, defaults to 2.0):
  ///Defines the zoom level that the child widget scales to when the user hovers over the HoverMouseRegion.
  ///Similar to initialScale, values greater than 1.0 result in zooming in.
  final double zoomedScale;

  /// [maxScale] (optional double, defaults to 5.0):
  ///Sets the maximum zoom level that the child widget can reach.
  /// This prevents excessive zooming and ensures a defined upper limit for magnification.
  final double maxScale;

  /// [width] (optional double, defaults to 250.0):
  ///Specifies the width of the HoverMouseRegion in logical pixels.
  /// This value helps determine the area within which mouse hover events are tracked.
  final double? width;

  ///[height] (optional double, defaults to 250.0):
  ///Defines the height of the HoverMouseRegion in logical pixels.
  /// Similar to width, it contributes to the area for tracking mouse hover interactions.
  final double? height;
  const HoverMouseRegion({
    Key? key,
    required this.child,
    this.initialScale = 1.0,
    this.zoomedScale = 2.0,
    this.maxScale = 5.0,
    this.width = 250.0,
    this.height = 250.0,
  }) : super(key: key);

  @override
  State<HoverMouseRegion> createState() => _HoverMouseRegionState();
}

class _HoverMouseRegionState extends State<HoverMouseRegion> {
  double _scale = 1.0;
  Offset _focalPoint = Offset.zero;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onHover: (event) {
        setState(() {
          _scale = widget.zoomedScale;
          _focalPoint = event.localPosition;
        });
      },
      onExit: (event) {
        setState(() {
          _scale = widget.initialScale;
          _focalPoint = Offset.zero;
        });
      },
      child: GestureDetector(
        onScaleUpdate: (details) {
          _scale = (details.scale * _scale)
              .clamp(widget.initialScale, widget.maxScale);
        },
        onScaleEnd: (details) {
          setState(() {
            _scale = widget.initialScale;
          });
        },
        child: Stack(
          children: [
            // Image with zoom and focal point adjustments
            SizedBox(
              width: widget.width,
              height: widget.height,
              child: Transform.scale(
                scale: _scale,
                origin: _focalPoint,
                child: widget.child,
              ),
            ),
            // Transparent container for mouse events
            Container(
              color: Colors.transparent,
              // Adjust height to match image
            ),
          ],
        ),
      ),
    );
  }
}
