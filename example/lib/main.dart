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
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
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
                child: Image.network(
                  'https://salamdonya.com/assets/images/31/3123pacn7.jpg',
                ),
              ),
              const SizedBox(height: 10),
              Zoom.hover(
                zoomManager: zoomManager,
                width: size.width * 0.6, // Optional ZoomManager
                child: Image.network(
                  'https://salamdonya.com/assets/images/68/6894ugohl.jpg',
                ),
              ),
              const SizedBox(height: 10),
              Zoom.hoverMouseRegion(
                zoomController: zoomController, // Optional ZoomManager
                maxScale: 4,
                hoverWidth: 400,
                hoverHeight: 600,
                height: 600,
                width: size.width,
                child: Image.network(
                  'https://salamdonya.com/assets/images/54/5429725jv.jpg',
                ),
              ),
              const SizedBox(height: 10),
              Zoom.pinch(
                zoomManager: zoomManager,
                width: size.width, // Optional ZoomManager
                child: Image.network(
                  'https://salamdonya.com/assets/images/54/5429725jv.jpg',
                ),
              ),
              const SizedBox(height: 10),
              Zoom.zoomOnTap(
                zoomManager: zoomManager,
                width: size.width, // Optional ZoomManager
                child: Image.network(
                  'https://salamdonya.com/assets/images/45/4595h65r7.jpg',
                ),
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
