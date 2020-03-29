import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:inbedidea/pages/account_page.dart';
import 'package:inbedidea/pages/first_page.dart';
import 'package:inbedidea/pages/login_page.dart';
import 'package:inbedidea/models/user_model.dart';
import 'package:inbedidea/welcome_page.dart';
import 'package:provider/provider.dart';
import 'package:screen/screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<UserModel>(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SafeArea(child: WelcomePage()),
      ),
      create: (_) => UserModel(),
    );
  }
}
