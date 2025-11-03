// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart';

/// Controller class for managing zoom functionality across different widgets
/// Provides a unified interface for zoom operations
class ZoomController extends TransformationController {
  /// Maximum allowed scale
  final double maxScale;

  /// Minimum allowed scale
  final double minScale;

  /// Duration for zoom animations
  final Duration animationDuration;

  /// Curve for zoom animations
  final Curve animationCurve;

  late AnimationController _animationController;
  Animation<Matrix4>? _animation;

  ZoomController({
    this.maxScale = 4.0,
    this.minScale = 1.0,
    this.animationDuration = const Duration(milliseconds: 300),
    this.animationCurve = Curves.easeInOut,
  });

  /// Initialize animation controller
  void initAnimationController(TickerProvider vsync) {
    _animationController = AnimationController(
      vsync: vsync,
      duration: animationDuration,
    )..addListener(() {
        if (_animation != null) {
          value = _animation!.value;
        }
      });
  }

  /// Dispose resources
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  /// Zoom to a specific point with scale
  void zoomToPoint(Offset focalPoint, double targetScale) {
    // Ensure scale is within bounds
    targetScale = targetScale.clamp(minScale, maxScale);

    // Calculate the focal point in the local coordinate system
    final x = -focalPoint.dx * (targetScale - 1);
    final y = -focalPoint.dy * (targetScale - 1);

    final zoomed = Matrix4.identity()
      ..translateByVector3(Vector3(x, y, 0))
      ..scaleByDouble(targetScale, targetScale, 1.0, 1.0);

    animateTo(zoomed);
  }

  /// Reset zoom to identity matrix (no zoom)
  void resetZoom() {
    animateTo(Matrix4.identity());
  }

  /// Toggle between zoomed state and normal state
  void toggleZoom(Offset focalPoint, double zoomedScale) {
    final end = value.isIdentity()
        ? _createZoomMatrix(focalPoint, zoomedScale)
        : Matrix4.identity();

    animateTo(end);
  }

  /// Animate to a specific transformation matrix
  void animateTo(Matrix4 targetMatrix) {
    _animation = Matrix4Tween(
      begin: value,
      end: targetMatrix,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: animationCurve,
      ),
    );

    _animationController.forward(from: 0);
  }

  /// Create a zoom matrix for a specific point and scale
  Matrix4 _createZoomMatrix(Offset focalPoint, double scale) {
    scale = scale.clamp(minScale, maxScale);
    final x = -focalPoint.dx * (scale - 1);
    final y = -focalPoint.dy * (scale - 1);

    return Matrix4.identity()
      ..translateByVector3(Vector3(x, y, 0))
      ..scaleByDouble(scale, scale, 1.0, 1.0);
  }

  /// Check if controller is at identity (no zoom)
  bool get isZoomed => !value.isIdentity();
}
