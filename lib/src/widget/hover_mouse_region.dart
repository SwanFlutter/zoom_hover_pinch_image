import 'package:flutter/material.dart';
import 'package:zoom_hover_pinch_image/zoom_hover_pinch_image.dart';

/// [HoverMouseRegion] Zoom functionality: Enables zooming in on the child widget when the user hovers over it.
/// Hover behavior: Allows you to define custom actions or visual changes based on mouse hover events.
/// By customizing these properties, you can control the initial zoom level, zoom behavior on hover,
/// and the maximum zoom allowed, tailoring the interaction experience to your specific requirements.
///
/// Example usage:
/// ```dart
/// HoverMouseRegion(
///   initialScale: 1.0,
///   zoomedScale: 2.0,
///   maxScale: 5.0,
///   width: 250.0,
///   height: 250.0,
///   hoverWidth: 300.0,
///   hoverHeight: 300.0,
///   child: Image.network('https://picsum.photos/200/300'),
/// );
/// ```
class HoverMouseRegion extends StatefulWidget {
  /// [child] (required Widget):
  /// This is the core widget that will be displayed and interacted with within the HoverMouseRegion.
  /// It can be any valid Flutter widget that you want to apply zoom and hover behavior to.
  final Widget child;

  /// [initialScale] (optional double, defaults to 1.0):
  /// Sets the initial zoom level of the child widget when the HoverMouseRegion is first rendered.
  /// A value of 1.0 represents no zoom,
  /// while values greater than 1.0 indicate magnification.
  final double initialScale;

  /// [zoomedScale] (optional double, defaults to 2.0):
  /// Defines the zoom level that the child widget scales to when the user hovers over the HoverMouseRegion.
  /// Similar to initialScale, values greater than 1.0 result in zooming in.
  final double zoomedScale;

  /// [maxScale] (optional double, defaults to 5.0):
  /// Sets the maximum zoom level that the child widget can reach.
  /// This prevents excessive zooming and ensures a defined upper limit for magnification.
  final double maxScale;

  /// [width] (optional double, defaults to 250.0):
  /// Specifies the width of the HoverMouseRegion in logical pixels.
  /// This value helps determine the area within which mouse hover events are tracked.
  final double? width;

  /// [height] (optional double, defaults to 250.0):
  /// Defines the height of the HoverMouseRegion in logical pixels.
  /// Similar to width, it contributes to the area for tracking mouse hover interactions.
  final double? height;

  /// [hoverWidth] (optional double):
  /// Specifies the width of the hover area in logical pixels.
  /// This value can be used to define a different hover area size compared to the initial width.
  final double? hoverWidth;

  /// [hoverHeight] (optional double):
  /// Defines the height of the hover area in logical pixels.
  /// This value can be used to define a different hover area size compared to the initial height.
  final double? hoverHeight;

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

  const HoverMouseRegion({
    super.key,
    required this.child,
    this.initialScale = 1.0,
    this.zoomedScale = 2.0,
    this.maxScale = 5.0,
    this.width = 250.0,
    this.height = 250.0,
    this.hoverWidth,
    this.hoverHeight,
    this.zoomManager,
  });

  @override
  State<HoverMouseRegion> createState() => _HoverMouseRegionState();
}

class _HoverMouseRegionState extends State<HoverMouseRegion>
    with SingleTickerProviderStateMixin {
  double scale = 1.0;
  Offset position = Offset.zero;
  Offset normalizedPosition = Offset.zero;
  final GlobalKey _containerKey = GlobalKey();
  bool isHovering = false;
  late AnimationController _animationController;
  late Animation<double> _widthAnimation;
  late Animation<double> _heightAnimation;

  @override
  void initState() {
    super.initState();
    scale = widget.initialScale;

    // اگر zoomManager ارائه شده باشد، از آن برای تنظیم مقدار اولیه استفاده می‌کنیم
    if (widget.zoomManager != null) {
      scale = widget.zoomManager!.scale;
      widget.zoomManager!.addListener(_updateFromZoomManager);
    }

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _updateAnimations();
  }

  @override
  void didUpdateWidget(HoverMouseRegion oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.width != widget.width ||
        oldWidget.height != widget.height ||
        oldWidget.hoverWidth != widget.hoverWidth ||
        oldWidget.hoverHeight != widget.hoverHeight) {
      _updateAnimations();
    }
    if (oldWidget.zoomManager != widget.zoomManager) {
      oldWidget.zoomManager?.removeListener(_updateFromZoomManager);
      widget.zoomManager?.addListener(_updateFromZoomManager);
    }
  }

  void _updateFromZoomManager() {
    if (widget.zoomManager != null) {
      setState(() {
        scale = widget.zoomManager!.scale;
      });
    }
  }

  void _updateAnimations() {
    final double targetWidth = widget.hoverWidth ?? widget.width!;
    final double targetHeight = widget.hoverHeight ?? widget.height!;

    _widthAnimation = Tween<double>(
      begin: widget.width!,
      end: targetWidth,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _heightAnimation = Tween<double>(
      begin: widget.height!,
      end: targetHeight,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
  }

  @override
  void dispose() {
    widget.zoomManager?.removeListener(_updateFromZoomManager);
    _animationController.dispose();
    super.dispose();
  }

  void _updatePosition(Offset localPosition) {
    if (_containerKey.currentContext != null) {
      final RenderBox box =
          _containerKey.currentContext!.findRenderObject() as RenderBox;
      final Size size = box.size;

      final double dx = (localPosition.dx / size.width) - 0.5;
      final double dy = (localPosition.dy / size.height) - 0.5;

      setState(() {
        normalizedPosition = Offset(dx, dy);
        position = localPosition;
      });
    }
  }

  void _updateZoomManagerScale(double newScale) {
    if (widget.zoomManager != null) {
      widget.zoomManager!.setScale(newScale);
    } else {
      setState(() {
        scale = newScale;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool hasCustomHoverSize =
        widget.hoverWidth != null || widget.hoverHeight != null;

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        final double currentWidth =
            hasCustomHoverSize ? _widthAnimation.value : widget.width!;
        final double currentHeight =
            hasCustomHoverSize ? _heightAnimation.value : widget.height!;

        return Container(
          key: _containerKey,
          width: currentWidth,
          height: currentHeight,
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            color: Colors.transparent,
          ),
          child: MouseRegion(
            onEnter: (event) {
              setState(() {
                isHovering = true;
              });
              _animationController.forward();
            },
            onHover: (event) {
              _updatePosition(event.localPosition);
              _updateZoomManagerScale(widget.zoomedScale);
              setState(() {
                isHovering = true;
              });
            },
            onExit: (event) {
              _updateZoomManagerScale(widget.initialScale);
              setState(() {
                normalizedPosition = Offset.zero;
                isHovering = false;
              });
              _animationController.reverse();
            },
            child: Stack(
              children: [
                Positioned.fill(
                  child: Transform.translate(
                    offset: Offset(
                      -normalizedPosition.dx * currentWidth * (scale - 1),
                      -normalizedPosition.dy * currentHeight * (scale - 1),
                    ),
                    child: Transform.scale(
                      scale: scale,
                      child: widget.child,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
