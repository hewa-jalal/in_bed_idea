import 'package:admob_flutter/admob_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:inbedidea/components/teddy_animations.dart';
import 'package:inbedidea/pages/welcome_page.dart';
import 'package:inbedidea/services/user_auth.dart';
import 'package:provider/provider.dart';

GetIt getIt = GetIt.instance;
final _appId = 'ca-app-pub-2856464717670030~1594650793';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  getIt.registerSingleton<UserAuth>(UserAuth());
  Admob.initialize(_appId);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<FirebaseUser>.value(
            value: FirebaseAuth.instance.onAuthStateChanged),
        ChangeNotifierProvider<TeddyAnimations>(
          create: (_) => TeddyAnimations(),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: WelcomePage(),
      ),
    );
  }
}
