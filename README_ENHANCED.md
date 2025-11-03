# Zoom Hover Pinch Image - Enhanced Edition

A comprehensive Flutter package for implementing zoom, hover, and pinch interactions with professional features, accessibility support, and performance optimizations.

## 🚀 New Features

### Enhanced Zoom Widget
- **Professional Configuration**: Centralized configuration system with presets
- **Performance Monitoring**: Built-in performance tracking and optimization
- **Error Handling**: Robust error handling with user-friendly messages
- **Accessibility**: Full screen reader and keyboard navigation support
- **Haptic Feedback**: Tactile feedback for better user experience

### Key Improvements
- ✅ **Fixed deprecated methods** - All `scaleByDouble` calls updated
- ✅ **Professional error handling** - Graceful error recovery
- ✅ **Performance monitoring** - Real-time performance tracking
- ✅ **Accessibility support** - WCAG compliant interactions
- ✅ **Configurable presets** - Image, document, and map optimized settings
- ✅ **Enhanced documentation** - Comprehensive examples and guides

## 📦 Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  zoom_hover_pinch_image: ^1.0.0
  vector_math: ^2.1.4
```

## 🎯 Quick Start

### Basic Usage (Original API)
```dart
import 'package:zoom_hover_pinch_image/zoom_hover_pinch_image.dart';

Zoom(
  child: Image.asset('assets/image.jpg'),
  minScale: 0.5,
  maxScale: 3.0,
)
```

### Enhanced Usage (New API)
```dart
import 'package:zoom_hover_pinch_image/zoom_hover_pinch_image.dart';

EnhancedZoom(
  config: ZoomConfig.forImages(), // Optimized preset
  onZoomChanged: (scale) => print('Zoom: ${scale}x'),
  onZoomStart: () => print('Zoom started'),
  onZoomEnd: () => print('Zoom ended'),
  child: Image.network('https://example.com/image.jpg'),
)
```

## 🛠️ Configuration

### ZoomConfig Presets

```dart
// For images
ZoomConfig.forImages()

// For documents
ZoomConfig.forDocuments()

// For maps
ZoomConfig.forMaps()

// Custom configuration
ZoomConfig(
  minScale: 0.5,
  maxScale: 4.0,
  initialScale: 1.0,
  enableDoubleTapZoom: true,
  enablePinchZoom: true,
  enablePanning: true,
  showZoomIndicators: true,
  enableHapticFeedback: true,
  animationDuration: Duration(milliseconds: 300),
  animationCurve: Curves.easeOutCubic,
  zoomSensitivity: 1.0,
  panSensitivity: 1.0,
)
```

## ♿ Accessibility Features

### Screen Reader Support
```dart
AccessibleZoom(
  currentScale: _currentScale,
  minScale: 0.5,
  maxScale: 3.0,
  onScaleChanged: (scale) => setState(() => _currentScale = scale),
  contentType: 'Product image',
  showControls: true, // Shows zoom controls
  enableKeyboardShortcuts: true,
  child: YourWidget(),
)
```

### Keyboard Shortcuts
- `Ctrl + =` or `Ctrl + +`: Zoom in
- `Ctrl + -`: Zoom out  
- `Ctrl + 0`: Reset zoom
- `F`: Fit to screen

### Voice-Over Support
- Automatic semantic labels
- Zoom level announcements
- Action hints and instructions

## 📊 Performance Monitoring

### Enable Performance Tracking
```dart
// In debug mode, performance is automatically tracked
PerformanceMonitor.startTiming('zoom_operation');
// ... your zoom operation
PerformanceMonitor.endTiming('zoom_operation');

