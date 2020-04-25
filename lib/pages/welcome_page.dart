import 'package:firebase_auth/firebase_auth.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flare_flutter/flare_controller.dart';
import 'package:flutter/material.dart';
import 'package:getflutter/components/button/gf_button.dart';
import 'package:getflutter/shape/gf_button_shape.dart';
import 'package:getflutter/types/gf_button_type.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:inbedidea/pages/login_page.dart';
import 'package:inbedidea/pages/signup_page.dart';
import 'package:inbedidea/size_config.dart';

import 'first_page.dart';

class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final _googleAuth = GoogleSignIn();

  @override
  void initState() {
    super.initState();
//    googleSignInSilent();
  }

  void googleSignInSilent() {
    _googleAuth.signInSilently(suppressErrors: false).then((account) {
      if (account != null) {
        setState(() {
          print('user signed in silently');
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => FirstPage()),
          );
        });
      }
    });
  }

  String animation = 'idle';
  bool getLoginForm = false;

  @override
  Widget build(BuildContext context) {
    FlareController controller;
    SizeConfig().init(context);
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
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      color: Colors.grey.shade200,
                      offset: Offset(2, 4),
                      blurRadius: 5,
                      spreadRadius: 2)
                ],
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.grey, Colors.blue[200]])),
            child: WillPopScope(
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
                  SizedBox(height: 30),
                  Text(
                    'In Bed Ideas',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 80),
                  getLoginForm == true ? fieldCard() : registerBox()
                ],
              // ignore: missing_return
              ), onWillPop: () {
                setState(() {
                  getLoginForm = false;
                });
            },
            ),
          ),
        ),
      ),
    );
  }

  Widget registerBox() {
    return Column(
      children: <Widget>[
        _submitButton(),
        SizedBox(height: 20),
        _signUpButton(),
        SizedBox(height: 20),
      ],
    );
  }

  Widget fieldCard() {
    return Card(
      child: Column(
        children: <Widget>[
          TextField(
            decoration: InputDecoration(hintText: 'Login'),
          ),
          TextField(
            decoration: InputDecoration(hintText: 'Register'),
          )
        ],
      ),
    );
  }

  Widget _submitButton() {
    return InkWell(
      onTap: () {
        setState(() {
          getLoginForm = true;
        });
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
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

  Widget _signUpButton() {
    return GFButton(
      onPressed: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => LoginPage()));
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
