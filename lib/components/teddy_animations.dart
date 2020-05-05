import 'dart:async';

import 'package:flutter/cupertino.dart';

enum TeddyStatus { idle, sleeping, wakeUp, success, fail }

class TeddyAnimations with ChangeNotifier {
  String _animation = 'idle';

  get animation => _animation;

  void changeAnimation(TeddyStatus teddyStatus, {bool isBackToIdle = false}) {
    switch (teddyStatus) {
      case TeddyStatus.idle:
        _animation = 'idle';
        break;
      case TeddyStatus.sleeping:
        _animation = 'sleeping';
        break;
      case TeddyStatus.wakeUp:
        _animation = 'wake_up';
        break;
      case TeddyStatus.success:
        _animation = 'success';
        break;
      case TeddyStatus.fail:
        _animation = 'fail';
        break;
    }
    if (isBackToIdle) backToIdle();
    notifyListeners();
  }

  void backToIdle() {
    Timer(Duration(seconds: 4), () {
      _animation = 'idle';
      notifyListeners();
    });
  }
}
