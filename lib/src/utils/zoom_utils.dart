import 'package:flutter/foundation.dart';

/// Utility class for zoom-related calculations and validations
class ZoomUtils {
  /// Validates scale values to ensure they are within reasonable bounds
  static double validateScale(
    double scale, {
    double min = 0.1,
    double max = 10.0,
  }) {
    assert(min > 0, 'Minimum scale must be greater than 0');
    assert(max > min, 'Maximum scale must be greater than minimum scale');

    if (scale < min) {
      if (kDebugMode) {
        print(
          'Warning: Scale $scale is below minimum $min, clamping to minimum',
        );
      }
      return min;
    }

    if (scale > max) {
      if (kDebugMode) {
        print(
          'Warning: Scale $scale is above maximum $max, clamping to maximum',
        );
      }
      return max;
    }

    return scale;
  }

  /// Validates aspect ratio to ensure it's positive
  static double validateAspectRatio(double? aspectRatio) {
    if (aspectRatio == null) return 1.0;

    assert(aspectRatio > 0, 'Aspect ratio must be positive');

    if (aspectRatio <= 0) {
      if (kDebugMode) {
        print('Warning: Invalid aspect ratio $aspectRatio, using default 1.0');
      }
      return 1.0;
    }

    return aspectRatio;
  }

  /// Validates dimensions to ensure they are positive
  static double validateDimension(double? dimension, double defaultValue) {
    if (dimension == null) return defaultValue;

    assert(dimension > 0, 'Dimension must be positive');

    if (dimension <= 0) {
      if (kDebugMode) {
        print(
          'Warning: Invalid dimension $dimension, using default $defaultValue',
        );
      }
      return defaultValue;
    }

    return dimension;
  }

  /// Calculates the optimal scale for fitting content within bounds
  static double calculateFitScale(
    double contentWidth,
    double contentHeight,
    double containerWidth,
    double containerHeight,
  ) {
    final scaleX = containerWidth / contentWidth;
    final scaleY = containerHeight / contentHeight;
    return scaleX < scaleY ? scaleX : scaleY;
  }

  /// Interpolates between two values with easing
  static double lerp(double a, double b, double t) {
    return a + (b - a) * t;
  }

  /// Applies easing curve to a value
  static double easeInOut(double t) {
    return t < 0.5 ? 2 * t * t : -1 + (4 - 2 * t) * t;
  }
}
