

import 'package:flutter/material.dart';

class Pinch extends StatefulWidget {
  final Widget child;
  final BorderRadiusGeometry borderRadius;
  final double? aspectRatio;
  final double? minScale;
  final double? maxScale;
  final bool clipBehavior;
  const Pinch({
    Key? key,
    required this.child,
    this.borderRadius = BorderRadius.zero,
    this.aspectRatio = 1.0,
    this.minScale = 1.0,
    this.maxScale = 4.0,
    this.clipBehavior = true,
  }) : super(key: key);

  @override
  State<Pinch> createState() => _PinchState();
}

class _PinchState extends State<Pinch> with SingleTickerProviderStateMixin {
  late TransformationController controller;

  TapDownDetails? tapDownDetails;

  late AnimationController animationController;
  late Animation<Matrix4> animation;

  @override
  void initState() {
    super.initState();
    controller = TransformationController();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    )..addListener(() {
      controller.value = animation.value;
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void restAnimation() {
    animation =
        Matrix4Tween(begin: controller.value, end: Matrix4.identity()).animate(
          CurvedAnimation(parent: animationController, curve: Curves.easeInOut),
        );
    animationController.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    return InteractiveViewer(
      transformationController: controller,
      clipBehavior: widget.clipBehavior ? Clip.hardEdge : Clip.none,
      panEnabled: false,
      onInteractionEnd: (details) {
        restAnimation();
      },
      child: AspectRatio(
        aspectRatio: widget.aspectRatio!,
        child: ClipRRect(
          borderRadius: widget.borderRadius,
          child: widget.child,
        ),
      ),
    );
  }
}