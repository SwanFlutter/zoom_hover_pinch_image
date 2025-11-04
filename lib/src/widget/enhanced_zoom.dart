// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vector_math/vector_math_64.dart' hide Colors;

import '../config/zoom_config.dart';
import '../utils/zoom_utils.dart';

/// Enhanced zoom widget with professional features and optimizations
class EnhancedZoom extends StatefulWidget {
  /// The child widget to be zoomed
  final Widget child;

  /// Zoom configuration
  final ZoomConfig config;

  /// Border radius for clipping
  final BorderRadiusGeometry borderRadius;

  /// Clip behavior
  final Clip clipBehavior;

  /// Callback when zoom changes
  final ValueChanged<double>? onZoomChanged;

  /// Callback when pan changes
  final ValueChanged<Offset>? onPanChanged;

  /// Callback when zoom starts
  final VoidCallback? onZoomStart;

  /// Callback when zoom ends
  final VoidCallback? onZoomEnd;

  /// Whether to enable semantic labels for accessibility
  final bool enableSemantics;

  /// Custom semantic label
  final String? semanticLabel;

  const EnhancedZoom({
    super.key,
    required this.child,
    this.config = const ZoomConfig(),
    this.borderRadius = BorderRadius.zero,
    this.clipBehavior = Clip.hardEdge,
    this.onZoomChanged,
    this.onPanChanged,
    this.onZoomStart,
    this.onZoomEnd,
    this.enableSemantics = true,
    this.semanticLabel,
  });

  @override
  State<EnhancedZoom> createState() => _EnhancedZoomState();
}

class _EnhancedZoomState extends State<EnhancedZoom>
    with TickerProviderStateMixin {
  late TransformationController _controller;
  late AnimationController _animationController;
  late Animation<Matrix4> _animation;

  double _currentScale = 1.0;
  Offset _currentPan = Offset.zero;
  bool _isZooming = false;

  @override
  void initState() {
    super.initState();
    _controller = TransformationController();
    _animationController = AnimationController(
      duration: widget.config.animationDuration,
      vsync: this,
    );

    _currentScale = widget.config.initialScale;
    _controller.addListener(_onTransformationChanged);

    // Set initial scale if different from 1.0
    if (widget.config.initialScale != 1.0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _setScale(widget.config.initialScale);
      });
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onTransformationChanged);
    _controller.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _onTransformationChanged() {
    final matrix = _controller.value;
    final scale = matrix.getMaxScaleOnAxis();
    final translation = matrix.getTranslation();

    if (_currentScale != scale) {
      _currentScale = scale;
      widget.onZoomChanged?.call(scale);
    }

    final pan = Offset(translation.x, translation.y);
    if (_currentPan != pan) {
      _currentPan = pan;
      widget.onPanChanged?.call(pan);
    }
  }

  void _setScale(double scale, {Offset? focalPoint}) {
    scale = ZoomUtils.validateScale(
      scale,
      min: widget.config.minScale,
      max: widget.config.maxScale,
    );

    final center = focalPoint ?? Offset.zero;
    final matrix = Matrix4.identity()
      ..translateByVector3(Vector3(center.dx, center.dy, 0))
      ..scaleByDouble(scale, scale, 1.0, 1.0)
      ..translateByVector3(Vector3(-center.dx, -center.dy, 0));

    _animateToMatrix(matrix);
  }

  void _animateToMatrix(Matrix4 targetMatrix) {
    _animation = Matrix4Tween(begin: _controller.value, end: targetMatrix)
        .animate(
          CurvedAnimation(
            parent: _animationController,
            curve: widget.config.animationCurve,
          ),
        );

    _animation.addListener(() {
      _controller.value = _animation.value;
    });

    _animationController.forward(from: 0);
  }

  void _handleDoubleTap(TapDownDetails details) {
    if (!widget.config.enableDoubleTapZoom) return;

    if (widget.config.enableHapticFeedback) {
      HapticFeedback.lightImpact();
    }

    final isZoomedIn = _currentScale > widget.config.initialScale;
    final targetScale = isZoomedIn
        ? widget.config.initialScale
        : widget.config.maxScale * 0.7;

    _setScale(targetScale, focalPoint: details.localPosition);
  }

  void _handleScaleStart(ScaleStartDetails details) {
    if (!_isZooming) {
      _isZooming = true;
      widget.onZoomStart?.call();

      if (widget.config.enableHapticFeedback) {
        HapticFeedback.selectionClick();
      }
    }
  }

  void _handleScaleUpdate(ScaleUpdateDetails details) {
    if (!widget.config.enablePinchZoom && details.scale != 1.0) return;
    if (!widget.config.enablePanning &&
        details.focalPointDelta != Offset.zero) {
      return;
    }

    final scale = details.scale * widget.config.zoomSensitivity;
    final pan = details.focalPointDelta * widget.config.panSensitivity;

    // Apply scale constraints
    final currentMatrix = _controller.value;
    final currentScale = currentMatrix.getMaxScaleOnAxis();
    final newScale = ZoomUtils.validateScale(
      currentScale * scale,
      min: widget.config.minScale,
      max: widget.config.maxScale,
    );

    // Create transformation matrix
    final matrix = Matrix4.identity()
      ..translateByVector3(Vector3(pan.dx, pan.dy, 0))
      ..scaleByDouble(
        newScale / currentScale,
        newScale / currentScale,
        1.0,
        1.0,
      );

    _controller.value = currentMatrix * matrix;
  }

  void _handleScaleEnd(ScaleEndDetails details) {
    if (_isZooming) {
      _isZooming = false;
      widget.onZoomEnd?.call();
    }
  }

  Widget _buildZoomIndicator() {
    if (!widget.config.showZoomIndicators) return const SizedBox.shrink();

    return Positioned(
      top: 16,
      right: 16,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: widget.config.indicatorColor.withValues(alpha: 0.8),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          '${(_currentScale * 100).toInt()}%',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget zoomWidget = GestureDetector(
      onDoubleTapDown: _handleDoubleTap,
      child: InteractiveViewer(
        transformationController: _controller,
        minScale: widget.config.minScale,
        maxScale: widget.config.maxScale,
        onInteractionStart: _handleScaleStart,
        onInteractionUpdate: _handleScaleUpdate,
        onInteractionEnd: _handleScaleEnd,
        clipBehavior: widget.clipBehavior,
        child: widget.child,
      ),
    );

    // Add clipping if border radius is specified
    if (widget.borderRadius != BorderRadius.zero) {
      zoomWidget = ClipRRect(
        borderRadius: widget.borderRadius,
        clipBehavior: widget.clipBehavior,
        child: zoomWidget,
      );
    }

    // Add zoom indicator
    zoomWidget = Stack(children: [zoomWidget, _buildZoomIndicator()]);

    // Add semantics for accessibility
    if (widget.enableSemantics) {
      zoomWidget = Semantics(
        label: widget.semanticLabel ?? 'Zoomable content',
        hint: 'Double tap to zoom, pinch to zoom in or out, drag to pan',
        child: zoomWidget,
      );
    }

    return zoomWidget;
  }

  /// Public method to programmatically zoom to a specific scale
  void zoomTo(double scale, {Offset? focalPoint}) {
    _setScale(scale, focalPoint: focalPoint);
  }

  /// Public method to reset zoom to initial state
  void resetZoom() {
    _setScale(widget.config.initialScale);
  }

  /// Public method to get current zoom level
  double get currentZoom => _currentScale;

  /// Public method to get current pan offset
  Offset get currentPan => _currentPan;
}
