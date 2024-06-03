import 'dart:io';
import 'package:flutter/material.dart';
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

class _ViewImagePageState extends State<ViewImagePage> {
  late final TransformationController _transformationController;

  @override
  initState() {
    super.initState();
    _transformationController = TransformationController();
  }

  @override
  dispose() {
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
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: Center(
        child: SizedBox.expand(
          child: InteractiveViewer(
            panAxis: PanAxis.free,
            panEnabled: true,
            scaleEnabled: true,
            child: _buildImage(),
          ),
        ),
      ),
    );
  }
}
