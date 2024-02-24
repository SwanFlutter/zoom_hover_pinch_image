import 'package:flutter/material.dart';
import 'package:zoom_hover_pinch_image/src/widget/hover.dart';
import 'package:zoom_hover_pinch_image/src/widget/hover_mouse_region.dart';
import 'package:zoom_hover_pinch_image/src/widget/pinch.dart';
import 'package:zoom_hover_pinch_image/src/widget/zoom_on_tap.dart';

/// [Zoom] Zoom functionality: Enables pinch-to-zoom interaction on the child widget.
/// Border radius customization: Allows you to specify the border radius for clipping the child widget.
/// Aspect ratio customization: Specifies the aspect ratio of the widget.
/// Min and max scale limits: Sets the minimum and maximum allowed zoom levels for the child widget.
/// Clip behavior: Determines whether clipping behavior should be applied to the child widget.
/// By customizing these properties, you can control the zoom level, aspect ratio, clipping behavior,
/// and scale limits, tailoring the interaction experience to your specific requirements.
class Zoom extends StatefulWidget {
  /// [child] (required Widget):
  /// This is the core widget that will be displayed and interacted with within the Zoom.
  /// It can be any valid Flutter widget that you want to apply pinch-to-zoom behavior to.
  final Widget child;

  /// [borderRadius] (optional BorderRadiusGeometry, defaults to BorderRadius.zero):
  /// Specifies the border radius for clipping the child widget.
  /// It allows you to customize the shape of the clipped region.
  final BorderRadiusGeometry borderRadius;

  /// [aspectRatio] (optional double, defaults to 1.0):
  /// Specifies the aspect ratio of the Zoom widget.
  /// It determines the width-to-height ratio of the widget's bounding box.
  final double? aspectRatio;

  /// [minScale] (optional double, defaults to 1.0):
  /// Sets the minimum allowed zoom level for the child widget.
  /// Values less than 1.0 represent reduction in size.
  final double? minScale;

  /// [maxScale] (optional double, defaults to 4.0):
  /// Sets the maximum allowed zoom level for the child widget.
  /// Values greater than 1.0 represent magnification.
  final double? maxScale;

  /// [clipBehavior] (optional bool, defaults to true):
  /// Determines whether clipping behavior should be applied to the child widget.
  /// If true, the child widget will be clipped to the specified border radius.
  final bool clipBehavior;

  /// [width] (optional double, defaults to 250.0):
  /// Specifies the width of the Zoom in logical pixels.
  /// This value helps determine the area within which pinch-to-zoom interaction is tracked.
  final double? width;

  /// [height] (optional double, defaults to 250.0):
  /// Defines the height of the Zoom in logical pixels.
  /// Similar to width, it contributes to the area for tracking pinch-to-zoom interactions.
  final double? height;

  const Zoom({
    Key? key,
    required this.child,
    this.borderRadius = BorderRadius.zero,
    this.aspectRatio = 1.0,
    this.minScale = 1.0,
    this.maxScale = 4.0,
    this.clipBehavior = true,
    this.width = 250.0,
    this.height = 250.0,
  }) : super(key: key);

  static Widget zoomOnTap({
    /// [child] (required Widget):
    /// This is the core widget that will be displayed and interacted with within the ZoomOnTap.
    /// It can be any valid Flutter widget that you want to apply tap-to-zoom behavior to.
    required final Widget child,

    /// [zoomedScale] (optional double, defaults to 2.0):
    /// Defines the zoom level that the child widget scales to when tapped on.
    /// Values greater than 1.0 result in zooming in.
    final double zoomedScale = 2.0,

    /// [aspectRatio] (optional double, defaults to 1.0):
    /// Specifies the aspect ratio of the ZoomOnTap widget.
    /// It determines the width-to-height ratio of the widget's bounding box.
    final double? aspectRatio = 1.0,

    /// [clipBehavior] (optional bool, defaults to true):
    /// Determines whether clipping behavior should be applied to the child widget.
    /// If true, the child widget will be clipped to the bounding box of the ZoomOnTap widget.
    final bool clipBehavior = true,

    /// [oneTapZoom] (optional bool, defaults to false):
    /// Determines whether zooming should occur on a single tap event.
    /// If true, tapping on the widget will trigger zooming to the specified zoomedScale.
    final bool oneTapZoom = false,

    /// [doubleTapZoom] (optional bool, defaults to true):
    /// Determines whether zooming should occur on a double tap event.
    /// If true, double tapping on the widget will trigger zooming to the specified zoomedScale.
    final bool doubleTapZoom = true,

    /// [width] (optional double, defaults to 250.0):
    /// Specifies the width of the ZoomOnTap in logical pixels.
    /// This value helps determine the area within which tap events are tracked.
    final double? width = 250.0,

    /// [height] (optional double, defaults to 250.0):
    /// Defines the height of the ZoomOnTap in logical pixels.
    /// Similar to width, it contributes to the area for tracking tap events.
    final double? height = 250.0,
  }) {
    return ZoomOnTap(
      zoomedScale: zoomedScale,
      aspectRatio: aspectRatio,
      clipBehavior: clipBehavior,
      oneTapZoom: oneTapZoom,
      doubleTapZoom: doubleTapZoom,
      width: width,
      height: height,
      child: child,
    );
  }

