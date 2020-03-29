import 'package:flutter/cupertino.dart';

class UserModel extends ChangeNotifier {
  String userId = 'manual default';

  saveValue(param) {
    userId = param;
    notifyListeners();
  }
}