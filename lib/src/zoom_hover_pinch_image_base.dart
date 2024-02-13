import 'package:flutter/material.dart';
import 'package:zoom_hover_pinch_image/src/widget/hover.dart';
import 'package:zoom_hover_pinch_image/src/widget/hover_mouse_region.dart';
import 'package:zoom_hover_pinch_image/src/widget/pinch.dart';
import 'package:zoom_hover_pinch_image/src/widget/zoom_on_tap.dart';

class Zoom extends StatefulWidget {
  final Widget child;
  final BorderRadiusGeometry borderRadius;
  final double? aspectRatio;
  final double? minScale;
  final double? maxScale;
  final bool clipBehavior;

  const Zoom({
    Key? key,
    required this.child,
    this.borderRadius = BorderRadius.zero,
    this.aspectRatio = 1.0,
    this.minScale = 1.0,
    this.maxScale = 4.0,
    this.clipBehavior = true,
  }) : super(key: key);

  static Widget zoomOnTap({
    required final Widget child,
    final double zoomedScale = 2.0,
    final double? aspectRatio = 1.0,
    final bool clipBehavior = true,
    final bool oneTapZoom = false,
    final bool doubleTapZoom = true,
  }) {
    return ZoomOnTap(
      zoomedScale: zoomedScale,
      aspectRatio: aspectRatio,
      clipBehavior: clipBehavior,
      oneTapZoom: oneTapZoom,
      doubleTapZoom: doubleTapZoom,
      child: child,
    );
  }

  static Widget pinch({
    required final Widget child,
    final BorderRadiusGeometry borderRadius = BorderRadius.zero,
    final double? aspectRatio = 1.0,
    final double? minScale = 1.0,
    final double? maxScale = 4.0,
    final bool clipBehavior = true,
  }) {
    return Pinch(
      borderRadius: borderRadius,
      aspectRatio: aspectRatio,
      minScale: minScale,
      maxScale: maxScale,
      clipBehavior: clipBehavior,
      child: child,
    );
  }

  static Widget hoverMouseRegion({
    required final Widget child,
    final double? initialScale = 1.0,
    final double? zoomedScale = 2.0,
    final double? maxScale = 5.0,
  }) {
    return HoverMouseRegion(
      initialScale: initialScale!,
      zoomedScale: zoomedScale!,
      maxScale: maxScale!,
      child: child,
    );
  }

  static Widget hover({
    required final Widget child,
    final double initialScale = 1.0,
    final double zoomedScale = 2.0,
  }) {
    return Hover(initialScale: 1.0, zoomedScale: 2.0, child: child);
  }

  @override
  State<Zoom> createState() => _ZoomState();
}

class _ZoomState extends State<Zoom> {
  @override
  Widget build(BuildContext context) {
    return InteractiveViewer(
      clipBehavior: widget.clipBehavior ? Clip.hardEdge : Clip.none,
      minScale: widget.minScale!,
      maxScale: widget.maxScale!,
      child: AspectRatio(
        aspectRatio: widget.aspectRatio!,
        child: ClipRRect(
          borderRadius: widget.borderRadius,
          child: widget.child,
        ),
      ),
    );
  }
}
