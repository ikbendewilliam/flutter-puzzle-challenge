import 'package:flutter/material.dart';
import 'package:flutter_puzzle_challenge/widget/puzzle_button.dart';

class PuzzleOption extends StatelessWidget {
  final String label;
  final int value;
  final ValueChanged<int> onChanged;
  final int maxValue;
  final int minValue;
  final Color color;

  bool get _canIncrease => value < maxValue;

  bool get _canDecrease => value > minValue;

  const PuzzleOption({
    required this.label,
    required this.value,
    required this.onChanged,
    required this.maxValue,
    required this.minValue,
    required this.color,
    Key? key,
  }) : super(key: key);

  void _increase() {
    if (_canIncrease) onChanged(value + 1);
  }

  void _decrease() {
    if (_canDecrease) onChanged(value - 1);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(width: 10),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            PuzzleButton(
              color: _canIncrease ? color : Colors.grey,
              onPressed: _increase,
              padding: const EdgeInsets.all(0),
              icon: const Icon(Icons.arrow_drop_up),
            ),
            Text(
              value.toString(),
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            PuzzleButton(
              color: _canDecrease ? color : Colors.grey,
              onPressed: _decrease,
              padding: const EdgeInsets.all(0),
              icon: const Icon(Icons.arrow_drop_down),
            ),
          ],
        ),
        const SizedBox(width: 4),
      ],
    );
  }
}
