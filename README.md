# Zoom_Hover_Pinch_Image


 Zoom functionality: Enables pinch-to-zoom interaction on the child widget.
 Border radius customization: Allows you to specify the border radius for clipping the child widget.
 Aspect ratio customization: Specifies the aspect ratio of the widget.
Min and max scale limits: Sets the minimum and maximum allowed zoom levels for the child widget.
Clip behavior: Determines whether clipping behavior should be applied to the child widget.
 By customizing these properties, you can control the zoom level, aspect ratio, clipping behavior,
and scale limits, tailoring the interaction experience to your specific requirements.

## Features

```dart
Zoom(
child: Image.network("https://i.pravatar.cc/300"),
clipBehavior: false,
),
```


```dart

import 'package:flutter/material.dart';
import 'package:zoom_hover_pinch_image/zoom_hover_pinch_image.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Zoom Example')),
        body: Center(
          child: ZoomExample(),
        ),
      ),
    );
  }
}

class ZoomExample extends StatefulWidget {
  @override
  _ZoomExampleState createState() => _ZoomExampleState();
}

class _ZoomExampleState extends State<ZoomExample> {
  final ZoomManager zoomManager = ZoomManager();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Zoom(
          zoomManager: zoomManager,
          minScale: 1.0,
          maxScale: 4.0,
          width: 300.0,
          height: 300.0,
          child: Image.asset('assets/image.jpg'),
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            zoomManager.zoomIn(scale: 2.0);
          },
          child: Text('Zoom In'),
        ),
        ElevatedButton(
          onPressed: () {
            zoomManager.zoomOut();
          },
          child: Text('Zoom Out'),
        ),
      ],
    );
  }
}

```

![zoom](https://github.com/SwanFlutter/zoom_hover_pinch_image/assets/151648897/941d160b-c854-4aa9-803f-8da397bf6523)


```dart
Zoom(
child: Image.network("https://i.pravatar.cc/300"),
clipBehavior: true,
),
```
![zoom1](https://github.com/SwanFlutter/zoom_hover_pinch_image/assets/151648897/3cac8ebe-6369-4852-bff8-0de30b91df4d)

```dart
Zoom.pinch(
child: Image.network("https://i.pravatar.cc/300"),
clipBehavior: false,
borderRadius: BorderRadius.circular(8.0),
),
```

```dart

class PinchExample extends StatefulWidget {
  @override
  _PinchExampleState createState() => _PinchExampleState();
}

class _PinchExampleState extends State<PinchExample> {
  final ZoomManager zoomManager = ZoomManager();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Pinch(
          zoomManager: zoomManager,
          minScale: 1.0,
          maxScale: 4.0,
          width: 300.0,
          height: 300.0,
          child: Image.asset('assets/image.jpg'),
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            zoomManager.zoomIn(scale: 2.0);
          },
          child: Text('Zoom In'),
        ),
        ElevatedButton(
          onPressed: () {
            zoomManager.zoomOut();
          },
          child: Text('Zoom Out'),
        ),
      ],
    );
  }
}

```

![pinch](https://github.com/SwanFlutter/zoom_hover_pinch_image/assets/151648897/0e12345b-65d9-42d1-b85e-e43b7c23ca1b)

use web && windows && mac && linux

```dart
Zoom.hover(
child: Image.network("https://i.pravatar.cc/300"),
zoomedScale: 3.0
),
```

```dart

class HoverExample extends StatefulWidget {
  @override
  _HoverExampleState createState() => _HoverExampleState();
}

class _HoverExampleState extends State<HoverExample> {
  final ZoomManager zoomManager = ZoomManager();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Hover(
          zoomManager: zoomManager,
          initialScale: 1.0,
          hoverScale: 2.0,
          width: 300.0,
          height: 300.0,
          child: Image.asset('assets/image.jpg'),
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            zoomManager.zoomIn(scale: 2.0);
          },
          child: Text('Zoom In'),
        ),
        ElevatedButton(
          onPressed: () {
            zoomManager.zoomOut();
          },
          child: Text('Zoom Out'),
        ),
      ],
    );
  }
}

```


![haver](https://github.com/SwanFlutter/zoom_hover_pinch_image/assets/151648897/ace25916-d9db-4129-a77f-b70f43e7a294)

use web && windows && mac && linux

```dart
Zoom.hoverMouseRegion(
child: Image.network("https://i.pravatar.cc/300"),
 zoomedScale: 3.0
),
```
![hoverMouseRegion](https://github.com/SwanFlutter/zoom_hover_pinch_image/assets/151648897/36842e65-07b0-4fe0-8865-5a57e3a9993a)

```dart
Zoom.zoomOnTap(
child: Image.network("https://i.pravatar.cc/300"),
zoomedScale: 3.0,
clipBehavior: true,
),
```
![zoomOnTap](https://github.com/SwanFlutter/zoom_hover_pinch_image/assets/151648897/2c60fa5c-9226-4c55-a0b2-c8227e76ea3b)

```dart
Zoom.zoomOnTap(
child: Image.network("https://i.pravatar.cc/300"),
zoomedScale: 3.0,
clipBehavior: false,
),
```
![zoomOnTap-1](https://github.com/SwanFlutter/zoom_hover_pinch_image/assets/151648897/873f0740-6ef1-404a-aad5-b2b424086ed7)

```dart
Zoom.zoomOnTap(
child: Image.network("https://i.pravatar.cc/300"),
zoomedScale: 3.0,
clipBehavior: true,
oneTapZoom: true,
doubleTapZoom: false,
),
```

![zoomOnTap-2](https://github.com/SwanFlutter/zoom_hover_pinch_image/assets/151648897/2fc59e80-2577-43aa-8f74-a471a79dc69b)


## Getting started

```yaml
dependencies:
  zoom_hover_pinch_image: ^1.1.0
```

## How to use

```dart
import 'package:zoom_hover_pinch_image/zoom_hover_pinch_image.dart';

```

## Usage

 `/example`.

```dart
Zoom.zoomOnTap(
child: Image.network("https://i.pravatar.cc/300"),
zoomedScale: 3.0,
clipBehavior: true,
oneTapZoom: true,
doubleTapZoom: false,
),
```

## Additional information

If you have any issues, questions, or suggestions related to this package, please feel free to contact us at [swan.dev1993@gmail.com](mailto:swan.dev1993@gmail.com). We welcome your feedback and will do our best to address any problems or provide assistance.
For more information about this package, you can also visit our [GitHub repository](https://github.com/SwanFlutter/zoom_hover_pinch_image) where you can find additional resources, contribute to the package's development, and file issues or bug reports. We appreciate your contributions and feedback, and we aim to make this package as useful as possible for our users.
Thank you for using our package, and we look forward to hearing from you!.
