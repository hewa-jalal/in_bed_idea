import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:inbedidea/pages/first_page.dart';
import 'package:inbedidea/pages/signup_page.dart';
import 'package:inbedidea/models/user_model.dart';
import 'package:provider/provider.dart';

class AccountPage extends StatefulWidget {
  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  bool _isLoggedIn = false;

  GoogleSignIn _googleAuth = GoogleSignIn(scopes: ['email']);

  _login() async {
    try {
      await _googleAuth.signIn();
      setState(() {
        _isLoggedIn = true;
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => FirstPage()));
      });
    } catch (e) {
      print('error $e');
    }
  }

  _logout() {
    _googleAuth.signOut();
    setState(() {
      _isLoggedIn = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = _googleAuth.currentUser;
    if (_isLoggedIn) {
      print('is logged in');
      Provider.of<UserModel>(context).saveValue(user.id, user.displayName);
    }
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _isLoggedIn
                ? Column(
                    children: <Widget>[
                      Image.network(user.photoUrl),
                      Text(user.displayName),
                      Text(user.email),
                      OutlineButton(
                        onPressed: () {
                          _logout();
                        },
                        child: Text('Sign out'),
                      )
                    ],
                  )
                : // <======= Not logged in =======>
                Column(
                    children: <Widget>[
                      GoogleSignInButton(
                        onPressed: () {
                          _login();
                        },
                        darkMode: true,
                      ),
                      SizedBox(
                        width: 240,
                        child: FlatButton(
                          color: Colors.grey,
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SignUpPage()));
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(Icons.email),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Sign up with email',
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.white),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 240,
                        child: FlatButton(
                          color: Colors.grey,
                          onPressed: () {
                            showDialog(context: context, child: Text('Hello'));
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(Icons.email),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Sign In with email',
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.white),
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  )
          ],
        ),
      ),
    );
  }
}
