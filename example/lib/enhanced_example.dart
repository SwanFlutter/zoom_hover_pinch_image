import 'package:flutter/material.dart';
import 'package:zoom_hover_pinch_image/zoom_hover_pinch_image.dart';

class EnhancedExampleApp extends StatelessWidget {
  const EnhancedExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Enhanced Zoom Example',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: const ExampleHomePage(),
    );
  }
}

class ExampleHomePage extends StatefulWidget {
  const ExampleHomePage({super.key});

  @override
  State<ExampleHomePage> createState() => _ExampleHomePageState();
}

class _ExampleHomePageState extends State<ExampleHomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const BasicZoomExample(),
    const EnhancedZoomExample(),
    const ConfigurableZoomExample(),
    const AccessibilityExample(),
    const PerformanceExample(),
  ];

  final List<String> _titles = [
    'Basic Zoom',
    'Enhanced Zoom',
    'Configurable Zoom',
    'Accessibility',
    'Performance',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_selectedIndex]),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.zoom_in), label: 'Basic'),
          BottomNavigationBarItem(
            icon: Icon(Icons.auto_awesome),
            label: 'Enhanced',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Config'),
          BottomNavigationBarItem(
            icon: Icon(Icons.accessibility),
            label: 'A11y',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.speed),
            label: 'Performance',
          ),
        ],
      ),
    );
  }
}

