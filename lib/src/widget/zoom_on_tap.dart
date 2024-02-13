import 'package:flutter/material.dart';

class ZoomOnTap extends StatefulWidget {
  final Widget child;
  final double zoomedScale;
  final double? aspectRatio;
  final bool clipBehavior;
  final bool oneTapZoom;
  final bool doubleTapZoom;

  const ZoomOnTap({
    Key? key,
    required this.child,
    this.zoomedScale = 2.0,
    this.aspectRatio = 1.0,
    this.clipBehavior = true,
    this.oneTapZoom = false,
    this.doubleTapZoom = true,
  }) : super(key: key);

  @override
  State<ZoomOnTap> createState() => _ZoomOnTapState();
}

class _ZoomOnTapState extends State<ZoomOnTap>
    with SingleTickerProviderStateMixin {
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
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (TapDownDetails details) => tapDownDetails = details,
      onDoubleTapDown: (TapDownDetails details) => tapDownDetails = details,
      onTap: widget.doubleTapZoom
          ? null
          : () {
        final position = tapDownDetails!.localPosition;
        double scale = widget.zoomedScale;
        final x = -position.dx * (scale - 1);
        final y = -position.dy * (scale - 1);
        final zoomed = Matrix4.identity()
          ..translate(x, y)
          ..scale(scale);
        final end =
        controller.value.isIdentity() ? zoomed : Matrix4.identity();
        animation = Matrix4Tween(
          begin: controller.value,
          end: end,
        ).animate(CurveTween(curve: Curves.easeInOut)
            .animate(animationController));
        animationController.forward(from: 0);
      },
      onDoubleTap: widget.doubleTapZoom
          ? () {
        final position = tapDownDetails!.localPosition;
        double scale = widget.zoomedScale;
        final x = -position.dx * (scale - 1);
        final y = -position.dy * (scale - 1);
        final zoomed = Matrix4.identity()
          ..translate(x, y)
          ..scale(scale);
        final end =
        controller.value.isIdentity() ? zoomed : Matrix4.identity();
        animation = Matrix4Tween(
          begin: controller.value,
          end: end,
        ).animate(CurveTween(curve: Curves.easeInOut)
            .animate(animationController));
        animationController.forward(from: 0);
      }
          : null,
      child: InteractiveViewer(
        transformationController: controller,
        clipBehavior: widget.clipBehavior ? Clip.hardEdge : Clip.none,
        panEnabled: false,
        scaleEnabled: false,
        child: AspectRatio(
          aspectRatio: widget.aspectRatio!,
          child: widget.child,
        ),
      ),
    );
  }
}