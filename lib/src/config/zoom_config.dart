import 'package:flutter/material.dart';

/// Configuration class for zoom behavior and appearance
class ZoomConfig {
  /// Minimum allowed scale factor
  final double minScale;
  
  /// Maximum allowed scale factor
  final double maxScale;
  
  /// Initial scale factor
  final double initialScale;
  
  /// Animation duration for zoom transitions
  final Duration animationDuration;
  
  /// Animation curve for zoom transitions
  final Curve animationCurve;
  
  /// Whether to enable momentum scrolling
  final bool enableMomentum;
  
  /// Whether to enable double tap to zoom
  final bool enableDoubleTapZoom;
  
  /// Whether to enable pinch to zoom
  final bool enablePinchZoom;
  
  /// Whether to enable panning
  final bool enablePanning;
  
  /// Whether to constrain panning to content bounds
  final bool constrainPanning;
  
  /// Sensitivity for zoom gestures (0.1 to 2.0)
  final double zoomSensitivity;
  
  /// Sensitivity for pan gestures (0.1 to 2.0)
  final double panSensitivity;
  
  /// Whether to show zoom indicators
  final bool showZoomIndicators;
  
  /// Color for zoom indicators
  final Color indicatorColor;
  
  /// Whether to enable haptic feedback
  final bool enableHapticFeedback;

  const ZoomConfig({
    this.minScale = 0.5,
    this.maxScale = 4.0,
    this.initialScale = 1.0,
    this.animationDuration = const Duration(milliseconds: 300),
    this.animationCurve = Curves.easeInOut,
    this.enableMomentum = true,
    this.enableDoubleTapZoom = true,
    this.enablePinchZoom = true,
    this.enablePanning = true,
    this.constrainPanning = true,
    this.zoomSensitivity = 1.0,
    this.panSensitivity = 1.0,
    this.showZoomIndicators = false,
    this.indicatorColor = Colors.blue,
    this.enableHapticFeedback = true,
  }) : assert(minScale > 0, 'minScale must be positive'),
       assert(maxScale > minScale, 'maxScale must be greater than minScale'),
       assert(initialScale >= minScale && initialScale <= maxScale, 
              'initialScale must be between minScale and maxScale'),
       assert(zoomSensitivity >= 0.1 && zoomSensitivity <= 2.0,
              'zoomSensitivity must be between 0.1 and 2.0'),
       assert(panSensitivity >= 0.1 && panSensitivity <= 2.0,
              'panSensitivity must be between 0.1 and 2.0');

  /// Creates a copy of this config with the given fields replaced
  ZoomConfig copyWith({
    double? minScale,
    double? maxScale,
    double? initialScale,
    Duration? animationDuration,
    Curve? animationCurve,
    bool? enableMomentum,
    bool? enableDoubleTapZoom,
    bool? enablePinchZoom,
    bool? enablePanning,
    bool? constrainPanning,
    double? zoomSensitivity,
    double? panSensitivity,
    bool? showZoomIndicators,
    Color? indicatorColor,
    bool? enableHapticFeedback,
  }) {
    return ZoomConfig(
      minScale: minScale ?? this.minScale,
      maxScale: maxScale ?? this.maxScale,
      initialScale: initialScale ?? this.initialScale,
      animationDuration: animationDuration ?? this.animationDuration,
      animationCurve: animationCurve ?? this.animationCurve,
      enableMomentum: enableMomentum ?? this.enableMomentum,
      enableDoubleTapZoom: enableDoubleTapZoom ?? this.enableDoubleTapZoom,
      enablePinchZoom: enablePinchZoom ?? this.enablePinchZoom,
      enablePanning: enablePanning ?? this.enablePanning,
      constrainPanning: constrainPanning ?? this.constrainPanning,
      zoomSensitivity: zoomSensitivity ?? this.zoomSensitivity,
      panSensitivity: panSensitivity ?? this.panSensitivity,
      showZoomIndicators: showZoomIndicators ?? this.showZoomIndicators,
      indicatorColor: indicatorColor ?? this.indicatorColor,
      enableHapticFeedback: enableHapticFeedback ?? this.enableHapticFeedback,
    );
  }

  /// Default configuration for images
  static const ZoomConfig forImages = ZoomConfig(
    minScale: 0.5,
    maxScale: 5.0,
    enableDoubleTapZoom: true,
    enablePinchZoom: true,
    enablePanning: true,
    constrainPanning: true,
  );

  /// Default configuration for documents
  static const ZoomConfig forDocuments = ZoomConfig(
    minScale: 0.8,
    maxScale: 3.0,
    enableDoubleTapZoom: true,
    enablePinchZoom: true,
    enablePanning: true,
    constrainPanning: true,
    zoomSensitivity: 0.8,
  );

  /// Default configuration for maps
  static const ZoomConfig forMaps = ZoomConfig(
    minScale: 0.1,
    maxScale: 10.0,
    enableMomentum: true,
    enablePinchZoom: true,
    enablePanning: true,
    constrainPanning: false,
    zoomSensitivity: 1.2,
  );
}