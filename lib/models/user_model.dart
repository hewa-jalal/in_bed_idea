import 'package:flutter/cupertino.dart';

class UserModel with ChangeNotifier {
  String userId = 'manual default';
  String userName = 'manual defualt';

  saveValue(userIdParam, userNameParam) {
    userId = userIdParam;
    userName = userNameParam;
    notifyListeners();
  }
}