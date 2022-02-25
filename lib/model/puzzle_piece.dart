import 'dart:math';

class PuzzlePiece {
  final double imageRadiusStart;
  final double imageRadiusEnd;
  final double imageAngleStart;
  final double imageAngleEnd;
  final double positionRadiusStart;
  final double positionRadiusEnd;
  final double positionAngleStart;
  final double positionAngleEnd;

  PuzzlePiece({
    required this.imageRadiusStart,
    required this.imageRadiusEnd,
    required this.imageAngleStart,
    required this.imageAngleEnd,
    required this.positionRadiusStart,
    required this.positionRadiusEnd,
    required this.positionAngleStart,
    required this.positionAngleEnd,
  });

  PuzzlePiece.fromImage({
    required this.imageRadiusStart,
    required this.imageRadiusEnd,
    required this.imageAngleStart,
    required this.imageAngleEnd,
  })  : positionRadiusStart = imageRadiusStart,
        positionRadiusEnd = imageRadiusEnd,
        positionAngleStart = imageAngleStart,
        positionAngleEnd = imageAngleEnd;

  bool get isSolved => imageRadiusStart == positionRadiusStart && imageRadiusEnd == positionRadiusEnd && imageAngleStart == positionAngleStart && imageAngleEnd == positionAngleEnd;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PuzzlePiece &&
        other.imageRadiusStart == imageRadiusStart &&
        other.imageRadiusEnd == imageRadiusEnd &&
        other.imageAngleStart == imageAngleStart &&
        other.imageAngleEnd == imageAngleEnd &&
        other.positionRadiusStart == positionRadiusStart &&
        other.positionRadiusEnd == positionRadiusEnd &&
        other.positionAngleStart == positionAngleStart &&
        other.positionAngleEnd == positionAngleEnd;
  }

  @override
  int get hashCode {
    return imageRadiusStart.hashCode ^
        imageRadiusEnd.hashCode ^
        imageAngleStart.hashCode ^
        imageAngleEnd.hashCode ^
        positionRadiusStart.hashCode ^
        positionRadiusEnd.hashCode ^
        positionAngleStart.hashCode ^
        positionAngleEnd.hashCode;
  }

  PuzzlePiece copyWith({
    double? imageRadiusStart,
    double? imageRadiusEnd,
    double? imageAngleStart,
    double? imageAngleEnd,
    double? positionRadiusStart,
    double? positionRadiusEnd,
    double? positionAngleStart,
    double? positionAngleEnd,
  }) {
    return PuzzlePiece(
      imageRadiusStart: imageRadiusStart ?? this.imageRadiusStart,
      imageRadiusEnd: imageRadiusEnd ?? this.imageRadiusEnd,
      imageAngleStart: imageAngleStart ?? this.imageAngleStart,
      imageAngleEnd: imageAngleEnd ?? this.imageAngleEnd,
      positionRadiusStart: positionRadiusStart ?? this.positionRadiusStart,
      positionRadiusEnd: positionRadiusEnd ?? this.positionRadiusEnd,
      positionAngleStart: positionAngleStart ?? this.positionAngleStart,
      positionAngleEnd: positionAngleEnd ?? this.positionAngleEnd,
    );
  }

  bool isNeighbour(PuzzlePiece other) =>
      ((positionAngleStart == other.positionAngleEnd ||
              positionAngleEnd == other.positionAngleStart ||
              positionAngleStart == other.positionAngleEnd - pi * 2 ||
              positionAngleEnd == other.positionAngleStart + pi * 2) &&
          positionRadiusStart == other.positionRadiusStart) ||
      ((_isRadiusNeighbour(positionRadiusStart, other.positionRadiusEnd) || _isRadiusNeighbour(positionRadiusEnd, other.positionRadiusStart)) &&
          (positionAngleStart == other.positionAngleStart));

  bool isInside(double angle, double radius) => radius >= positionRadiusStart && radius <= positionRadiusEnd && angle >= positionAngleStart && angle <= positionAngleEnd;

  bool _isRadiusNeighbour(double radius1, double radius2) => (radius1 - radius2).abs() <= 0.01;
}
