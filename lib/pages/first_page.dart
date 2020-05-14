import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flushbar/flushbar_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_size/flutter_keyboard_size.dart';
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
  String _noteText = '';
  Color _torchColor = Colors.white;
  bool _isFlashOn = false;
  double _teddyBottomPadding = 0.0;
  double _keyboardHeight;
  UserAuth _userAuth;
  FirebaseUser _authUser;
  TeddyAnimations _teddyAnimations;
  bool _firstPageLoad = true;
  TextEditingController _controller;
  bool _isConnectedToInternet = false;

  @override
  void initState() {
    super.initState();
    Screen.keepOn(true);
    _userAuth = getIt<UserAuth>();
    checkConnection();
  }

  void checkConnection() {
    Connectivity().onConnectivityChanged.listen((event) {
      if (event == ConnectivityResult.wifi ||
          event == ConnectivityResult.mobile)
        setState(() => _isConnectedToInternet = true);
      else if (event == ConnectivityResult.none)
        setState(() => _isConnectedToInternet = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    _authUser = Provider.of<FirebaseUser>(context);
    _teddyAnimations = Provider.of<TeddyAnimations>(context);
    _controller = TextEditingController();

    if (_firstPageLoad) {
      _teddyAnimations.changeAnimation(TeddyStatus.sleeping);
      _firstPageLoad = false;
    }

    return KeyboardSizeProvider(
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.check),
          onPressed: () => saveToFirestore(),
          backgroundColor: Colors.blueGrey[900],
        ),
        bottomNavigationBar: _isConnectedToInternet ? Ads() : SizedBox.shrink(),
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
                _teddyAnimations.changeAnimation(TeddyStatus.idle);
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => WelcomePage()));
              },
            )
          ],
        ),
        body: Consumer<ScreenHeight>(
          builder: (context, _res, child) {
            if (_res.isOpen)
              _teddyBottomPadding = _res.keyboardHeight / 2;
            else if (!_res.isOpen) _teddyBottomPadding = 0;
            return Container(
              color: Colors.blueGrey[400],
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 6, top: 6),
                      child: TextField(
                        controller: _controller,
                        maxLines: null,
                        onTap: () => _teddyAnimations
                            .changeAnimation(TeddyStatus.wakeUp),
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration.collapsed(
                          hintText: 'Write down your great idea...',
                        ),
                        onChanged: (value) {
                          _noteText = value.trim();
                        },
                        onSubmitted: (_) => saveToFirestore(),
                      ),
                    ),
                  ),
                  Consumer<TeddyAnimations>(
                    builder: (BuildContext context, TeddyAnimations value,
                        Widget child) {
                      return Expanded(
                        flex: 3,
                        child: Padding(
                          padding: EdgeInsets.only(bottom: _teddyBottomPadding),
                          child: Hero(
                            tag: 'teddyHero',
                            child: FlareActor(
                              'assets/teddy.flr',
                              animation: value.animation,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  saveToFirestore() {
    if (_noteText.isEmpty)
      FlushbarHelper.createError(message: 'Please enter an idea')
        ..show(context);
    else {
      _teddyAnimations.changeAnimation(TeddyStatus.sleeping);
      _controller.clear();
      _firestore.collection('notes').add({
        'text': _noteText,
        'userId': _authUser.uid,
        'userName': _authUser.email,
        'date': DateTime.now()
      });
      FlushbarHelper.createSuccess(message: 'idea saved')..show(context);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
