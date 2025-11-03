import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';

/// Accessibility helper for zoom widgets
class AccessibilityHelper {
  /// Generate semantic label for zoom level
  static String getZoomLevelLabel(double scale) {
    final percentage = (scale * 100).round();
    if (percentage == 100) {
      return 'Normal size, 100 percent zoom';
    } else if (percentage < 100) {
      return 'Zoomed out to $percentage percent';
    } else {
      return 'Zoomed in to $percentage percent';
    }
  }
  
  /// Generate semantic hint for zoom actions
  static String getZoomHint({
    bool canZoomIn = true,
    bool canZoomOut = true,
    bool canPan = true,
    bool hasDoubleTap = true,
  }) {
    final actions = <String>[];
    
    if (hasDoubleTap) {
      actions.add('Double tap to zoom');
    }
    
    if (canZoomIn || canZoomOut) {
      actions.add('Pinch to zoom in or out');
    }
    
    if (canPan) {
      actions.add('Drag to move around');
    }
    
    return actions.join(', ');
  }
  
  /// Create semantic properties for zoom widget
  static SemanticsProperties createZoomSemantics({
    required double currentScale,
    required double minScale,
    required double maxScale,
    String? customLabel,
    String? customHint,
    VoidCallback? onIncrease,
    VoidCallback? onDecrease,
    VoidCallback? onReset,
  }) {
    return SemanticsProperties(
      label: customLabel ?? getZoomLevelLabel(currentScale),
      hint: customHint ?? getZoomHint(),
      value: '${(currentScale * 100).round()}%',
      increasedValue: currentScale < maxScale 
          ? '${((currentScale * 1.2).clamp(minScale, maxScale) * 100).round()}%'
          : null,
      decreasedValue: currentScale > minScale
          ? '${((currentScale / 1.2).clamp(minScale, maxScale) * 100).round()}%'
          : null,
      onIncrease: currentScale < maxScale ? onIncrease : null,
      onDecrease: currentScale > minScale ? onDecrease : null,
      onTap: onReset,
    );
  }
  
  /// Announce zoom level change to screen readers
  static void announceZoomChange(double scale, {String? customMessage}) {
    final message = customMessage ?? getZoomLevelLabel(scale);
    SemanticsService.announce(message, TextDirection.ltr);
  }
  
  /// Check if high contrast mode is enabled
  static bool isHighContrastEnabled(BuildContext context) {
    return MediaQuery.of(context).highContrast;
  }
  
  /// Check if animations should be reduced
  static bool shouldReduceAnimations(BuildContext context) {
    return MediaQuery.of(context).disableAnimations;
  }
  
  /// Get appropriate animation duration based on accessibility settings
  static Duration getAccessibleAnimationDuration(
    BuildContext context,
    Duration defaultDuration,
  ) {
    if (shouldReduceAnimations(context)) {
      return Duration.zero;
    }
    return defaultDuration;
  }
  
  /// Create accessible zoom controls
  static Widget createZoomControls({
    required double currentScale,
    required double minScale,
    required double maxScale,
    required VoidCallback onZoomIn,
    required VoidCallback onZoomOut,
    required VoidCallback onReset,
    Color? backgroundColor,
    Color? iconColor,
  }) {
    return Card(
      color: backgroundColor,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: currentScale < maxScale ? onZoomIn : null,
            icon: Icon(Icons.zoom_in, color: iconColor),
            tooltip: 'Zoom in',
          ),
          IconButton(
            onPressed: onReset,
            icon: Icon(Icons.zoom_out_map, color: iconColor),
            tooltip: 'Reset zoom',
          ),
          IconButton(
            onPressed: currentScale > minScale ? onZoomOut : null,
            icon: Icon(Icons.zoom_out, color: iconColor),
            tooltip: 'Zoom out',
          ),
        ],
      ),
    );
  }
  
  /// Create accessible zoom slider
  static Widget createZoomSlider({
    required double currentScale,
    required double minScale,
    required double maxScale,
    required ValueChanged<double> onChanged,
    String? label,
  }) {
    return Semantics(
      label: label ?? 'Zoom level slider',
      child: Slider(
        value: currentScale,
        min: minScale,
        max: maxScale,
        divisions: 20,
        label: '${(currentScale * 100).round()}%',
        onChanged: onChanged,
        semanticFormatterCallback: (double value) {
          return '${(value * 100).round()} percent zoom';
        },
      ),
    );
  }
  
  /// Handle keyboard shortcuts for zoom
  static Widget createKeyboardShortcuts({
    required Widget child,
    required VoidCallback onZoomIn,
    required VoidCallback onZoomOut,
    required VoidCallback onReset,
    required VoidCallback onFitToScreen,
  }) {
    return Shortcuts(
      shortcuts: {
        LogicalKeySet(LogicalKeyboardKey.equal): const ZoomInIntent(),
        LogicalKeySet(LogicalKeyboardKey.add): const ZoomInIntent(),
        LogicalKeySet(LogicalKeyboardKey.minus): const ZoomOutIntent(),
        LogicalKeySet(LogicalKeyboardKey.digit0): const ResetZoomIntent(),
        LogicalKeySet(LogicalKeyboardKey.keyF): const FitToScreenIntent(),
        LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.equal): const ZoomInIntent(),
        LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.add): const ZoomInIntent(),
        LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.minus): const ZoomOutIntent(),
        LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.digit0): const ResetZoomIntent(),
      },
      child: Actions(
        actions: {
          ZoomInIntent: CallbackAction<ZoomInIntent>(
            onInvoke: (_) => onZoomIn(),
          ),
          ZoomOutIntent: CallbackAction<ZoomOutIntent>(
            onInvoke: (_) => onZoomOut(),
          ),
          ResetZoomIntent: CallbackAction<ResetZoomIntent>(
            onInvoke: (_) => onReset(),
          ),
          FitToScreenIntent: CallbackAction<FitToScreenIntent>(
            onInvoke: (_) => onFitToScreen(),
          ),
        },
        child: Focus(
          autofocus: true,
          child: child,
        ),
      ),
    );
  }
  
  /// Create voice-over friendly description
  static String createVoiceOverDescription({
    required String contentType,
    required double currentScale,
    required Size? contentSize,
    bool isZoomable = true,
    bool isPannable = true,
  }) {
    final buffer = StringBuffer();
    
    buffer.write('$contentType');
    
    if (contentSize != null) {
      buffer.write(', ${contentSize.width.round()} by ${contentSize.height.round()} pixels');
    }
    
    buffer.write(', currently at ${(currentScale * 100).round()} percent zoom');
    
    if (isZoomable) {
      buffer.write(', zoomable');
    }
    
    if (isPannable) {
      buffer.write(', pannable');
    }
    
    return buffer.toString();
  }
  
  /// Provide haptic feedback for zoom actions
  static void provideZoomFeedback(ZoomFeedbackType type) {
    switch (type) {
      case ZoomFeedbackType.zoomIn:
      case ZoomFeedbackType.zoomOut:
        HapticFeedback.lightImpact();
        break;
      case ZoomFeedbackType.reset:
        HapticFeedback.mediumImpact();
        break;
      case ZoomFeedbackType.limitReached:
        HapticFeedback.heavyImpact();
        break;
      case ZoomFeedbackType.doubleTap:
        HapticFeedback.selectionClick();
        break;
    }
  }
}

