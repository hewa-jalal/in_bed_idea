import 'package:video_player/video_player.dart';

class CustomController {
  static final CustomController _singleton = CustomController._internal();

  factory CustomController() => _singleton;

  CustomController._internal();

  static final VideoPlayerController _whiteNoiseController =
      initializeControllers('white_noise.wav');
  static final VideoPlayerController _fireNoiseController =
  initializeControllers('fire_noise.wav');
  VideoPlayerController _brownNoiseController = initializeControllers('brown_noise.wav');
  VideoPlayerController _fanNoiseController = initializeControllers('fan_noise.wav');

  static VideoPlayerController initializeControllers(String assetPath) {
    VideoPlayerController videoPlayerController =
        VideoPlayerController.asset('assets/audio/$assetPath')..initialize();
    videoPlayerController.setLooping(true);
    return videoPlayerController;
  }

  void playOne(Player player) {
    VideoPlayerController controller;
    switch (player) {
      case Player.white:
        controller = _whiteNoiseController;
        break;
      case Player.brown:
        controller = _brownNoiseController;
        break;
      case Player.fire:
        controller = _fireNoiseController;
        break;
      case Player.fan:
        controller = _fanNoiseController;
        break;
    }
    bool isPlaying = controller.value.isPlaying;
    stopAll();
    if (!isPlaying) {
      controller.play();
      isPlaying = false;
    }
    if (isPlaying) controller.pause();
  }

  void stopAll() {
    _whiteNoiseController.pause();
    _fireNoiseController.pause();
    _brownNoiseController.pause();
    _fanNoiseController.pause();
  }

  void stopControllers() {
    _whiteNoiseController.dispose();
    _fireNoiseController.dispose();
    _brownNoiseController.dispose();
    _fanNoiseController.dispose();
  }
}

enum Player { white, brown, fire, fan }
