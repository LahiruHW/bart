import 'package:flutter/material.dart';

class BottomNavBarClipper extends CustomClipper<RRect> {

  BottomNavBarClipper({
    this.edgeRadius = 0,
  });

  final double edgeRadius;

  @override
  RRect getClip(Size size) {
    // get the width and height of the container
    final double width = size.width;
    final double height = size.height;

    // make the top left and top right corners of the container rounded
    final RRect rrect = RRect.fromRectAndCorners(
      Rect.fromLTWH(0, 0, width, height),
      topLeft: Radius.circular(edgeRadius),
      topRight: Radius.circular(edgeRadius),
    );

    return rrect;
  }

  @override
  bool shouldReclip(covariant CustomClipper<RRect> oldClipper) => false;
}
