import 'package:flutter/material.dart';

/// [Pinch] Zoom and Clip functionality: Enables pinch-to-zoom interaction on the child widget while applying clipping behavior if specified.
/// Border radius customization: Allows you to specify the border radius for clipping the child widget.
/// By customizing these properties, you can control the minimum and maximum zoom levels,
/// aspect ratio, clipping behavior, and border radius, tailoring the interaction experience to your specific requirements.
class Pinch extends StatefulWidget {
  /// [child] (required Widget):
  /// This is the core widget that will be displayed and interacted with within the Pinch.
  /// It can be any valid Flutter widget that you want to apply pinch-to-zoom and clipping behavior to.
  final Widget child;

  /// [borderRadius] (optional BorderRadiusGeometry, defaults to BorderRadius.zero):
  /// Specifies the border radius for clipping the child widget.
  /// It allows you to customize the shape of the clipped region.
  final BorderRadiusGeometry borderRadius;

  /// [aspectRatio] (optional double, defaults to 1.0):
  /// Specifies the aspect ratio of the Pinch widget.
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
  /// Specifies the width of the Pinch in logical pixels.
  /// This value helps determine the area within which pinch-to-zoom interaction is tracked.
  final double? width;

  /// [height] (optional double, defaults to 250.0):
  /// Defines the height of the Pinch in logical pixels.
  /// Similar to width, it contributes to the area for tracking pinch-to-zoom interactions.
  final double? height;
  const Pinch({
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

  @override
  State<Pinch> createState() => _PinchState();
}

class _PinchState extends State<Pinch> with SingleTickerProviderStateMixin {
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
    super.dispose();
  }

  void restAnimation() {
    animation =
        Matrix4Tween(begin: controller.value, end: Matrix4.identity()).animate(
      CurvedAnimation(parent: animationController, curve: Curves.easeInOut),
    );
    animationController.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: InteractiveViewer(
        transformationController: controller,
        clipBehavior: widget.clipBehavior ? Clip.hardEdge : Clip.none,
        panEnabled: false,
        onInteractionEnd: (details) {
          restAnimation();
        },
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