/// Intent classes for keyboard shortcuts
class ZoomInIntent extends Intent {
  const ZoomInIntent();
}

class ZoomOutIntent extends Intent {
  const ZoomOutIntent();
}

class ResetZoomIntent extends Intent {
  const ResetZoomIntent();
}

class FitToScreenIntent extends Intent {
  const FitToScreenIntent();
}

/// Types of zoom feedback
enum ZoomFeedbackType {
  zoomIn,
  zoomOut,
  reset,
  limitReached,
  doubleTap,
}

/// Accessibility-aware zoom widget wrapper
class AccessibleZoom extends StatefulWidget {
  final Widget child;
  final double currentScale;
  final double minScale;
  final double maxScale;
  final ValueChanged<double>? onScaleChanged;
  final VoidCallback? onReset;
  final String? semanticLabel;
  final String? contentType;
  final Size? contentSize;
  final bool showControls;
  final bool enableKeyboardShortcuts;
  
  const AccessibleZoom({
    super.key,
    required this.child,
    required this.currentScale,
    required this.minScale,
    required this.maxScale,
    this.onScaleChanged,
    this.onReset,
    this.semanticLabel,
    this.contentType = 'Content',
    this.contentSize,
    this.showControls = false,
    this.enableKeyboardShortcuts = true,
  });
  
  @override
  State<AccessibleZoom> createState() => _AccessibleZoomState();
}

class _AccessibleZoomState extends State<AccessibleZoom> {
  void _zoomIn() {
    final newScale = (widget.currentScale * 1.2).clamp(widget.minScale, widget.maxScale);
    widget.onScaleChanged?.call(newScale);
    AccessibilityHelper.provideZoomFeedback(ZoomFeedbackType.zoomIn);
    AccessibilityHelper.announceZoomChange(newScale);
  }
  
  void _zoomOut() {
    final newScale = (widget.currentScale / 1.2).clamp(widget.minScale, widget.maxScale);
    widget.onScaleChanged?.call(newScale);
    AccessibilityHelper.provideZoomFeedback(ZoomFeedbackType.zoomOut);
    AccessibilityHelper.announceZoomChange(newScale);
  }
  
  void _reset() {
    widget.onReset?.call();
    AccessibilityHelper.provideZoomFeedback(ZoomFeedbackType.reset);
    AccessibilityHelper.announceZoomChange(1.0, customMessage: 'Reset to normal size');
  }
  
  void _fitToScreen() {
    // This would typically calculate the best fit scale
    widget.onScaleChanged?.call(1.0);
    AccessibilityHelper.announceZoomChange(1.0, customMessage: 'Fit to screen');
  }
  
  @override
  Widget build(BuildContext context) {
    Widget child = Semantics(
      label: widget.semanticLabel ?? AccessibilityHelper.createVoiceOverDescription(
        contentType: widget.contentType!,
        currentScale: widget.currentScale,
        contentSize: widget.contentSize,
      ),
      hint: AccessibilityHelper.getZoomHint(),
      value: '${(widget.currentScale * 100).round()}%',
      onIncrease: widget.currentScale < widget.maxScale ? _zoomIn : null,
      onDecrease: widget.currentScale > widget.minScale ? _zoomOut : null,
      onTap: _reset,
      child: widget.child,
    );
    
    if (widget.enableKeyboardShortcuts) {
      child = AccessibilityHelper.createKeyboardShortcuts(
        onZoomIn: _zoomIn,
        onZoomOut: _zoomOut,
        onReset: _reset,
        onFitToScreen: _fitToScreen,
        child: child,
      );
    }
    
    if (widget.showControls) {
      child = Stack(
        children: [
          child,
          Positioned(
            top: 16,
            left: 16,
            child: AccessibilityHelper.createZoomControls(
              currentScale: widget.currentScale,
              minScale: widget.minScale,
              maxScale: widget.maxScale,
              onZoomIn: _zoomIn,
              onZoomOut: _zoomOut,
              onReset: _reset,
            ),
          ),
        ],
      );
    }
    
    return child;
  }
}