// Get statistics
final stats = PerformanceMonitor.getStatistics();
PerformanceMonitor.logSummary();
```

### Frame Rate Monitoring
```dart
// Monitor frame rate during animations
FrameRateMonitor.recordFrame();
final fps = FrameRateMonitor.getCurrentFPS();
final isSmooth = FrameRateMonitor.isPerformanceGood(); // >= 50 FPS
```

## 🚨 Error Handling

### Automatic Error Recovery
```dart
ZoomErrorBoundary(
  onError: (error) => print('Zoom error: ${error.message}'),
  errorBuilder: (error) => CustomErrorWidget(error),
  child: EnhancedZoom(
    config: ZoomConfig(),
    child: YourContent(),
  ),
)
```

### Error Types
- `invalidScale`: Invalid zoom level
- `invalidDimensions`: Invalid image dimensions
- `matrixTransformation`: Transformation errors
- `animationFailure`: Animation issues
- `memoryIssue`: Memory constraints
- `platformSpecific`: Platform-related errors

## 🎨 Advanced Examples

### Image Gallery with Zoom
```dart
EnhancedZoom(
  config: ZoomConfig.forImages().copyWith(
    showZoomIndicators: true,
    enableHapticFeedback: true,
  ),
  borderRadius: BorderRadius.circular(12),
  onZoomChanged: (scale) {
    // Update UI based on zoom level
    setState(() => _zoomLevel = scale);
  },
  child: Image.network(
    'https://picsum.photos/800/600',
    fit: BoxFit.cover,
  ),
)
```

### Document Viewer
```dart
EnhancedZoom(
  config: ZoomConfig.forDocuments(),
  semanticLabel: 'PDF Document Page 1',
  child: PdfPageWidget(),
)
```

### Interactive Map
```dart
EnhancedZoom(
  config: ZoomConfig.forMaps().copyWith(
    minScale: 0.1,
    maxScale: 10.0,
  ),
  child: InteractiveMap(),
)
```

## 🔧 Utilities

### Zoom Utilities
```dart
// Validate scale values
final validScale = ZoomUtils.validateScale(2.5, min: 0.5, max: 4.0);

// Calculate optimal scale for dimensions
final optimalScale = ZoomUtils.calculateOptimalScale(
  contentSize: Size(800, 600),
  containerSize: Size(400, 300),
);

// Smooth interpolation
final interpolated = ZoomUtils.lerp(1.0, 2.0, 0.5); // Returns 1.5
```

### Error Validation
```dart
try {
  final scale = ZoomErrorHandler.validateScale(value, min, max);
  // Use validated scale
} on ZoomException catch (e) {
  // Handle zoom-specific errors
  print('Zoom error: ${e.message}');
}
```

## 📱 Platform Support

- ✅ **iOS**: Full support with native gestures
- ✅ **Android**: Full support with native gestures  
- ✅ **Web**: Mouse wheel and touch support
- ✅ **Desktop**: Mouse and keyboard support
- ✅ **Accessibility**: Screen readers on all platforms

## 🧪 Testing

### Unit Tests
```dart
testWidgets('Enhanced zoom responds to gestures', (tester) async {
  double? capturedScale;
  
  await tester.pumpWidget(
    MaterialApp(
      home: EnhancedZoom(
        config: ZoomConfig(),
        onZoomChanged: (scale) => capturedScale = scale,
        child: Container(width: 100, height: 100),
      ),
    ),
  );
  
  // Test pinch gesture
  await tester.pinch(scale: 2.0);
  expect(capturedScale, equals(2.0));
});
```

## 🔄 Migration Guide

### From Original API to Enhanced API

**Before:**
```dart
Zoom(
  child: widget,
  minScale: 0.5,
  maxScale: 3.0,
  aspectRatio: 1.0,
)
```

**After:**
```dart
EnhancedZoom(
  config: ZoomConfig(
    minScale: 0.5,
    maxScale: 3.0,
  ),
  child: widget,
)
```

### Benefits of Migration
- Better performance monitoring
- Enhanced accessibility
- Improved error handling
- More configuration options
- Professional features

## 📈 Performance Tips

1. **Use appropriate presets**: Choose `ZoomConfig.forImages()`, `forDocuments()`, or `forMaps()`
2. **Monitor performance**: Enable performance monitoring in debug mode
3. **Optimize images**: Use appropriate image sizes and formats
4. **Reduce animations**: Disable animations for better performance on low-end devices
5. **Memory management**: Monitor memory usage with large images

## 🤝 Contributing

We welcome contributions! Please see our [Contributing Guide](CONTRIBUTING.md) for details.

### Development Setup
```bash
git clone https://github.com/your-repo/zoom_hover_pinch_image.git
cd zoom_hover_pinch_image
flutter pub get
cd example
flutter run
```

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Original package contributors
- Flutter community for feedback
- Accessibility consultants for guidance
- Performance optimization experts

## 📞 Support

- 📧 Email: support@example.com
- 🐛 Issues: [GitHub Issues](https://github.com/your-repo/zoom_hover_pinch_image/issues)
- 💬 Discussions: [GitHub Discussions](https://github.com/your-repo/zoom_hover_pinch_image/discussions)
- 📖 Documentation: [Full Documentation](https://docs.example.com)

---

Made with ❤️ for the Flutter community