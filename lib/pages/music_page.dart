import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inbedidea/widgets/audio_card_wiget.dart';
import 'package:video_player/video_player.dart';

//void myBackgroundTaskEntrypoint() {
//  AudioServiceBackground.run(() => MyBackgroundTask());
//}

VideoPlayerController _whiteNoiseController =
    initializeControllers('white_noise.wav');
VideoPlayerController _fireNoiseController = initializeControllers('fire_noise'
    '.wav');

VideoPlayerController _brownNoiseController =
    initializeControllers('brown_noise.wav');
VideoPlayerController _fanNoiseController =
    initializeControllers('fan_noise.wav');

class MusicPage extends StatefulWidget {
  @override
  _MusicPageState createState() => _MusicPageState();
}

class _MusicPageState extends State<MusicPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white24,
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 2),
          child: Column(
            children: <Widget>[
              AudioCard(
                  onTap: () {
                    playOne(_whiteNoiseController);
                  },
                  imagePath: 'white_noise.png'),
              AudioCard(
                  imagePath: 'brown_noise.png',
                  onTap: () {
                    playOne(_brownNoiseController);
                  }),
              AudioCard(
                  imagePath: 'fire.png',
                  onTap: () {
                    playOne(_fireNoiseController);
                  }),
              AudioCard(
                  imagePath: 'fan.png',
                  onTap: () {
                    playOne(_fanNoiseController);

//                    }
                  })
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(onPressed: () {}),
      ),
    );
  }

  void playOne(VideoPlayerController controller) {
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

//    bool _isPlaying = audio.value.isPlaying;
//    if (_isPlaying) {
//      audio.pause();
//      return true;
//    }
//    return false;
//  }

}

VideoPlayerController initializeControllers(String assetPath) {
  VideoPlayerController videoPlayerController =
      VideoPlayerController.asset('assets/audio/$assetPath')..initialize();
  videoPlayerController.setLooping(true);
  return videoPlayerController;
}

//class MyBackgroundTask extends BackgroundAudioTask {
//  @override
//  Future<void> onStart() async {
//    _player.play();
//  }
//
//  @override
//  void onStop() {
//    print('onStop');
//  }
//
//  @override
//  void onPlay() {
//    _player.play();
//    print('onPlay');
//  }
//
//  @override
//  void onPause() {
//    print('onPause');
//  }
//
//  @override
//  void onClick(MediaButton button) {
//    print('onClick');
//  }
//}
//
//void connect() async {
//  AudioService.connect();
//}
