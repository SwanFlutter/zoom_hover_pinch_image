import 'package:example/screen.dart';
import 'package:flutter/material.dart';
import 'package:zoom_hover_pinch_image/zoom_hover_pinch_image.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Zoom Hover Pinch Image Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const ExampleSelector(),
    );
  }
}

class ExampleSelector extends StatelessWidget {
  const ExampleSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Zoom Examples'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Choose an Example',
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            _buildExampleCard(
              context,
              'Original Example',
              'Basic zoom functionality with the original API',
              Icons.zoom_in,
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MyHomePage()),
              ),
            ),
            const SizedBox(height: 16),
            _buildExampleCard(
              context,
              'Enhanced Examples',
              'Professional features with improved accessibility and performance',
              Icons.auto_awesome,
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Screen()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExampleCard(
    BuildContext context,
    String title,
    String description,
    IconData icon,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(icon, size: 48, color: Theme.of(context).primaryColor),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios),
            ],
          ),
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // Optional ZoomManager instance
  final ZoomManager? zoomManager = ZoomManager();

  late ZoomController zoomController;

  @override
  void initState() {
    zoomController = ZoomController(
      maxScale: 4.0,
      minScale: 1.0,
      animationDuration: const Duration(milliseconds: 400),
      animationCurve: Curves.easeOutQuart,
    );
    super.initState();
  }

  @override
  void dispose() {
    // Dispose the controller when not needed
    zoomController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Flutter Demo Home Page'),
      ),
      body: SizedBox(
        width: size.width,
        height: size.height,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 10),
              Zoom(
                zoomManager: zoomManager,
                width: size.width,
                child: Image.network('https://i.pravatar.cc/300'),
              ),
              const SizedBox(height: 10),
              Zoom.hover(
                zoomManager: zoomManager,
                width: size.width * 0.6, // Optional ZoomManager
                child: Image.network('https://i.pravatar.cc/300'),
              ),
              const SizedBox(height: 10),
              Zoom.hoverMouseRegion(
                zoomController: zoomController, // Optional ZoomManager
                maxScale: 4,
                hoverWidth: 400,
                hoverHeight: 600,
                height: 600,
                width: size.width,
                child: Image.network('https://i.pravatar.cc/300'),
              ),
              const SizedBox(height: 10),
              Zoom.pinch(
                zoomManager: zoomManager,
                width: size.width, // Optional ZoomManager
                child: Image.network('https://i.pravatar.cc/300'),
              ),
              const SizedBox(height: 10),
              Zoom.zoomOnTap(
                zoomManager: zoomManager,
                width: size.width, // Optional ZoomManager
                child: Image.network('https://i.pravatar.cc/300'),
              ),

              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Screen()),
                  );
                },
                child: const Text('Click me'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
