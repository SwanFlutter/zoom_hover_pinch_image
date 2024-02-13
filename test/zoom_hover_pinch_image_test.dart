import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zoom_hover_pinch_image/zoom_hover_pinch_image.dart';

void main() {
  test('adds one to input values', () {
    const calculator = Zoom(
      child: Text('hello'),
    );
    expect(calculator.aspectRatio, 1.0);
    expect(calculator.child, const Text('hello'));
    expect(calculator.clipBehavior, false);
  });
}
