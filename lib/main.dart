import 'package:device_preview/device_preview.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:inbedidea/pages/welcome_page.dart';
import 'package:inbedidea/services/user_auth.dart';
import 'package:provider/provider.dart';

import 'pages/first_page.dart';

GetIt getIt = GetIt.instance;

void main() {
  runApp(MyApp());
  getIt.registerSingleton<UserAuth>(UserAuth());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<FirebaseUser>.value(
            value: FirebaseAuth.instance.onAuthStateChanged),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: WelcomePage(),
      ),
    );
  }
}
