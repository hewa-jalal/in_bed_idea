import 'package:argon_buttons_flutter/argon_buttons_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flare_flutter/flare_controller.dart';
import 'package:flushbar/flushbar_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:getflutter/components/button/gf_button.dart';
import 'package:getflutter/components/button/gf_button_bar.dart';
import 'package:getflutter/components/card/gf_card.dart';
import 'package:getflutter/shape/gf_button_shape.dart';
import 'package:getflutter/types/gf_button_type.dart';
import 'package:inbedidea/components/my_text_field.dart';
import 'package:inbedidea/services/UserAuth.dart';
import 'package:inbedidea/size_config.dart';

import 'first_page.dart';

class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  void initState() {
    super.initState();
//    userAuth.googleSignInSilent(context);
  }

  String animation = 'idle';
  bool isLoginForm = false;
  bool _showGoogleSignIn = true;
  bool _isSignUp = false;
  String email = '';
  String password = '';
  double customHeight = 36;

  void smallerHeight() => customHeight = 10;

  @override
  Widget build(BuildContext context) {
    FlareController controller;
//    SizeConfig().init(context);
    return GestureDetector(
      onTap: () {
        setState(() {
          if (animation == 'success')
            animation = 'fail';
          else
            animation = 'success';
          print('tapped');
        });
      },
      child: SafeArea(
        child: Scaffold(
          body: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              height: MediaQuery
                  .of(context)
                  .size
                  .height,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.grey, Colors.blue[200]]),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Center(
                    child: Container(
                      width: 300,
                      height: 300,
                      child: CircleAvatar(
                        child: ClipOval(
                          child: FlareActor(
                            'assets/teddyyyy.flr',
                            animation: animation,
                          ),
                        ),
                        backgroundColor: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: customHeight),
                  isLoginForm == true ? _formCard() : welcomeBox(),
                  Visibility(
                    visible: _showGoogleSignIn,
                    child: GoogleSignInButton(
                      onPressed: () => userAuth.signInWithGoogle(context),
                      darkMode: true,
                    ),
                  ),
                ],
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
    return WillPopScope(
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
              padding: const EdgeInsets.all(6.0),
              child: Visibility(
                visible: !_isSignUp,
                child: Text(
                  'Forgot password?',
                  style: TextStyle(
                      fontSize: 24,
                      color: Colors.red[800],
                      fontWeight: FontWeight.bold),
                ),
              ),
            )
          ],
        ),
        buttonBar: GFButtonBar(
          alignment: WrapAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding:
                  const EdgeInsets.only(bottom: 20, right: 16),
                  child: IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      size: 46,
                      color: Colors.blue,
                    ),
                    onPressed: backToWelcomeBox,
                  ),
                ),
                SizedBox(width: 40),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: ArgonButton(
                    loader: SpinKitFadingCircle(
                      color: Colors.white,
                    ),
                    onTap: (startLoading, stopLoading, btnState) async {
                      if (email.isEmpty || password.isEmpty) {
                        FlushbarHelper.createError(
                            message: 'Please enter you '
                                'email and password')
                          ..show(context);
                      } else {
                        if (btnState == ButtonState.Idle && mounted)
                          startLoading();
                        await userAuth.signInWithEmail(
                            email, password, context);
                        stopLoading();
                      }
                    },
                    child: Text('Done'),
                    width: 130,
                    height: 60,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      onWillPop: () => backToWelcomeBox(),
    );
  }

  // a method to go back to welcome box on back button press
  backToWelcomeBox() {
    setState(() {
      isLoginForm = false;
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
          isLoginForm = true;
          _showGoogleSignIn = false;
        });
      },
      child: Container(
        width: MediaQuery
            .of(context)
            .size
            .width,
        padding: EdgeInsets.symmetric(vertical: 13),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            color: Colors.white),
        child: Text(
          'Login',
          style: TextStyle(fontSize: 20, color: Colors.blue),
        ),
      ),
    );
  }

  // register button
  Widget _registerButton() {
    return GFButton(
      onPressed: () {
        setState(() {
          isLoginForm = true;
          _isSignUp = true;
          _showGoogleSignIn = false;
          smallerHeight();
        });
      },
      text: 'Register now',
      textStyle: TextStyle(fontSize: 24),
      textColor: Colors.black,
      shape: GFButtonShape.square,
      type: GFButtonType.outline2x,
      color: Colors.white,
      size: 46,
      fullWidthButton: true,
    );
  }
}
