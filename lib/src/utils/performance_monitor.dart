import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Performance monitoring utility for zoom operations
class PerformanceMonitor {
  static const String _tag = 'ZoomPerformance';
  static final Map<String, DateTime> _startTimes = {};
  static final Map<String, List<Duration>> _measurements = {};
  
  /// Start timing an operation
  static void startTiming(String operation) {
    if (!kDebugMode) return;
    _startTimes[operation] = DateTime.now();
  }
  
  /// End timing an operation and log the result
  static void endTiming(String operation) {
    if (!kDebugMode) return;
    
    final startTime = _startTimes[operation];
    if (startTime == null) return;
    
    final duration = DateTime.now().difference(startTime);
    _measurements.putIfAbsent(operation, () => []).add(duration);
    
    developer.log(
      'Operation "$operation" took ${duration.inMicroseconds}μs',
      name: _tag,
    );
    
    _startTimes.remove(operation);
  }
  
  /// Get average duration for an operation
  static Duration? getAverageDuration(String operation) {
    final measurements = _measurements[operation];
    if (measurements == null || measurements.isEmpty) return null;
    
    final totalMicroseconds = measurements
        .map((d) => d.inMicroseconds)
        .reduce((a, b) => a + b);
    
    return Duration(microseconds: totalMicroseconds ~/ measurements.length);
  }
  
  /// Get performance statistics
  static Map<String, Map<String, dynamic>> getStatistics() {
    final stats = <String, Map<String, dynamic>>{};
    
    for (final entry in _measurements.entries) {
      final operation = entry.key;
      final measurements = entry.value;
      
      if (measurements.isEmpty) continue;
      
      final durations = measurements.map((d) => d.inMicroseconds).toList();
      durations.sort();
      
      final min = durations.first;
      final max = durations.last;
      final avg = durations.reduce((a, b) => a + b) / durations.length;
      final median = durations.length % 2 == 0
          ? (durations[durations.length ~/ 2 - 1] + durations[durations.length ~/ 2]) / 2
          : durations[durations.length ~/ 2].toDouble();
      
      stats[operation] = {
        'count': measurements.length,
        'min_μs': min,
        'max_μs': max,
        'avg_μs': avg.round(),
        'median_μs': median.round(),
      };
    }
    
    return stats;
  }
  
  /// Clear all measurements
  static void clearMeasurements() {
    _measurements.clear();
    _startTimes.clear();
  }
  
  /// Log performance summary
  static void logSummary() {
    if (!kDebugMode) return;
    
    final stats = getStatistics();
    if (stats.isEmpty) {
      developer.log('No performance data available', name: _tag);
      return;
    }
    
    developer.log('Performance Summary:', name: _tag);
    for (final entry in stats.entries) {
      final operation = entry.key;
      final data = entry.value;
      developer.log(
        '$operation: ${data['count']} ops, avg: ${data['avg_μs']}μs, '
        'min: ${data['min_μs']}μs, max: ${data['max_μs']}μs',
        name: _tag,
      );
    }
  }
}

/// Mixin for widgets that want to monitor performance
mixin PerformanceMonitorMixin {
  void startPerformanceTimer(String operation) {
    PerformanceMonitor.startTiming('${runtimeType}_$operation');
  }
  
  void endPerformanceTimer(String operation) {
    PerformanceMonitor.endTiming('${runtimeType}_$operation');
  }
}

/// Performance-aware transformation controller
class PerformanceAwareTransformationController extends TransformationController {
  @override
  set value(Matrix4 newValue) {
    PerformanceMonitor.startTiming('matrix_transformation');
    super.value = newValue;
    PerformanceMonitor.endTiming('matrix_transformation');
  }
}

/// Frame rate monitor for smooth animations
class FrameRateMonitor {
  static const int _maxSamples = 60;
  static final List<Duration> _frameTimes = [];
  static DateTime? _lastFrameTime;
  
  /// Record a frame
  static void recordFrame() {
    if (!kDebugMode) return;
    
    final now = DateTime.now();
    if (_lastFrameTime != null) {
      final frameTime = now.difference(_lastFrameTime!);
      _frameTimes.add(frameTime);
      
      if (_frameTimes.length > _maxSamples) {
        _frameTimes.removeAt(0);
      }
    }
    _lastFrameTime = now;
  }
  
  /// Get current FPS
  static double getCurrentFPS() {
    if (_frameTimes.isEmpty) return 0.0;
    
    final avgFrameTime = _frameTimes
        .map((d) => d.inMicroseconds)
        .reduce((a, b) => a + b) / _frameTimes.length;
    
    return 1000000.0 / avgFrameTime; // Convert to FPS
  }
  
  /// Check if performance is good (>= 50 FPS)
  static bool isPerformanceGood() {
    return getCurrentFPS() >= 50.0;
  }
  
  /// Clear frame data
  static void clear() {
    _frameTimes.clear();
    _lastFrameTime = null;
  }
}