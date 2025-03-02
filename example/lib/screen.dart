import 'package:flutter/material.dart';
import 'package:zoom_hover_pinch_image/zoom_hover_pinch_image.dart';

class Screen extends StatelessWidget {
  const Screen({super.key});
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: AppBar(title: Text('Screen')),
      body: SizedBox(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: size.width,
              child: Zoom.hoverMouseRegion(
                maxScale: 4,
                width: size.width,
                hoverWidth: 400,
                hoverHeight: 250,
                height: 300,
                child: Image.network(
                  'https://salamdonya.com/assets/images/68/6894ugohl.jpg',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