class BasicZoomExample extends StatelessWidget {
  const BasicZoomExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Basic Zoom Widget',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          const Text(
            'This is the basic zoom widget with default settings. '
            'You can pinch to zoom and drag to pan.',
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Zoom(
              child: Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue.shade300, Colors.purple.shade300],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Text(
                    'Zoom Me!',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class EnhancedZoomExample extends StatefulWidget {
  const EnhancedZoomExample({super.key});

  @override
  State<EnhancedZoomExample> createState() => _EnhancedZoomExampleState();
}

class _EnhancedZoomExampleState extends State<EnhancedZoomExample> {
  double _currentZoom = 1.0;
  Offset _currentPan = Offset.zero;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Enhanced Zoom Widget',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'Zoom: ${(_currentZoom * 100).toInt()}% | '
            'Pan: (${_currentPan.dx.toInt()}, ${_currentPan.dy.toInt()})',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 16),
          Expanded(
            child: EnhancedZoom(
              config: const ZoomConfig(
                minScale: 0.5,
                maxScale: 4.0,
                initialScale: 1.0,
                enableDoubleTapZoom: true,
                enablePinchZoom: true,
                enablePanning: true,
                showZoomIndicators: true,
                enableHapticFeedback: true,
                animationDuration: Duration(milliseconds: 300),
              ),
              borderRadius: BorderRadius.circular(16),
              onZoomChanged: (zoom) => setState(() => _currentZoom = zoom),
              onPanChanged: (pan) => setState(() => _currentPan = pan),
              onZoomStart: () => debugPrint('Zoom started'),
              onZoomEnd: () => debugPrint('Zoom ended'),
              child: Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  image: const DecorationImage(
                    image: NetworkImage('https://i.pravatar.cc/300'),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.3),
                      ],
                    ),
                  ),
                  child: const Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        'Enhanced Zoom with Callbacks',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ConfigurableZoomExample extends StatefulWidget {
  const ConfigurableZoomExample({super.key});

  @override
  State<ConfigurableZoomExample> createState() =>
      _ConfigurableZoomExampleState();
}

class _ConfigurableZoomExampleState extends State<ConfigurableZoomExample> {
  ZoomConfig _config = const ZoomConfig();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Configurable Zoom',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          Expanded(
            flex: 2,
            child: EnhancedZoom(
              config: _config,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Icon(Icons.settings, size: 64, color: Colors.grey),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            flex: 3,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildSlider(
                    'Min Scale',
                    _config.minScale,
                    0.1,
                    1.0,
                    (value) => setState(
                      () => _config = _config.copyWith(minScale: value),
                    ),
                  ),
                  _buildSlider(
                    'Max Scale',
                    _config.maxScale,
                    1.0,
                    10.0,
                    (value) => setState(
                      () => _config = _config.copyWith(maxScale: value),
                    ),
                  ),
                  _buildSlider(
                    'Zoom Sensitivity',
                    _config.zoomSensitivity,
                    0.1,
                    2.0,
                    (value) => setState(
                      () => _config = _config.copyWith(zoomSensitivity: value),
                    ),
                  ),
                  _buildSlider(
                    'Pan Sensitivity',
                    _config.panSensitivity,
                    0.1,
                    2.0,
                    (value) => setState(
                      () => _config = _config.copyWith(panSensitivity: value),
                    ),
                  ),
                  _buildSwitch(
                    'Double Tap Zoom',
                    _config.enableDoubleTapZoom,
                    (value) => setState(
                      () => _config = _config.copyWith(
                        enableDoubleTapZoom: value,
                      ),
                    ),
                  ),
                  _buildSwitch(
                    'Show Indicators',
                    _config.showZoomIndicators,
                    (value) => setState(
                      () =>
                          _config = _config.copyWith(showZoomIndicators: value),
                    ),
                  ),
                  _buildSwitch(
                    'Haptic Feedback',
                    _config.enableHapticFeedback,
                    (value) => setState(
                      () => _config = _config.copyWith(
                        enableHapticFeedback: value,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSlider(
    String label,
    double value,
    double min,
    double max,
    ValueChanged<double> onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$label: ${value.toStringAsFixed(2)}'),
        Slider(
          value: value,
          min: min,
          max: max,
          divisions: 20,
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildSwitch(String label, bool value, ValueChanged<bool> onChanged) {
    return SwitchListTile(
      title: Text(label),
      value: value,
      onChanged: onChanged,
    );
  }
}

class AccessibilityExample extends StatefulWidget {
  const AccessibilityExample({super.key});

  @override
  State<AccessibilityExample> createState() => _AccessibilityExampleState();
}

class _AccessibilityExampleState extends State<AccessibilityExample> {
  double _currentScale = 1.0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Accessibility Features',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          const Text(
            'This example demonstrates accessibility features:\n'
            '• Screen reader support\n'
            '• Keyboard shortcuts (Ctrl +/-, Ctrl 0)\n'
            '• Semantic labels and hints\n'
            '• High contrast support\n'
            '• Reduced motion support',
          ),
          const SizedBox(height: 16),
          Expanded(
            child: AccessibleZoom(
              currentScale: _currentScale,
              minScale: 0.5,
              maxScale: 3.0,
              onScaleChanged: (scale) => setState(() => _currentScale = scale),
              onReset: () => setState(() => _currentScale = 1.0),
              contentType: 'Interactive diagram',
              showControls: true,
              enableKeyboardShortcuts: true,
              child: Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  border: Border.all(color: Colors.blue.shade200),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.accessibility_new,
                        size: 64,
                        color: Colors.blue,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Accessible Content',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Try keyboard shortcuts:\n'
                        'Ctrl + = (zoom in)\n'
                        'Ctrl + - (zoom out)\n'
                        'Ctrl + 0 (reset)',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PerformanceExample extends StatefulWidget {
  const PerformanceExample({super.key});

  @override
  State<PerformanceExample> createState() => _PerformanceExampleState();
}

class _PerformanceExampleState extends State<PerformanceExample> {
  final List<Widget> _items = List.generate(
    100,
    (index) => Container(
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.primaries[index % Colors.primaries.length].shade300,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(
          '$index',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Performance Example',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          const Text(
            'This example shows zoom performance with complex content.\n'
            'Performance monitoring is enabled in debug mode.',
          ),
          const SizedBox(height: 16),
          Expanded(
            child: EnhancedZoom(
              config: const ZoomConfig(
                minScale: 0.2,
                maxScale: 5.0,
                showZoomIndicators: true,
                enableHapticFeedback: true,
              ),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 10,
                  childAspectRatio: 1.0,
                ),
                itemCount: _items.length,
                itemBuilder: (context, index) => _items[index],
              ),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              // In debug mode, this would show performance statistics
              debugPrint('Performance statistics would be shown here');
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Check debug console for performance stats'),
                ),
              );
            },
            child: const Text('Show Performance Stats'),
          ),
        ],
      ),
    );
  }
}