  static Widget pinch({
    /// [child] (required Widget):
    /// This is the core widget that will be displayed and interacted with within the Pinch.
    /// It can be any valid Flutter widget that you want to apply pinch-to-zoom and clipping behavior to.
    required final Widget child,

    /// [borderRadius] (optional BorderRadiusGeometry, defaults to BorderRadius.zero):
    /// Specifies the border radius for clipping the child widget.
    /// It allows you to customize the shape of the clipped region.
    final BorderRadiusGeometry borderRadius = BorderRadius.zero,

    /// [aspectRatio] (optional double, defaults to 1.0):
    /// Specifies the aspect ratio of the Pinch widget.
    /// It determines the width-to-height ratio of the widget's bounding box.
    final double? aspectRatio = 1.0,

    /// [minScale] (optional double, defaults to 1.0):
    /// Sets the minimum allowed zoom level for the child widget.
    /// Values less than 1.0 represent reduction in size.
    final double? minScale = 1.0,

    /// [maxScale] (optional double, defaults to 4.0):
    /// Sets the maximum allowed zoom level for the child widget.
    /// Values greater than 1.0 represent magnification.
    final double? maxScale = 4.0,

    /// [clipBehavior] (optional bool, defaults to true):
    /// Determines whether clipping behavior should be applied to the child widget.
    /// If true, the child widget will be clipped to the specified border radius.
    final bool clipBehavior = true,

    /// [width] (optional double, defaults to 250.0):
    /// Specifies the width of the Pinch in logical pixels.
    /// This value helps determine the area within which pinch-to-zoom interaction is tracked.
    final double? width = 250.0,

    /// [height] (optional double, defaults to 250.0):
    /// Defines the height of the Pinch in logical pixels.
    /// Similar to width, it contributes to the area for tracking pinch-to-zoom interactions.
    final double? height = 250.0,
  }) {
    return Pinch(
      borderRadius: borderRadius,
      aspectRatio: aspectRatio,
      minScale: minScale,
      maxScale: maxScale,
      clipBehavior: clipBehavior,
      width: width,
      height: height,
      child: child,
    );
  }

  static Widget hoverMouseRegion({
    ///[child] (required Widget):
    ///This is the core widget that will be displayed and interacted with within the HoverMouseRegion.
    /// It can be any valid Flutter widget that you want to apply zoom and hover behavior to.
    required final Widget child,

    ///[initialScale] (optional double, defaults to 1.0):
    ///Sets the initial zoom level of the child widget when the HoverMouseRegion is first rendered.
    /// A value of 1.0 represents no zoom,
    /// while values greater than 1.0 indicate magnification.
    final double? initialScale = 1.0,

    ///[zoomedScale] (optional double, defaults to 2.0):
    ///Defines the zoom level that the child widget scales to when the user hovers over the HoverMouseRegion.
    ///Similar to initialScale, values greater than 1.0 result in zooming in.
    final double? zoomedScale = 2.0,

    /// [maxScale] (optional double, defaults to 5.0):
    ///Sets the maximum zoom level that the child widget can reach.
    /// This prevents excessive zooming and ensures a defined upper limit for magnification.
    final double? maxScale = 5.0,

    /// [width] (optional double, defaults to 250.0):
    ///Specifies the width of the HoverMouseRegion in logical pixels.
    /// This value helps determine the area within which mouse hover events are tracked.
    final double? width = 250,

    ///[height] (optional double, defaults to 250.0):
    ///Defines the height of the HoverMouseRegion in logical pixels.
    /// Similar to width, it contributes to the area for tracking mouse hover interactions.
    final double? height = 250,
  }) {
    return HoverMouseRegion(
      initialScale: initialScale!,
      zoomedScale: zoomedScale!,
      maxScale: maxScale!,
      width: width!,
      height: height!,
      child: child,
    );
  }

  static Widget hover({
    /// [child] (required Widget):
    /// This is the core widget that will be displayed and interacted with within the Hover.
    /// It can be any valid Flutter widget that you want to apply zoom and hover behavior to.
    required final Widget child,

    /// [initialScale] (optional double, defaults to 1.0):
    /// Sets the initial zoom level of the child widget when the Hover is first rendered.
    /// A value of 1.0 represents no zoom,
    /// while values greater than 1.0 indicate magnification.
    final double initialScale = 1.0,

    /// [zoomedScale] (optional double, defaults to 2.0):
    /// Defines the zoom level that the child widget scales to when the user hovers over the Hover.
    /// Similar to initialScale, values greater than 1.0 result in zooming in.
    final double zoomedScale = 2.0,

    /// [width] (optional double, defaults to 250.0):
    /// Specifies the width of the Hover in logical pixels.
    /// This value helps determine the area within which mouse hover events are tracked.
    final double? width = 250,

    /// [height] (optional double, defaults to 250.0):
    /// Defines the height of the Hover in logical pixels.
    /// Similar to width, it contributes to the area for tracking mouse hover interactions.
    final double? height = 250,
  }) {
    return Hover(
        initialScale: 1.0,
        zoomedScale: 2.0,
        width: width,
        height: height,
        child: child);
  }

  @override
  State<Zoom> createState() => _ZoomState();
}

class _ZoomState extends State<Zoom> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: InteractiveViewer(
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
      ),
    );
  }
}
