import 'package:flutter/material.dart';
import 'package:flutter_puzzle_challenge/util/music_util.dart';

class PuzzleButton extends StatefulWidget {
  final Color color;
  final Icon icon;
  final double iconSize;
  final VoidCallback onPressed;
  final EdgeInsetsGeometry padding;

  const PuzzleButton({
    required this.color,
    required this.icon,
    required this.onPressed,
    this.iconSize = 24.0,
    this.padding = const EdgeInsets.all(8.0),
    Key? key,
  }) : super(key: key);

  @override
  State<PuzzleButton> createState() => _PuzzleButtonState();
}

class _PuzzleButtonState extends State<PuzzleButton> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: widget.icon,
      iconSize: widget.iconSize,
      color: widget.color,
      padding: widget.padding,
      onPressed: () async {
        widget.onPressed();
        await MusicUtil.playButtonPressedMusic();
      },
    );
  }
}
