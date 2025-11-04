// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart';

/// Zoom state manager to synchronize multiple zoom widgets
/// [ZoomManager] is used to manage zoom state across multiple widgets
/// It provides a unified interface for zoom operations
/// It can be used to synchronize zoom state across different widgets
class ZoomManager extends ChangeNotifier {
  /// Current scale factor
  double _scale;

  /// Current rotation in radians
  double _rotation;

  /// Current focal point
  Offset _focalPoint;

  /// Is currently zoomed
  bool _isZoomed;

  /// Minimum scale
  final double minScale;

  /// Maximum scale
  final double maxScale;

  /// Default scale when zoomed
  final double defaultZoomScale;

  ZoomManager({
    double initialScale = 1.0,
    double initialRotation = 0.0,
    Offset initialFocalPoint = Offset.zero,
    this.minScale = 1.0,
    this.maxScale = 4.0,
    this.defaultZoomScale = 2.0,
  }) : _scale = initialScale,
       _rotation = initialRotation,
       _focalPoint = initialFocalPoint,
       _isZoomed = initialScale > 1.0;

  /// Current scale getter
  double get scale => _scale;

  /// Current rotation getter
  double get rotation => _rotation;

  /// Current focal point getter
  Offset get focalPoint => _focalPoint;

  /// Is zoomed state getter
  bool get isZoomed => _isZoomed;

  /// Set new scale
  void setScale(double newScale) {
    newScale = newScale.clamp(minScale, maxScale);
    if (_scale != newScale) {
      _scale = newScale;
      _isZoomed = _scale > minScale;
      notifyListeners();
    }
  }

  /// Set new rotation
  void setRotation(double newRotation) {
    if (_rotation != newRotation) {
      _rotation = newRotation;
      notifyListeners();
    }
  }

  /// Set new focal point
  void setFocalPoint(Offset newFocalPoint) {
    if (_focalPoint != newFocalPoint) {
      _focalPoint = newFocalPoint;
      notifyListeners();
    }
  }

  /// Zoom in to specific point
  void zoomIn({Offset? focalPoint, double? scale}) {
    setFocalPoint(focalPoint ?? Offset.zero);
    setScale(scale ?? defaultZoomScale);
  }

  /// Zoom out
  void zoomOut() {
    setScale(minScale);
    setFocalPoint(Offset.zero);
    setRotation(0);
  }

  /// Toggle zoom state
  void toggleZoom({Offset? focalPoint, double? scale}) {
    if (_isZoomed) {
      zoomOut();
    } else {
      zoomIn(focalPoint: focalPoint, scale: scale);
    }
  }

  /// Reset all transformations
  void reset() {
    setScale(minScale);
    setRotation(0);
    setFocalPoint(Offset.zero);
  }

  /// Update all transformation parameters at once
  void updateTransformation({
    double? scale,
    double? rotation,
    Offset? focalPoint,
  }) {
    bool shouldNotify = false;

    if (scale != null && _scale != scale) {
      _scale = scale.clamp(minScale, maxScale);
      _isZoomed = _scale > minScale;
      shouldNotify = true;
    }

    if (rotation != null && _rotation != rotation) {
      _rotation = rotation;
      shouldNotify = true;
    }

    if (focalPoint != null && _focalPoint != focalPoint) {
      _focalPoint = focalPoint;
      shouldNotify = true;
    }

    if (shouldNotify) {
      notifyListeners();
    }
  }

  /// Apply the current transformation to a matrix
  Matrix4 get matrix4 {
    final Matrix4 matrix = Matrix4.identity()
      ..translateByVector3(Vector3(focalPoint.dx, focalPoint.dy, 0))
      ..rotateZ(rotation)
      ..scaleByDouble(scale, scale, 1.0, 1.0)
      ..translateByVector3(Vector3(-focalPoint.dx, -focalPoint.dy, 0));

    return matrix;
  }
}
