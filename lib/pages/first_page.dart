import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flushbar/flushbar_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:inbedidea/components/brightness_slider.dart';
import 'package:inbedidea/components/teddy_animations.dart';
import 'package:inbedidea/main.dart';
import 'package:inbedidea/pages/ads.dart';
import 'package:inbedidea/pages/music_page.dart';
import 'package:inbedidea/pages/notes_page.dart';
import 'package:inbedidea/pages/welcome_page.dart';
import 'package:inbedidea/services/user_auth.dart';
import 'package:provider/provider.dart';
import 'package:screen/screen.dart';
import 'package:torch_compat/torch_compat.dart';

class FirstPage extends StatefulWidget {
  @override
  _FirstPageState createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  Firestore _firestore = Firestore.instance;
  String noteText = '';
  GoogleSignIn _googleAuth = GoogleSignIn(scopes: ['email']);
  final _auth = FirebaseAuth.instance;
  Color _torchColor = Colors.white;
  bool _isFlashOn = false;
  UserAuth _userAuth;
  FirebaseUser authUser;
  TeddyAnimations teddyAnimations;
  bool _firstPageLoad = true;

  @override
  void initState() {
    super.initState();
    Screen.keepOn(true);
    _userAuth = getIt<UserAuth>();
  }

  @override
  Widget build(BuildContext context) {
    authUser = Provider.of<FirebaseUser>(context);
    teddyAnimations = Provider.of<TeddyAnimations>(context);

    if (_firstPageLoad) {
      teddyAnimations.changeAnimation(TeddyStatus.sleeping);
      _firstPageLoad = false;
    }

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.check),
        onPressed: () => saveToFirestore(),
        backgroundColor: Colors.blueGrey[900],
      ),
      bottomNavigationBar: Ads(),
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[900],
        automaticallyImplyLeading: false,
        actions: <Widget>[
          Expanded(child: BrightnessSlider()),
          IconButton(
            icon: Icon(Icons.music_note),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => MusicPage()));
            },
          ),
          // <======= Note List Button ========>
          IconButton(
            icon: Icon(Icons.highlight, color: _torchColor),
            onPressed: () {
              if (_isFlashOn) {
                TorchCompat.turnOff();
                _isFlashOn = false;
                setState(() => _torchColor = Colors.white);
              } else {
                TorchCompat.turnOn();
                _isFlashOn = true;
                setState(() => _torchColor = Colors.blue);
              }
            },
          ),
          IconButton(
            icon: Icon(Icons.list),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => NotesPage()),
            ),
          ),
          FlatButton(
            child: Text(
              'Log out',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              _userAuth.signOut();
              teddyAnimations.changeAnimation(TeddyStatus.idle);
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => WelcomePage()));
            },
          )
        ],
      ),
      body: Container(
        color: Colors.blueGrey[400],
        child: Column(
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 6),
                child: TextField(
                  maxLines: null,
                  onTap: () =>
                      teddyAnimations.changeAnimation(TeddyStatus.wakeUp),
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration.collapsed(
                    hintText: 'Write down your great idea...',
                  ),
                  onChanged: (value) => noteText = value.trim(),
                  onSubmitted: (_) => saveToFirestore(),
                ),
              ),
            ),
            Consumer<TeddyAnimations>(
              builder:
                  (BuildContext context, TeddyAnimations value, Widget child) {
                return Expanded(
                  flex: 3,
                  child: Hero(
                    tag: 'teddyHero',
                    child: FlareActor(
                      'assets/teddy.flr',
                      animation: value.animation,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  saveToFirestore() {
    if (noteText.isEmpty)
      FlushbarHelper.createError(message: 'Please enter an idea')
        ..show(context);
    else {
      teddyAnimations.changeAnimation(TeddyStatus.sleeping);
      _firestore.collection('notes').add({
        'text': noteText,
        'userId': authUser.uid,
        'userName': authUser.email,
        'date': DateTime.now()
      });
      FlushbarHelper.createSuccess(message: 'Idea saved')..show(context);
    }
  }
}
