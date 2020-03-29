import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:inbedidea/pages/first_page.dart';
import 'package:inbedidea/models/user_model.dart';
import 'package:provider/provider.dart';
import 'account_page.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _auth = FirebaseAuth.instance;
  FirebaseUser loggedInUser;
  String email;
  String password;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  getCurrentUser() async {
    try {
      final user = await _auth.currentUser();
      if (user != null) {
        loggedInUser = user;
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(60.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                decoration: InputDecoration(hintText: 'Enter your email'),
                onChanged: (value) {
                  email = value.trim();
                },
              ),
              TextField(
                decoration: InputDecoration(hintText: 'Enter your password'),
                obscureText: true,
                onChanged: (value) {
                  password = value.trim();
                },
              ),
              RaisedButton(
                onPressed: () async {
                  try {
                    final newUser = await _auth.createUserWithEmailAndPassword(
                        email: email, password: password);
                    Provider.of<UserModel>(context, listen: false)
                        .saveValue(newUser.user.uid);
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => FirstPage()));
                  } catch (e) {
                    print('new User $e');
                  }
                },
                child: Text('Done'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
