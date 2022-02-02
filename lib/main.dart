import 'package:flutter/material.dart';
import 'package:flutter_puzzle_challenge/screen/puzzle_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Puzzle Challenge',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const PuzzleScreen(),
    );
  }
}
