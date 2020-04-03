import 'package:flutter/material.dart';
import 'package:inbedidea/models/user_model.dart';
import 'package:inbedidea/pages/welcome_page.dart';
import 'package:provider/provider.dart';

void main() => runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<UserModel>(
            create: (_) => UserModel(),
          )
        ],
        child: MaterialApp(
          home: SafeArea(child: MyApp()),
          debugShowCheckedModeBanner: false,
        ),
      ),
    );

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WelcomePage();
  }
}
