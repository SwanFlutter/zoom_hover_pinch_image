import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zoom_hover_pinch_image/zoom_hover_pinch_image.dart';

void main() {
  group('Zoom Widget Tests', () {
    test('creates zoom widget with default properties', () {
      const child = Text('hello');
      const zoom = Zoom(child: child);

      expect(zoom.aspectRatio, 1.0);
      expect(zoom.child, child);
      expect(zoom.clipBehavior, true);
      expect(zoom.borderRadius, BorderRadius.zero);
      expect(zoom.minScale, 1.0);
      expect(zoom.maxScale, 4.0);
      expect(zoom.width, 250.0);
      expect(zoom.height, 250.0);
    });

    test('creates zoom widget with custom properties', () {
      const child = Text('test');
      const zoom = Zoom(
        aspectRatio: 2.0,
        minScale: 0.5,
        maxScale: 3.0,
        clipBehavior: false,
        width: 300.0,
        height: 200.0,
        child: child,
      );

      expect(zoom.aspectRatio, 2.0);
      expect(zoom.child, child);
      expect(zoom.minScale, 0.5);
      expect(zoom.maxScale, 3.0);
      expect(zoom.clipBehavior, false);
      expect(zoom.width, 300.0);
      expect(zoom.height, 200.0);
    });
  });

  group('ZoomConfig Tests', () {
    test('creates default zoom config', () {
      const config = ZoomConfig();

      expect(config.minScale, 0.5);
      expect(config.maxScale, 4.0);
      expect(config.initialScale, 1.0);
      expect(config.enableDoubleTapZoom, true);
      expect(config.enablePinchZoom, true);
      expect(config.enablePanning, true);
      expect(config.enableMomentum, true);
      expect(config.constrainPanning, true);
    });

    test('creates image preset config', () {
      const config = ZoomConfig.forImages;

      expect(config.minScale, 0.5);
      expect(config.maxScale, 5.0);
      expect(config.enableDoubleTapZoom, true);
      expect(config.enablePinchZoom, true);
      expect(config.enablePanning, true);
      expect(config.constrainPanning, true);
    });

    test('creates document preset config', () {
      const config = ZoomConfig.forDocuments;

      expect(config.minScale, 0.8);
      expect(config.maxScale, 3.0);
      expect(config.enablePanning, true);
      expect(config.zoomSensitivity, 0.8);
    });

    test('creates map preset config', () {
      const config = ZoomConfig.forMaps;

      expect(config.minScale, 0.1);
      expect(config.maxScale, 10.0);
      expect(config.enablePanning, true);
      expect(config.constrainPanning, false);
      expect(config.zoomSensitivity, 1.2);
    });

    test('copyWith works correctly', () {
      const original = ZoomConfig();
      final modified = original.copyWith(
        minScale: 0.3,
        maxScale: 6.0,
        enableDoubleTapZoom: false,
      );

      expect(modified.minScale, 0.3);
      expect(modified.maxScale, 6.0);
      expect(modified.enableDoubleTapZoom, false);
      expect(modified.enablePinchZoom, original.enablePinchZoom); // Unchanged
    });
  });

  group('ZoomUtils Tests', () {
    test('validates scale correctly', () {
      expect(ZoomUtils.validateScale(1.5, min: 1.0, max: 2.0), 1.5);
      expect(ZoomUtils.validateScale(0.5, min: 1.0, max: 2.0), 1.0);
      expect(ZoomUtils.validateScale(3.0, min: 1.0, max: 2.0), 2.0);
    });

    test('validates aspect ratio correctly', () {
      expect(ZoomUtils.validateAspectRatio(1.5), 1.5);
      expect(ZoomUtils.validateAspectRatio(2.0), 2.0);
      expect(ZoomUtils.validateAspectRatio(null), 1.0);
    });

    test('validates dimensions correctly', () {
      expect(ZoomUtils.validateDimension(100.0, 1.0), 100.0);
      expect(ZoomUtils.validateDimension(250.0, 1.0), 250.0);
      expect(ZoomUtils.validateDimension(null, 250.0), 250.0);
    });

    test('calculates fit scale correctly', () {
      final scale = ZoomUtils.calculateFitScale(800, 600, 400, 300);
      expect(scale, 0.5); // Should fit the content in container
    });

    test('lerp works correctly', () {
      expect(ZoomUtils.lerp(1.0, 2.0, 0.0), 1.0);
      expect(ZoomUtils.lerp(1.0, 2.0, 1.0), 2.0);
      expect(ZoomUtils.lerp(1.0, 2.0, 0.5), 1.5);
    });

    test('easeInOut works correctly', () {
      expect(ZoomUtils.easeInOut(0.0), 0.0);
      expect(ZoomUtils.easeInOut(1.0), 1.0);
      expect(ZoomUtils.easeInOut(0.5), 0.5);
    });
  });
}
