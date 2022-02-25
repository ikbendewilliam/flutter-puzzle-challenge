import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_puzzle_challenge/util/app_constants.dart';
import 'package:flutter_puzzle_challenge/widget/puzzle.dart';
import 'package:flutter_puzzle_challenge/widget/puzzle_option.dart';
import 'package:image_picker/image_picker.dart';

class PuzzleScreen extends StatefulWidget {
  const PuzzleScreen({Key? key}) : super(key: key);

  @override
  State<PuzzleScreen> createState() => _PuzzleScreenState();
}

class _PuzzleScreenState extends State<PuzzleScreen> {
  ImageProvider image = const AssetImage(AppConstants.assetDash);
  var radius = 3;
  var segments = 8;
  var _lightMode = WidgetsBinding.instance?.window.platformBrightness != Brightness.dark;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.topRight,
                  radius: 2,
                  colors: [
                    _lightMode ? Colors.grey[50]! : Colors.grey[900]!,
                    _lightMode ? Colors.grey[400]! : Colors.grey[600]!,
                  ],
                ),
              ),
            ),
            Positioned.fill(
              child: Puzzle(
                image: image,
                segments: segments,
                radius: radius,
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: PuzzleOption(
                color: _lightMode ? Colors.black : Colors.white,
                label: 'Segments',
                value: segments,
                onChanged: (value) => setState(() => segments = value),
                minValue: 3,
                maxValue: 32,
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (kIsWeb || Platform.isAndroid || Platform.isIOS)
                    IconButton(
                      icon: const Icon(Icons.add_photo_alternate),
                      color: _lightMode ? Colors.black : Colors.white,
                      iconSize: 40,
                      onPressed: () async {
                        final _picker = ImagePicker();
                        final XFile? pickedImage = await _picker.pickImage(source: ImageSource.gallery);
                        if (pickedImage != null) {
                          final bytes = await pickedImage.readAsBytes();
                          setState(() => image = MemoryImage(bytes));
                        }
                      },
                    ),
                  IconButton(
                    color: _lightMode ? Colors.black : Colors.white,
                    icon: const Icon(Icons.refresh),
                    iconSize: 40,
                    onPressed: () => setState(() {
                      radius = 3;
                      segments = 8;
                    }),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: PuzzleOption(
                color: _lightMode ? Colors.black : Colors.white,
                label: 'Radius',
                value: radius,
                onChanged: (value) => setState(() => radius = value),
                minValue: 2,
                maxValue: 4,
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                icon: Icon(_lightMode ? Icons.dark_mode : Icons.light_mode),
                color: _lightMode ? Colors.black : Colors.white,
                iconSize: 40,
                onPressed: () => setState(() {
                  _lightMode = !_lightMode;
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
