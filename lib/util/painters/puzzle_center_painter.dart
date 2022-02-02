import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart' hide Image;
import 'package:vector_math/vector_math_64.dart' hide Colors;

class PuzzleCenterPainter extends CustomPainter {
  final Image image;
  final double imageRadiusEnd;

  PuzzleCenterPainter({
    required this.image,
    required this.imageRadiusEnd,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..filterQuality = FilterQuality.high;
    final imageWidth = image.width;
    final imageHeight = image.height;
    final uiSize = min(size.width, size.height);
    final imageSize = max(imageWidth, imageHeight).toDouble();
    final scale = uiSize / imageSize;
    final matrix4Image = Matrix4.diagonal3(Vector3.all(scale));
    final clipPath = Path()
      ..addOval(Rect.fromCircle(
        center: Offset(size.width, size.height) / 2,
        radius: imageSize * imageRadiusEnd,
      ));
    canvas.save();
    canvas.clipPath(clipPath);
    canvas.transform(matrix4Image.storage);
    canvas.drawImage(image, Offset((size.width / scale - imageWidth) / 2, (size.height / scale - imageHeight) / 2), paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate is! PuzzleCenterPainter || oldDelegate.image != image || oldDelegate.imageRadiusEnd != imageRadiusEnd;
  }
}
