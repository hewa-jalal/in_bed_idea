import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inbedidea/custom_controller.dart';
import 'package:inbedidea/widgets/audio_card_wiget.dart';
import 'package:video_player/video_player.dart';

//void myBackgroundTaskEntrypoint() {
//  AudioServiceBackground.run(() => MyBackgroundTask());
//}

class MusicPage extends StatefulWidget {
  @override
  _MusicPageState createState() => _MusicPageState();
}

class _MusicPageState extends State<MusicPage> {
  CustomController controller = CustomController();

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
              Expanded(
                child: AudioCard(
                    onTap: () => controller.playOne(Player.white),
                    imagePath: 'white_noise.png'),
              ),
              Expanded(
                child: AudioCard(
                  imagePath: 'brown_noise.png',
                  onTap: () => controller.playOne(Player.brown),
                ),
              ),
              Expanded(
                child: AudioCard(
                  imagePath: 'fire.png',
                  onTap: () => controller.playOne(Player.fire),
                ),
              ),
              Expanded(
                child: AudioCard(
                  imagePath: 'fan.png',
                  onTap: () => controller.playOne(Player.fan),
                ),
              )
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(onPressed: () {}),
      ),
    );
  }

//    bool _isPlaying = audio.value.isPlaying;
//    if (_isPlaying) {
//      audio.pause();
//      return true;
//    }
//    return false;
//  }

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
