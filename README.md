# circluzzle

You can try it out on
- [Web](https://ikbendewilliam.github.io/flutter-puzzle-challenge/build/web/) 
- [iOS & macOS](https://apps.apple.com/us/app/circluzzle/id1611980790) 
- [Android](https://play.google.com/store/apps/details?id=be.wive.circluzzle)
- [Windows](https://www.microsoft.com/store/apps/9NXJSXK658B8)
- [Linux](https://snapcraft.io/circluzzle) or `snap install circluzzle`

Or build on your device from the public [repo](https://github.com/ikbendewilliam/flutter-puzzle-challenge)

Devpost: https://devpost.com/software/circular-puzzle

YouTube: https://www.youtube.com/watch?v=3xNA76mouM4

## Credits
- Sliding sound: 176146__swagmuffinplus__sliding-doors.wav - https://freesound.org/people/SwagMuffinPlus/sounds/176146/
- 459706__slaking-97__free-music-background-loop-002 - https://freesound.org/people/Slaking_97/sounds/459706/
- mixkit-game-ball-tap-2073 - https://mixkit.co/free-sound-effects/game/?page=2
- Snap build possible thanks to [Ken VanDine](https://gist.github.com/kenvandine)'s [gist](https://gist.github.com/kenvandine/de8674a5eaf0d0c6c506bf38f91b9dcd)

## Desktop experiences
This was my first project that I've build on desktop. I wanted to explain a bit the experience and trouble I had. I've followed the guide from [Flutter.dev](https://docs.flutter.dev/desktop)

**macOS**

macOS worked right out of the box, I did not have any trouble building, uploading or making it available in the app store. Kudos to the Flutter team!

**Windows**

This was a bit more difficult, there was more configuration needed and just_audio doesn't support windows out of the box, you need to add [just_audio_libwinmedia](https://github.com/bdlukaa/just_audio_libwinmedia). This plugin caused other issues, but I was able to resolve them following [this issue](https://github.com/bdlukaa/just_audio_libwinmedia/issues/3) by deleting `nuget.config` file located in `AppData\Roaming\nuget\ .` and rebuilding. 

The biggest trouble with Windows I encountered was actually the store. I added the app for review, but got rejected after a couple of days. According to the reviewer, my app is not a "game", even though they have [Sliding puzzles](https://www.microsoft.com/en-us/p/sliding-tiles-puzzle/9nz22xvxg54n?activetab=pivot:overviewtab) in the Microsoft store... For now this hasn't been resolved.

**Linux**

Linux was a whole other issue, first of all I don't have a Linux desktop available, so I tried using [WSL 2](https://www.omgubuntu.co.uk/how-to-install-wsl2-on-windows-10). This doesn't support snap and you need to do some extra stuff for this, there's a [great article](https://forum.snapcraft.io/t/running-snaps-on-wsl2-insiders-only-for-now/13033) you can follow. 
Even though building may work, creating a snap still fails. Again the issue is with just_audio_libwinmedia. This requires a cmake version > 3.15, but the supported cmake version for flutter-snap is 3.11. There is a [PR](https://github.com/canonical/flutter-snap/pull/61) open for this and the author was generous enough to provide a [gist](https://gist.github.com/kenvandine/de8674a5eaf0d0c6c506bf38f91b9dcd) that shows how to build Flutter from git and with base20 (which resolves the issue with the cmake version). 

Unfortunatly, the snap build is still failling, the issue is that cmake create a CMakeCache.txt file, this file contains the directory in which it was made, but we copy it to another place. By removing this file before flutter build, this issue is also resolved and the build processes fine! 
The override-build method of the app parts in snapcraft.yaml:
```yaml
  circluzzle:
    after: [ flutter-git ]
    source: .
    plugin: nil
    override-build: |
      set -eux
      mkdir -p $SNAPCRAFT_PART_INSTALL/bin
      flutter upgrade
      flutter config --enable-linux-desktop
      flutter doctor
      flutter pub get
      rm build/linux/x64/release/CMakeCache.txt
      flutter build linux --release -v
      cp -r build/linux/*/release/bundle/* $SNAPCRAFT_PART_INSTALL/bin/
```
