import 'dart:async';

import 'package:flutter/cupertino.dart';

class TeddyAnimations with ChangeNotifier {
  String _animation = 'idle';

  get animation => _animation;

  void changeAnimation() {
    _animation = 'success';
    notifyListeners();
    Future.delayed(Duration(seconds: 2), () => _animation = 'idle');
    notifyListeners();
  }
}
