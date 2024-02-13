import 'package:flutter/material.dart';
import 'package:zoom_hover_pinch_image/zoom_hover_pinch_image.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Flutter Demo Home Page'),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            const SizedBox(height: 10),
            SizedBox(
              child: Zoom(
                child: Image.network('https://picsum.photos/200/300'),
              ),
            ),
            const SizedBox(height: 10),
            Zoom.hover(child: Image.network('https://picsum.photos/200/300')),
            const SizedBox(height: 10),
            Zoom.hoverMouseRegion(
                child: Image.network('https://picsum.photos/200/300')),
            const SizedBox(height: 10),
            Zoom.pinch(child: Image.network('https://picsum.photos/200/300')),
            const SizedBox(height: 10),
            Zoom.zoomOnTap(
                child: Image.network('https://picsum.photos/200/300')),
          ],
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
