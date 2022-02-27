import 'dart:io';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_puzzle_challenge/util/app_constants.dart';
import 'package:flutter_puzzle_challenge/util/music_util.dart';
import 'package:flutter_puzzle_challenge/widget/puzzle.dart';
import 'package:flutter_puzzle_challenge/widget/puzzle_button.dart';
import 'package:flutter_puzzle_challenge/widget/puzzle_option.dart';
import 'package:image_picker/image_picker.dart';

class PuzzleScreen extends StatefulWidget {
  const PuzzleScreen({Key? key}) : super(key: key);

  @override
  State<PuzzleScreen> createState() => _PuzzleScreenState();
}

class _PuzzleScreenState extends State<PuzzleScreen> {
  ImageProvider image = const AssetImage(AppConstants.assetDash);
  var _radius = 3;
  var _segments = 8;
  var _lightMode = WidgetsBinding.instance?.window.platformBrightness != Brightness.dark;
  var _scrambleId = 0;
  var _showBlockingScreen = true;
  var _loadingMusic = true;

  void _scramble() {
    setState(() {
      try {
        _scrambleId++;
      } catch (e) {
        _scrambleId = 0;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _loadMusic();
  }

  Future<void> _loadMusic() async {
    await MusicUtil.loadMusic();
    setState(() {
      _loadingMusic = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
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
                segments: _segments,
                radius: _radius,
                scrambleId: _scrambleId,
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: PuzzleOption(
                color: _lightMode ? Colors.black : Colors.white,
                label: 'Segments',
                value: _segments,
                onChanged: (value) => setState(() => _segments = value),
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
                    PuzzleButton(
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
                  PuzzleButton(
                    color: _lightMode ? Colors.black : Colors.white,
                    icon: const Icon(Icons.refresh),
                    iconSize: 40,
                    onPressed: _scramble,
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: PuzzleOption(
                color: _lightMode ? Colors.black : Colors.white,
                label: 'Radius',
                value: _radius,
                onChanged: (value) => setState(() => _radius = value),
                minValue: 2,
                maxValue: 6,
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: PuzzleButton(
                icon: Icon(_lightMode ? Icons.dark_mode : Icons.light_mode),
                color: _lightMode ? Colors.black : Colors.white,
                iconSize: 40,
                onPressed: () => setState(() {
                  _lightMode = !_lightMode;
                }),
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: PuzzleButton(
                icon: Icon(MusicUtil.muted ? Icons.volume_mute : Icons.volume_up),
                color: _lightMode ? Colors.black : Colors.white,
                iconSize: 40,
                onPressed: () async {
                  await MusicUtil.toggleMute();
                  setState(() {}); // Update icon
                },
              ),
            ),
            AnimatedPositioned(
              duration: const Duration(milliseconds: 500),
              top: _showBlockingScreen ? 0 : -size.height,
              height: size.height,
              left: 0,
              right: 0,
              child: GestureDetector(
                onTap: () {
                  if (!_showBlockingScreen || _loadingMusic) return;
                  MusicUtil.playBackgroundMusic();
                  setState(() => _showBlockingScreen = false);
                },
                child: ClipRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: 5,
                      sigmaY: 5,
                    ),
                    child: Container(
                      color: (_lightMode ? Colors.black : Colors.white).withOpacity(0.5),
                      child: Center(
                        child: Text(
                          _loadingMusic ? 'Loading...' : 'Tap to Start',
                          style: TextStyle(
                            color: _lightMode ? Colors.white : Colors.black,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
