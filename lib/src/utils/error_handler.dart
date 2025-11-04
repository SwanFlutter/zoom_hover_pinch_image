import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Custom exception for zoom-related errors
class ZoomException implements Exception {
  final String message;
  final String? code;
  final dynamic originalError;
  final StackTrace? stackTrace;

  const ZoomException(
    this.message, {
    this.code,
    this.originalError,
    this.stackTrace,
  });

  @override
  String toString() {
    return 'ZoomException: $message${code != null ? ' (Code: $code)' : ''}';
  }
}

/// Error types for zoom operations
enum ZoomErrorType {
  invalidScale,
  invalidDimensions,
  matrixTransformation,
  animationFailure,
  memoryIssue,
  platformSpecific,
  unknown,
}

/// Error handler for zoom operations
class ZoomErrorHandler {
  static const String _tag = 'ZoomError';
  static final Map<ZoomErrorType, int> _errorCounts = {};
  static final List<ZoomError> _recentErrors = [];
  static const int _maxRecentErrors = 10;

  /// Handle an error and return a user-friendly message
  static String handleError(
    dynamic error, {
    StackTrace? stackTrace,
    ZoomErrorType? type,
    Map<String, dynamic>? context,
  }) {
    final zoomError = _createZoomError(error, stackTrace, type, context);
    _recordError(zoomError);
    _logError(zoomError);

    return _getUserFriendlyMessage(zoomError.type);
  }

  /// Create a ZoomError from various error types
  static ZoomError _createZoomError(
    dynamic error,
    StackTrace? stackTrace,
    ZoomErrorType? type,
    Map<String, dynamic>? context,
  ) {
    String message;
    ZoomErrorType errorType;

    if (error is ZoomException) {
      message = error.message;
      errorType = type ?? _inferErrorType(error.message);
    } else if (error is ArgumentError) {
      message = 'Invalid argument: ${error.message}';
      errorType = ZoomErrorType.invalidScale;
    } else if (error is RangeError) {
      message = 'Value out of range: ${error.message}';
      errorType = ZoomErrorType.invalidScale;
    } else if (error is StateError) {
      message = 'Invalid state: ${error.message}';
      errorType = ZoomErrorType.matrixTransformation;
    } else {
      message = error?.toString() ?? 'Unknown error occurred';
      errorType = type ?? ZoomErrorType.unknown;
    }

    return ZoomError(
      message: message,
      type: errorType,
      timestamp: DateTime.now(),
      stackTrace: stackTrace,
      context: context,
      originalError: error,
    );
  }

  /// Infer error type from message
  static ZoomErrorType _inferErrorType(String message) {
    final lowerMessage = message.toLowerCase();

    if (lowerMessage.contains('scale') || lowerMessage.contains('zoom')) {
      return ZoomErrorType.invalidScale;
    } else if (lowerMessage.contains('dimension') ||
        lowerMessage.contains('size')) {
      return ZoomErrorType.invalidDimensions;
    } else if (lowerMessage.contains('matrix') ||
        lowerMessage.contains('transform')) {
      return ZoomErrorType.matrixTransformation;
    } else if (lowerMessage.contains('animation')) {
      return ZoomErrorType.animationFailure;
    } else if (lowerMessage.contains('memory') ||
        lowerMessage.contains('allocation')) {
      return ZoomErrorType.memoryIssue;
    } else {
      return ZoomErrorType.unknown;
    }
  }

  /// Record error for analytics
  static void _recordError(ZoomError error) {
    _errorCounts[error.type] = (_errorCounts[error.type] ?? 0) + 1;

    _recentErrors.add(error);
    if (_recentErrors.length > _maxRecentErrors) {
      _recentErrors.removeAt(0);
    }
  }

  /// Log error for debugging
  static void _logError(ZoomError error) {
    if (kDebugMode) {
      developer.log(
        'Zoom Error: ${error.message}',
        name: _tag,
        error: error.originalError,
        stackTrace: error.stackTrace,
      );
    }
  }

