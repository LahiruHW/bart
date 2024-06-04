import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ViewImagePage extends StatefulWidget {
  const ViewImagePage({
    super.key,
    required this.imgUrl,
  });

  final String imgUrl;

  @override
  State<ViewImagePage> createState() => _ViewImagePageState();
}

class _ViewImagePageState extends State<ViewImagePage>
    with SingleTickerProviderStateMixin {
  late final TransformationController _transformationController;

  late TapDownDetails _doubleTapDetails;
  late final AnimationController _animationController;
  late Animation<Matrix4> _animation;

  @override
  initState() {
    super.initState();
    _transformationController = TransformationController();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    )..addListener(() {
        _transformationController.value = _animation.value;
      });
  }

  void _handleImageZoom() {
    Matrix4 endMatrix;
    Offset position = _doubleTapDetails.localPosition;

    if (_transformationController.value != Matrix4.identity()) {
      endMatrix = Matrix4.identity();
    } else {
      endMatrix = Matrix4.identity()
        ..translate(-position.dx * 2, -position.dy * 2)
        ..scale(3.0);
    }

    _animation = Matrix4Tween(
      begin: _transformationController.value,
      end: endMatrix,
    ).animate(
      CurveTween(
        curve: Curves.easeInOutCubic,
      ).animate(
        _animationController,
      ),
    );
    _animationController.forward(from: 0);
  }

  @override
  dispose() {
    _animationController.dispose();
    _transformationController.dispose();
    super.dispose();
  }

  Widget _buildImage() => Uri.parse(widget.imgUrl).isAbsolute
      ? CachedNetworkImage(
          imageUrl: widget.imgUrl,
          alignment: Alignment.center,
        )
      : Image.file(
          File(widget.imgUrl),
        );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        primary: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
      ),
      body: Center(
        child: SizedBox.expand(
          child: InteractiveViewer(
            panAxis: PanAxis.free,
            panEnabled: true,
            scaleEnabled: true,
            minScale: 1.0,
            maxScale: 5.0,
            transformationController: _transformationController,
            child: GestureDetector(
              onDoubleTapDown: (d) => setState(() => _doubleTapDetails = d),
              onDoubleTap: _handleImageZoom,
              child: _buildImage(),
            ),
          ),
        ),
      ),
    );
  }
}
