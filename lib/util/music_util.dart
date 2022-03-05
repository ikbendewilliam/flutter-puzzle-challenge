import 'package:flutter/foundation.dart';
import 'package:circluzzle/util/app_constants.dart';
import 'package:just_audio/just_audio.dart';

class MusicUtil {
  static AudioPlayer? _backgroundPlayer;
  static AudioPlayer? _slidePlayer;
  static AudioPlayer? _buttonPressedPlayer;
  static bool muted = false;

  static double get _volumeBG => 0.25;
  static double get _volumeSlide => 0.7;
  static double get _volumeBP => 0.25;

  static Future<AudioPlayer?> get backgroundPlayer async {
    _backgroundPlayer ??= await _playerFromAsset(
      AppConstants.assetbackgroundMusic,
      _volumeBG,
      loop: true,
    );
    return _backgroundPlayer!;
  }

  static Future<AudioPlayer?> get slidePlayer async {
    _slidePlayer ??= await _playerFromAsset(AppConstants.assetSlide, _volumeSlide);
    return _slidePlayer!;
  }

  static Future<AudioPlayer?> get buttonPressedPlayer async {
    _buttonPressedPlayer ??= await _playerFromAsset(AppConstants.assetButtonPress, _volumeBP);
    return _buttonPressedPlayer!;
  }

  static Future<AudioPlayer?> _playerFromAsset(String asset, double volume, {bool loop = false}) async {
    try {
      final player = AudioPlayer();
      await player.setAsset(asset);
      await player.setLoopMode(loop ? LoopMode.one : LoopMode.off);
      await player.setVolume(volume);
      return player;
    } catch (_) {
      return null;
    }
  }

  static Future<void> playBackgroundMusic() async {
    final player = await backgroundPlayer;
    if (player?.playing != false) return;
    await player!.play();
  }

  static Future<void> _playSingleSound(AudioPlayer? player) async {
    if (muted || player == null) return;
    try {
      if (kIsWeb) {
        await player.pause();
      }
      await player.seek(Duration.zero);
      if (kIsWeb || !player.playing) {
        await player.play();
      }
    } catch (_) {}
  }

  static Future<void> playSlideMusic() async => _playSingleSound(await slidePlayer);

  static Future<void> playButtonPressedMusic() async => _playSingleSound(await buttonPressedPlayer);

  static Future<void> loadMusic() async {
    if (await backgroundPlayer == null || await slidePlayer == null || await buttonPressedPlayer == null) {
      muted = true;
      return;
    }
    await Future.wait([
      (await backgroundPlayer)!.load(),
      (await slidePlayer)!.load(),
      (await buttonPressedPlayer)!.load(),
    ]);
  }

  static Future<void> toggleMute() async {
    if (await backgroundPlayer == null || await slidePlayer == null || await buttonPressedPlayer == null) {
      muted = true;
      return;
    }
    muted = !muted;
    await Future.wait([
      (await backgroundPlayer)!.setVolume(muted ? 0.0 : _volumeBG),
      (await slidePlayer)!.setVolume(muted ? 0.0 : _volumeSlide),
      (await buttonPressedPlayer)!.setVolume(muted ? 0.0 : _volumeBP),
    ]);
  }
}
