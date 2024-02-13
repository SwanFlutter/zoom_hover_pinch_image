import 'package:flutter/material.dart';

class HoverMouseRegion extends StatefulWidget {
  final Widget child;
  final double initialScale;
  final double zoomedScale;
  final double maxScale;

  const HoverMouseRegion({
    Key? key,
    required this.child,
    this.initialScale = 1.0,
    this.zoomedScale = 2.0,
    this.maxScale = 5.0,
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
            Transform.scale(
              scale: _scale,
              origin: _focalPoint,
              child: widget.child,
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
