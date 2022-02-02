import 'package:flutter/material.dart';
import 'package:flutter_puzzle_challenge/util/app_constants.dart';
import 'package:flutter_puzzle_challenge/widget/puzzle.dart';

class PuzzleScreen extends StatelessWidget {
  const PuzzleScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.topRight,
                colors: [
                  Colors.grey[50]!,
                  Colors.grey[300]!,
                ],
              ),
            ),
          ),
          const Puzzle(
            image: AssetImage(AppConstants.assetDash),
          ),
        ],
      ),
    );
  }
}
