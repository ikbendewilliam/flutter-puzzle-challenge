import 'package:flutter/material.dart';

class PuzzleOption extends StatelessWidget {
  final String label;
  final int value;
  final ValueChanged<int> onChanged;
  final int maxValue;
  final int minValue;

  const PuzzleOption({
    required this.label,
    required this.value,
    required this.onChanged,
    required this.maxValue,
    required this.minValue,
    Key? key,
  }) : super(key: key);

  void _increase() {
    if (value < maxValue) onChanged(value + 1);
  }

  void _decrease() {
    if (value > minValue) onChanged(value - 1);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 10),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: _increase,
              padding: const EdgeInsets.all(0),
              icon: const Icon(Icons.arrow_drop_up),
            ),
            Text(
              value.toString(),
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            IconButton(
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
