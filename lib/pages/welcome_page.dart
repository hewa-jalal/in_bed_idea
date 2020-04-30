import 'package:argon_buttons_flutter/argon_buttons_flutter.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flare_flutter/flare_controller.dart';
import 'package:flushbar/flushbar_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:getflutter/components/button/gf_button.dart';
import 'package:getflutter/components/button/gf_button_bar.dart';
import 'package:getflutter/components/card/gf_card.dart';
import 'package:getflutter/getflutter.dart';
import 'package:getflutter/shape/gf_button_shape.dart';
import 'package:getflutter/types/gf_button_type.dart';
import 'package:inbedidea/components/my_text_field.dart';
import 'package:inbedidea/services/user_auth.dart';
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

  String animation = 'no_pass_email';
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
    ScreenUtil.init(context);
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
                  horizontal: ScreenUtil().setWidth(60),
                  vertical: ScreenUtil().setHeight(80)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  AspectRatio(
                    aspectRatio: 1,
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
              padding: const EdgeInsets.all(8.0),
              child: Visibility(
                visible: !_isSignUp,
                child: FlatButton(
                  onPressed: () {},
                  color: Colors.blue[200],
                  child: Text(
                    'Forgot password?',
                    style: TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
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
                            message: 'Please enter you '
                                'email and password')
                          ..show(context);
                      } else {
                        if (btnState == ButtonState.Idle && mounted)
                          startLoading();
                        try {
                          final user =
                              await userAuth.signInWithEmail(email, password);
                          if (user != null) {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => FirstPage()));
                          }
                        } catch (e) {
                          print('eeeeeee ${e.message}');
                        }
                        stopLoading();
                      }
                    },
                    child: Text('Done'),
                    width: 130,
                    height: 60,
                  ),
                ),
                Spacer(
                  flex: 2,
                )
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
        width: ScreenUtil.screenWidth,
        padding: EdgeInsets.all(10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            color: Colors.white),
        child: Text(
          'Login',
          style: TextStyle(
              fontSize: ScreenUtil().setSp(100, allowFontScalingSelf: true),
              color: Colors.blue),
        ),
      ),
    );
  }

  // register button
  Widget _registerButton() {
    return SizedBox(
      width: ScreenUtil.screenWidth,
      height: 140.h,
      child: GFButton(
        onPressed: () {
          setState(() {
            isLoginForm = true;
            _isSignUp = true;
            _showGoogleSignIn = false;
            smallerHeight();
          });
        },
        text: 'Register now',
        textStyle: TextStyle(
            fontSize: ScreenUtil().setSp(100, allowFontScalingSelf: true),
            color: Colors.white),
        textColor: Colors.black,
        shape: GFButtonShape.square,
        type: GFButtonType.outline2x,
        color: Colors.white,
        fullWidthButton: true,
      ),
    );
  }
}
