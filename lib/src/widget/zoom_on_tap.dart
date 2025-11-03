import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart';
import 'package:zoom_hover_pinch_image/zoom_hover_pinch_image.dart';

/// [ZoomOnTap] Zoom functionality: Enables zooming in on the child widget when tapped on.
/// Aspect ratio customization: Allows you to specify the aspect ratio of the widget.
/// Clip behavior: Determines whether clipping behavior should be applied to the child widget.
/// One-tap and double-tap zoom options: Allows you to enable or disable zooming on one tap or double tap events.
/// By customizing these properties, you can control the zoom level, aspect ratio, clipping behavior, and tap behavior,
/// tailoring the interaction experience to your specific requirements.
class ZoomOnTap extends StatefulWidget {
  /// [child] (required Widget):
  /// This is the core widget that will be displayed and interacted with within the ZoomOnTap.
  /// It can be any valid Flutter widget that you want to apply tap-to-zoom behavior to.
  final Widget child;

  /// [zoomedScale] (optional double, defaults to 2.0):
  /// Defines the zoom level that the child widget scales to when tapped on.
  /// Values greater than 1.0 result in zooming in.
  final double zoomedScale;

  /// [aspectRatio] (optional double, defaults to 1.0):
  /// Specifies the aspect ratio of the ZoomOnTap widget.
  /// It determines the width-to-height ratio of the widget's bounding box.
  final double? aspectRatio;

  /// [clipBehavior] (optional bool, defaults to true):
  /// Determines whether clipping behavior should be applied to the child widget.
  /// If true, the child widget will be clipped to the bounding box of the ZoomOnTap widget.
  final bool clipBehavior;

  /// [oneTapZoom] (optional bool, defaults to false):
  /// Determines whether zooming should occur on a single tap event.
  /// If true, tapping on the widget will trigger zooming to the specified zoomedScale.
  final bool oneTapZoom;

  /// [doubleTapZoom] (optional bool, defaults to true):
  /// Determines whether zooming should occur on a double tap event.
  /// If true, double tapping on the widget will trigger zooming to the specified zoomedScale.
  final bool doubleTapZoom;

  /// [width] (optional double, defaults to 250.0):
  /// Specifies the width of the ZoomOnTap in logical pixels.
  /// This value helps determine the area within which tap events are tracked.
  final double? width;

  /// [height] (optional double, defaults to 250.0):
  /// Defines the height of the ZoomOnTap in logical pixels.
  /// Similar to width, it contributes to the area for tracking tap events.
  final double? height;

  /// [zoomManager] (required ZoomManager):
  /// The ZoomManager instance used to manage the zoom behavior.
  /// It provides methods for zooming in/out, toggling zoom state, and resetting transformations.
  /// This property is required and should be provided during widget initialization.
  ///  Example:
  /// ```dart
  ///   final zoomManager = ZoomManager();
  ///  Zoom(
  ///   zoomManager: zoomManager,
  ///  child: Image.asset('assets/image.jpg'),
  ///  );
  /// ```
  ///
  ///
  final ZoomManager? zoomManager;

  const ZoomOnTap({
    super.key,
    required this.child,
    this.zoomedScale = 2.0,
    this.aspectRatio = 1.0,
    this.clipBehavior = true,
    this.oneTapZoom = false,
    this.doubleTapZoom = true,
    this.width = 250.0,
    this.height = 250.0,
    this.zoomManager,
  });

  @override
  State<ZoomOnTap> createState() => _ZoomOnTapState();
}

class _ZoomOnTapState extends State<ZoomOnTap>
    with SingleTickerProviderStateMixin {
  late TransformationController controller;
  TapDownDetails? tapDownDetails;

  late AnimationController animationController;
  late Animation<Matrix4> animation;

  @override
  void initState() {
    super.initState();
    controller = TransformationController();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    )..addListener(() {
        controller.value = animation.value;
      });
  }

  @override
  void dispose() {
    controller.dispose();
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (TapDownDetails details) => tapDownDetails = details,
      onDoubleTapDown: (TapDownDetails details) => tapDownDetails = details,
      onTap: widget.doubleTapZoom
          ? null
          : () {
              final position = tapDownDetails!.localPosition;
              double scale = widget.zoomedScale;
              final x = -position.dx * (scale - 1);
              final y = -position.dy * (scale - 1);
              final zoomed = Matrix4.identity()
                ..translateByVector3(Vector3(x, y, 0))
                ..scaleByDouble(scale, scale, 1.0, 1.0);
              final end =
                  controller.value.isIdentity() ? zoomed : Matrix4.identity();
              animation = Matrix4Tween(
                begin: controller.value,
                end: end,
              ).animate(CurveTween(curve: Curves.easeInOut)
                  .animate(animationController));
              animationController.forward(from: 0);
            },
      onDoubleTap: widget.doubleTapZoom
          ? () {
              final position = tapDownDetails!.localPosition;
              double scale = widget.zoomedScale;
              final x = -position.dx * (scale - 1);
              final y = -position.dy * (scale - 1);
              final zoomed = Matrix4.identity()
                ..translateByVector3(Vector3(x, y, 0))
                ..scaleByDouble(scale, scale, 1.0, 1.0);
              final end =
                  controller.value.isIdentity() ? zoomed : Matrix4.identity();
              animation = Matrix4Tween(
                begin: controller.value,
                end: end,
              ).animate(CurveTween(curve: Curves.easeInOut)
                  .animate(animationController));
              animationController.forward(from: 0);
            }
          : null,
      child: SizedBox(
        width: widget.width,
        height: widget.height,
        child: InteractiveViewer(
          transformationController: controller,
          clipBehavior: widget.clipBehavior ? Clip.hardEdge : Clip.none,
          panEnabled: false,
          scaleEnabled: false,
          child: AspectRatio(
            aspectRatio: widget.aspectRatio!,
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
