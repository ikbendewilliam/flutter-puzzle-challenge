import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart' hide Image;
import 'package:flutter_puzzle_challenge/model/puzzle_piece.dart';
import 'package:vector_math/vector_math_64.dart' hide Colors;

class PuzzlePiecePainter extends CustomPainter {
  final bool isSolved;
  final Image image;
  final PuzzlePiece piece;

  PuzzlePiecePainter({
    required this.isSolved,
    required this.image,
    required this.piece,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..filterQuality = FilterQuality.high;
    final imageWidth = image.width;
    final imageHeight = image.height;
    final uiSize = min(size.width, size.height);
    final imageSize = max(imageWidth, imageHeight).toDouble();
    final scale = uiSize / imageSize;
    final center = size / 2;
    final matrix4Image = Matrix4.diagonal3(Vector3.all(scale));
    final matrix4Path = Matrix4.diagonal3Values(1, 1, 1)
      ..translate(center.width, center.height)
      ..rotateZ(piece.imageAngleStart - piece.positionAngleStart)
      ..scale(piece.positionRadiusStart / piece.imageRadiusStart)
      ..translate(-center.width, -center.height);
    final clipPath = Path()
      ..moveTo(center.width + cos(piece.imageAngleStart) * uiSize / 2 * piece.imageRadiusStart, center.height - sin(piece.imageAngleStart) * uiSize / 2 * piece.imageRadiusStart)
      ..arcToPoint(
        Offset(center.width + cos(piece.imageAngleEnd) * uiSize / 2 * piece.imageRadiusStart, center.height - sin(piece.imageAngleEnd) * uiSize / 2 * piece.imageRadiusStart),
        radius: Radius.circular(uiSize / 2 * piece.imageRadiusStart),
        clockwise: false,
      )
      ..lineTo(center.width + cos(piece.imageAngleEnd) * uiSize / 2 * piece.imageRadiusEnd, center.height - sin(piece.imageAngleEnd) * uiSize / 2 * piece.imageRadiusEnd)
      ..arcToPoint(
        Offset(center.width + cos(piece.imageAngleStart) * uiSize / 2 * piece.imageRadiusEnd, center.height - sin(piece.imageAngleStart) * uiSize / 2 * piece.imageRadiusEnd),
        radius: Radius.circular(uiSize / 2 * piece.imageRadiusEnd),
      )
      ..close();
    final pathPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3 / (piece.positionRadiusStart / piece.imageRadiusStart);
    canvas.save();
    canvas.transform(matrix4Path.storage);
    canvas.clipPath(clipPath);
    canvas.transform(matrix4Image.storage);
    canvas.drawImage(image, Offset((size.width / scale - imageWidth) / 2, (size.height / scale - imageHeight) / 2), paint);
    canvas.restore();
    canvas.save();
    canvas.transform(matrix4Path.storage);
    if (!isSolved) canvas.drawPath(clipPath, pathPaint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate is! PuzzlePiecePainter || oldDelegate.image != image || oldDelegate.piece != piece || oldDelegate.isSolved != isSolved;
  }
}