  /// Get user-friendly error message
  static String _getUserFriendlyMessage(ZoomErrorType type) {
    switch (type) {
      case ZoomErrorType.invalidScale:
        return 'Invalid zoom level. Please try a different zoom value.';
      case ZoomErrorType.invalidDimensions:
        return 'Invalid image dimensions. Please check the image size.';
      case ZoomErrorType.matrixTransformation:
        return 'Zoom transformation failed. Resetting to default view.';
      case ZoomErrorType.animationFailure:
        return 'Zoom animation failed. The operation was completed instantly.';
      case ZoomErrorType.memoryIssue:
        return 'Not enough memory for zoom operation. Try closing other apps.';
      case ZoomErrorType.platformSpecific:
        return 'Platform-specific error occurred. Please try again.';
      case ZoomErrorType.unknown:
        return 'An unexpected error occurred. Please try again.';
    }
  }

  /// Get error statistics
  static Map<ZoomErrorType, int> getErrorCounts() {
    return Map.from(_errorCounts);
  }

  /// Get recent errors
  static List<ZoomError> getRecentErrors() {
    return List.from(_recentErrors);
  }

  /// Clear error history
  static void clearErrors() {
    _errorCounts.clear();
    _recentErrors.clear();
  }

  /// Check if there are frequent errors of a specific type
  static bool hasFrequentErrors(ZoomErrorType type, {int threshold = 5}) {
    return (_errorCounts[type] ?? 0) >= threshold;
  }

  /// Validate scale value and throw appropriate error
  static double validateScale(double scale, double min, double max) {
    if (scale.isNaN || scale.isInfinite) {
      throw const ZoomException(
        'Scale value is not a valid number',
        code: 'INVALID_SCALE_NAN',
      );
    }

    if (scale < min) {
      throw ZoomException(
        'Scale value $scale is below minimum $min',
        code: 'SCALE_BELOW_MIN',
      );
    }

    if (scale > max) {
      throw ZoomException(
        'Scale value $scale is above maximum $max',
        code: 'SCALE_ABOVE_MAX',
      );
    }

    return scale;
  }

  /// Safe matrix transformation with error handling
  static Matrix4? safeMatrixTransform(Matrix4 matrix, VoidCallback transform) {
    try {
      transform();
      return matrix;
    } catch (error, stackTrace) {
      handleError(
        error,
        stackTrace: stackTrace,
        type: ZoomErrorType.matrixTransformation,
      );
      return null;
    }
  }
}

/// Data class for zoom errors
class ZoomError {
  final String message;
  final ZoomErrorType type;
  final DateTime timestamp;
  final StackTrace? stackTrace;
  final Map<String, dynamic>? context;
  final dynamic originalError;

  const ZoomError({
    required this.message,
    required this.type,
    required this.timestamp,
    this.stackTrace,
    this.context,
    this.originalError,
  });

  @override
  String toString() {
    return 'ZoomError(type: $type, message: $message, timestamp: $timestamp)';
  }
}

/// Widget that provides error boundary for zoom operations
class ZoomErrorBoundary extends StatefulWidget {
  final Widget child;
  final Widget Function(ZoomError error)? errorBuilder;
  final void Function(ZoomError error)? onError;

  const ZoomErrorBoundary({
    super.key,
    required this.child,
    this.errorBuilder,
    this.onError,
  });

  @override
  State<ZoomErrorBoundary> createState() => _ZoomErrorBoundaryState();
}

class _ZoomErrorBoundaryState extends State<ZoomErrorBoundary> {
  ZoomError? _error;

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      return widget.errorBuilder?.call(_error!) ?? _buildDefaultErrorWidget();
    }

    return widget.child;
  }

  Widget _buildDefaultErrorWidget() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 48, color: Colors.red),
          const SizedBox(height: 16),
          Text('Zoom Error', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 8),
          Text(
            _error?.message ?? 'An error occurred',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _error = null;
              });
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}
