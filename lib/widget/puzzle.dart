import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_puzzle_challenge/model/puzzle_piece.dart';
import 'package:flutter_puzzle_challenge/util/painters/puzzle_center_painter.dart';
import 'package:flutter_puzzle_challenge/util/painters/puzzle_piece_painter.dart';
import 'dart:ui' as ui;

class Puzzle extends StatefulWidget {
  final ImageProvider image;

  const Puzzle({
    required this.image,
    Key? key,
  }) : super(key: key);

  @override
  State<Puzzle> createState() => _PuzzleState();
}

class _PuzzleState extends State<Puzzle> {
  static const maxI = 8;
  static const deltaAngle = pi * 2 / maxI;
  static const animationStepDuration = Duration(milliseconds: 10);
  static const radii = [0.1, 0.2, 0.4];
  static const animationSteps = 20;
  final random = Random();
  final pieces = <PuzzlePiece>[];
  late int hole;

  ImageStreamListener? _imageListener;
  ImageStream? _imageStream;
  ui.Image? _imageAsUIImage;
  Timer? _animationTimer;
  bool solved = false;

  @override
  void initState() {
    super.initState();
    for (var i = 0; i < maxI; i++) {
      for (final radius in radii) {
        pieces.add(PuzzlePiece.fromImage(
          imageRadiusStart: radius,
          imageRadiusEnd: radius * 2,
          imageAngleStart: deltaAngle * i,
          imageAngleEnd: deltaAngle * (i + 1),
        ));
      }
    }
    hole = random.nextInt(pieces.length);
    _shufflePieces();
    _checkSolved();
  }

  _checkSolved() {
    if (pieces.every((piece) => piece.isSolved)) {
      setState(() {
        solved = true;
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _getImage();
  }

  @override
  void dispose() {
    if (_imageListener != null) _imageStream?.removeListener(_imageListener!);
    _animationTimer?.cancel();
    super.dispose();
  }

  void _shufflePieces() {
    for (int i = 0; i < 1000; i++) {
      final temp = pieces[hole];
      final indexes = pieces.asMap().entries.where((element) => element.value.isNeighbour(temp));
      final index2 = indexes.elementAt(random.nextInt(indexes.length)).key;
      pieces[hole] = pieces[hole].copyWith(
        positionAngleStart: pieces[index2].positionAngleStart,
        positionAngleEnd: pieces[index2].positionAngleEnd,
        positionRadiusStart: pieces[index2].positionRadiusStart,
        positionRadiusEnd: pieces[index2].positionRadiusEnd,
      );
      pieces[index2] = pieces[index2].copyWith(
        positionAngleStart: temp.positionAngleStart,
        positionAngleEnd: temp.positionAngleEnd,
        positionRadiusStart: temp.positionRadiusStart,
        positionRadiusEnd: temp.positionRadiusEnd,
      );
    }
  }

  void _getImage() {
    final oldImageStream = _imageStream;
    _imageStream = widget.image.resolve(createLocalImageConfiguration(context));
    if (_imageStream?.key != oldImageStream?.key) {
      if (_imageListener != null) {
        oldImageStream?.removeListener(_imageListener!);
      }
      _imageListener = ImageStreamListener(_updateImage);
      _imageStream?.addListener(_imageListener!);
    }
  }

  void _updateImage(ImageInfo imageInfo, _) {
    setState(() {
      _imageAsUIImage = imageInfo.image;
    });
  }

  void _animate(int fromIndex, PuzzlePiece to) {
    _animationTimer?.cancel();
    final from = pieces[fromIndex];
    var deltaAngle = (to.positionAngleStart - from.positionAngleStart) / animationSteps;
    if (deltaAngle > pi / animationSteps) {
      deltaAngle = (to.positionAngleStart - from.positionAngleStart - pi * 2) / animationSteps;
    } else if (deltaAngle < -pi / animationSteps) {
      deltaAngle = (to.positionAngleStart - from.positionAngleStart + pi * 2) / animationSteps;
    }
    final deltaRadius = (to.positionRadiusStart - from.positionRadiusStart) / animationSteps;
    var i = 0;
    _animationTimer = Timer.periodic(animationStepDuration, (timer) {
      i++;
      setState(() {
        if (i == animationSteps) {
          pieces[fromIndex] = pieces[fromIndex].copyWith(
            positionAngleStart: to.positionAngleStart,
            positionAngleEnd: to.positionAngleEnd,
            positionRadiusStart: to.positionRadiusStart,
            positionRadiusEnd: to.positionRadiusEnd,
          );
          _animationTimer?.cancel();
          _animationTimer = null;
          _checkSolved();
        } else {
          pieces[fromIndex] = pieces[fromIndex].copyWith(
            positionAngleStart: from.positionAngleStart + deltaAngle * i,
            positionAngleEnd: from.positionAngleEnd + deltaAngle * i,
            positionRadiusStart: from.positionRadiusStart + deltaRadius * i,
            positionRadiusEnd: from.positionRadiusEnd + deltaRadius * i,
          );
        }
      });
    });
  }

  void _movePiece(PuzzlePiece piece, int index) {
    if (solved || _animationTimer != null) return;
    if (piece.isNeighbour(pieces[hole])) {
      setState(() {
        final temp = pieces[hole];
        pieces[hole] = pieces[hole].copyWith(
          positionAngleStart: pieces[index].positionAngleStart,
          positionAngleEnd: pieces[index].positionAngleEnd,
          positionRadiusStart: pieces[index].positionRadiusStart,
          positionRadiusEnd: pieces[index].positionRadiusEnd,
        );
        _animate(index, temp);
      });
    }
  }

  void _onTapDown(TapDownDetails details) {
    final image = _imageAsUIImage;
    if (image == null || _animationTimer != null) return;
    final size = MediaQuery.of(context).size;
    var position = details.localPosition - Offset(size.width, size.height) / 2;
    position = position / min(size.width, size.height).toDouble() * 2;
    final angle = (atan2(-position.dy, position.dx) + (pi * 2)) % (pi * 2);
    final radius = position.distance;
    final index = pieces.indexWhere((piece) => piece.isInside(angle, radius));
    if (index != -1) _movePiece(pieces[index], index);
  }

  @override
  Widget build(BuildContext context) {
    if (_imageAsUIImage == null) return const Center(child: CircularProgressIndicator());
    final size = MediaQuery.of(context).size;
    final bgWidth = min(size.width, size.height) * radii.last * 2;
    return GestureDetector(
      onTapDown: _onTapDown,
      child: Stack(
        children: [
          Center(
            child: Container(
              width: bgWidth,
              height: bgWidth,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(bgWidth),
              ),
            ),
          ),
          Positioned.fill(
            child: CustomPaint(
              size: Size(bgWidth, bgWidth),
              painter: PuzzleCenterPainter(
                image: _imageAsUIImage!,
                imageRadiusEnd: radii.first,
              ),
            ),
          ),
          ...pieces.asMap().entries.where((e) => e.key != hole).map(
                (piece) => Positioned.fill(
                  child: CustomPaint(
                    painter: PuzzlePiecePainter(
                      image: _imageAsUIImage!,
                      piece: piece.value,
                      isSolved: solved,
                    ),
                  ),
                ),
              ),
          AnimatedOpacity(
            opacity: solved ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 1000),
            child: Center(
              child: Image(
                image: widget.image,
                fit: BoxFit.contain,
                height: size.height,
                width: size.width,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
