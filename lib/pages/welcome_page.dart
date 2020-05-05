import 'package:argon_buttons_flutter/argon_buttons_flutter.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flushbar/flushbar_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:getflutter/components/button/gf_button.dart';
import 'package:getflutter/components/button/gf_button_bar.dart';
import 'package:getflutter/components/card/gf_card.dart';
import 'package:getflutter/getflutter.dart';
import 'package:getflutter/shape/gf_button_shape.dart';
import 'package:getflutter/types/gf_button_type.dart';
import 'package:inbedidea/components/my_text_field.dart';
import 'package:inbedidea/components/teddy_animations.dart';
import 'package:inbedidea/main.dart';
import 'package:inbedidea/services/user_auth.dart';
import 'package:keyboard_avoider/keyboard_avoider.dart';
import 'package:provider/provider.dart';

class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  UserAuth _userAuth;

  @override
  void initState() {
    super.initState();
    _userAuth = getIt<UserAuth>();
//    _userAuth.googleSignInSilent(context);
  }

  bool _isAuthForm = false;
  bool _showGoogleSignIn = true;
  bool _isSignUp = false;
  String email = '';
  String password = '';
  double customHeight = 36;
  TeddyAnimations _teddyAnimations;

  void smallerHeight() => customHeight = 10;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          height: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.grey, Colors.blue[200]]),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: 80,
                horizontal: 30,
              ),
              child: Consumer<TeddyAnimations>(
                builder: (BuildContext context, TeddyAnimations value,
                    Widget child) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Hero(
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: CircleAvatar(
                            child: ClipOval(
                              child: FlareActor(
                                'assets/teddy.flr',
                                animation: value.animation,
                              ),
                            ),
                            backgroundColor: Colors.white,
                          ),
                        ), tag: 'teddyHero',
                      ),
                      SizedBox(height: customHeight),
                      _isAuthForm == true ? _formCard() : welcomeBox(),
                      Visibility(
                        visible: _showGoogleSignIn,
                        child: GoogleSignInButton(
                          onPressed: () => _userAuth.signInWithGoogle(context),
                          darkMode: true,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget welcomeBox() {
    return Column(
      children: <Widget>[
        _submitButton(),
        SizedBox(height: 20),
        _registerButton(),
        SizedBox(height: 20),
      ],
    );
  }

  Widget _formCard() {
    _teddyAnimations = Provider.of<TeddyAnimations>(context, listen: false);
    String message;
    String forgotMessage = '';
    return WillPopScope(
      child: KeyboardAvoider(
        child: GFCard(
          color: Colors.blueGrey,
          boxFit: BoxFit.cover,
          content: Column(
            children: <Widget>[
              MyTextField('Email', (value) => email = value.trim()),
              MyTextField(
                'Password',
                (value) => password = value.trim(),
                isPassword: true,
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Visibility(
                  visible: !_isSignUp,
                  child: FlatButton(
                    onPressed: () async {
                      if (email.isEmpty)
                        FlushbarHelper.createError(
                            message: 'Please enter an email')
                          ..show(context);
                      else {
                        forgotMessage = await _userAuth.resetPassword(email);
                        if (forgotMessage == 'sent an email to $email')
                          FlushbarHelper.createSuccess(message: forgotMessage)
                            ..show(context);
                        else
                          FlushbarHelper.createError(message: forgotMessage)
                            ..show(context);
                      }
                    },
                    color: Colors.blue[200],
                    child: Text(
                      'Forgot password?',
                      style: TextStyle(
                          fontSize: 26,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ],
          ),
          buttonBar: GFButtonBar(
            alignment: WrapAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20, right: 16),
                    child: IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        size: 46,
                        color: Colors.blue,
                      ),
                      onPressed: backToWelcomeBox,
                    ),
                  ),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: ArgonButton(
                      loader: SpinKitFadingCircle(
                        color: Colors.white,
                      ),
                      onTap: (startLoading, stopLoading, btnState) async {
                        if (email.isEmpty || password.isEmpty) {
                          FlushbarHelper.createError(
                              message: 'Please enter your '
                                  'email and password')
                            ..show(context);
                          _teddyAnimations.changeAnimation(TeddyStatus.fail,
                              isBackToIdle: true);
                        } else {
                          if (btnState == ButtonState.Idle && mounted)
                            startLoading();
                          if (_isSignUp)
                            message = await _userAuth.createAccountWithEmail(
                                email, password, context);
                          else
                            message = await _userAuth.signInWithEmail(
                                email, password, context);
                          stopLoading();
                          if (message == 'successfully signed in' ||
                              message == 'successfully signed up') {
                            FlushbarHelper.createSuccess(message: message)
                              ..show(context);
                            _teddyAnimations
                                .changeAnimation(TeddyStatus.success);
                          } else {
                            FlushbarHelper.createError(message: message)
                              ..show(context);
                            _teddyAnimations.changeAnimation(TeddyStatus
                                .fail, isBackToIdle: true);
                          }
                        }
                      },
                      child: Text('Done', style: TextStyle(fontSize: 24)),
                      width: 130,
                      height: 60,
                    ),
                  ),
                  Spacer(flex: 2)
                ],
              ),
            ],
          ),
        ),
      ),
      onWillPop: () => backToWelcomeBox(),
    );
  }

  // a method to go back to welcome box on back button press
  backToWelcomeBox() {
    setState(() {
      _isAuthForm = false;
      _showGoogleSignIn = true;
      _isSignUp = false;
      customHeight = 36;
    });
  }

  // logInButton
  Widget _submitButton() {
    return InkWell(
      onTap: () {
        setState(() {
          smallerHeight();
          _isAuthForm = true;
          _showGoogleSignIn = false;
        });
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(6),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            color: Colors.white),
        child: Text(
          'Login',
          style: TextStyle(fontSize: 40, color: Colors.blue),
        ),
      ),
    );
  }

  // register button
  Widget _registerButton() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 62,
      child: GFButton(
        onPressed: () {
          setState(() {
            _isAuthForm = true;
            _isSignUp = true;
            _showGoogleSignIn = false;
            smallerHeight();
          });
        },
        text: 'Register now',
        textStyle: TextStyle(fontSize: 40, color: Colors.white),
        textColor: Colors.black,
        shape: GFButtonShape.square,
        type: GFButtonType.outline2x,
        color: Colors.white,
        fullWidthButton: true,
      ),
    );
  }
}
