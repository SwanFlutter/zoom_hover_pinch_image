import 'package:flutter/material.dart';

class Hover extends StatefulWidget {
  final Widget child;
  final double initialScale;
  final double zoomedScale;
  const Hover({
    Key? key,
    required this.child,
    this.initialScale = 1.0,
    this.zoomedScale = 2.0,
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
        child: Transform.scale(
          scale: _scale,
          child: widget.child,
        ),
      ),
    );
  }
}
