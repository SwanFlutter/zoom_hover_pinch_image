import 'package:flutter/material.dart';
import 'package:zoom_hover_pinch_image/zoom_hover_pinch_image.dart';

/// Enhanced Hover widget for smooth zoom on mouse hover
class Hover extends StatefulWidget {
  /// The widget to apply hover zoom functionality to
  final Widget child;

  /// Initial scale factor
  final double initialScale;

  /// Scale factor when hovered
  final double hoverScale;

  /// Container width
  final double? width;

  /// Container height
  final double? height;

  /// Animation duration for transitioning between states
  final Duration animationDuration;

  /// Animation curve for transitioning between states
  final Curve animationCurve;

  /// Whether to enable smooth focal point tracking
  final bool smoothTracking;

  /// Border radius for container
  final BorderRadius? borderRadius;

  /// Optional overlay widget to show on hover
  final Widget? hoverOverlay;

  /// Callback when hover state changes
  final void Function(bool isHovered)? onHoverChanged;

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

  const Hover({
    super.key,
    required this.child,
    this.initialScale = 1.0,
    this.hoverScale = 1.1,
    this.width = 250.0,
    this.height = 250.0,
    this.animationDuration = const Duration(milliseconds: 200),
    this.animationCurve = Curves.easeOutCubic,
    this.smoothTracking = true,
    this.borderRadius,
    this.hoverOverlay,
    this.zoomManager,
    this.onHoverChanged,
  });

  @override
  State<Hover> createState() => _HoverState();
}

class _HoverState extends State<Hover> with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  Offset _focalPoint = Offset.zero;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );

    _scaleAnimation = Tween<double>(
      begin: widget.initialScale,
      end: widget.hoverScale,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: widget.animationCurve,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleHoverChanged(bool isHovered) {
    if (_isHovered != isHovered) {
      setState(() {
        _isHovered = isHovered;
      });

      if (isHovered) {
        _controller.forward();
      } else {
        _controller.reverse();
      }

      widget.onHoverChanged?.call(isHovered);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _handleHoverChanged(true),
      onExit: (_) => _handleHoverChanged(false),
      onHover: widget.smoothTracking
          ? (event) {
              // Calculate relative position within the container
              setState(() {
                final size =
                    Size(widget.width ?? 250.0, widget.height ?? 250.0);
                _focalPoint = Offset(
                  (event.localPosition.dx / size.width) - 0.5,
                  (event.localPosition.dy / size.height) - 0.5,
                );
              });
            }
          : null,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Container(
            width: widget.width,
            height: widget.height,
            clipBehavior:
                widget.borderRadius != null ? Clip.antiAlias : Clip.none,
            decoration: BoxDecoration(
              borderRadius: widget.borderRadius,
            ),
            child: Stack(
              children: [
                // Main content with transform
                Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.001) // Perspective
                    ..scaleByDouble(
                        _scaleAnimation.value, _scaleAnimation.value, 1.0, 1.0)
                    ..rotateX(widget.smoothTracking ? _focalPoint.dy * 0.05 : 0)
                    ..rotateY(
                        widget.smoothTracking ? -_focalPoint.dx * 0.05 : 0),
                  child: widget.child,
                ),

                // Optional overlay with fade animation
                if (widget.hoverOverlay != null)
                  Positioned.fill(
                    child: FadeTransition(
                      opacity: _controller,
                      child: widget.hoverOverlay,
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
