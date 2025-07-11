import 'package:audioplayers/audioplayers.dart';

class AudioPlayerManager {
  AudioPlayer? player;
  AudioCache? cache;
  AudioPlayerManager({
    this.player,
    this.cache,
  });

  void init() {
    player = AudioPlayer();
    cache = AudioCache(prefix: 'audio/');
  }

  Future<void> play(String path) async {
    try {
      await player!.play(AssetSource(path));
    } catch (e) {
      print(e);
    }
  }

  void dispose() {
    player!.dispose();
  }
}
