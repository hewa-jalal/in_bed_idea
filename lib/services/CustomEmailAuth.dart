import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../pages/first_page.dart';

class CustomEmailAuth {
  FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> signUp(email, password, context) async {
    try {
      final newUser = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
//      Provider.of<UserModel>(context, listen: false)
//          .saveValue(newUser.user.uid, newUser.user.email);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => FirstPage()));
    } catch (e) {
      switch (e.code) {
        case 'ERROR_WEAK_PASSWORD':
          print('weak password');
          break;
      }
    }
  }

  _loginWithEmail(email, password, context) async {
    try {
      final user = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      if (user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => FirstPage()),
        );
      }
    } catch (error) {
      print('loginnnnnn $error');
    }
  }
}

final CustomEmailAuth customEmailAuth = CustomEmailAuth();
