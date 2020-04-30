import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:inbedidea/pages/first_page.dart';

class UserAuth {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  FirebaseUser user;

  Future<void> signInWithGoogle(context) async {
    final GoogleSignInAccount googleSignInAccount =
        await _googleSignIn.signIn();

    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken);

    final AuthResult authResult = await _auth.signInWithCredential(credential);

    final FirebaseUser user = authResult.user;

    print('succefful sign in with google ${user.email}');
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => FirstPage()));
  }

  void signOutGoogle() async {
    await _googleSignIn.signOut();
    print('user signed out');
  }

  Future<void> getUser() async {
    user = await _auth.currentUser();
  }

  void googleSignInSilent(context) {
    _googleSignIn.signInSilently(suppressErrors: false).then(
      (account) {
        if (account != null) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => FirstPage()),
          );
        }
      },
    );
  }

  // ignore: missing_return
  Future<String> createAccountWithEmail(
      String email, String password, BuildContext context) async {
    try {
      final user = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      if (user != null) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => FirstPage()));
        return 'successfully signed up';
      }
    } on PlatformException catch (e) {
      switch (e.code) {
        case 'ERROR_WEAK_PASSWORD':
          return 'Please provide a strong password';
        case 'ERROR_INVALID_EMAIL':
          return 'Please provide a correct email';
        case 'ERROR_EMAIL_ALREADY_IN_USE':
          return 'The email address is already in use, try to log in!';
      }
    }
  }

  Future<String> signInWithEmail(
      String email, String password, BuildContext context) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => FirstPage()));
      return 'successful sign in';
    } on PlatformException catch (e) {
      switch (e.code) {
        case 'ERROR_INVALID_EMAIL':
          return 'Please enter a valid email';
        case 'ERROR_WRONG_PASSWORD':
          return 'Please enter a correct password';
        case 'ERROR_USER_NOT_FOUND':
          return 'No user exists with this email';
        default:
          return 'defualt case';
      }
    }
  }

  signOut() async {
    if (_googleSignIn.currentUser != null)
      _googleSignIn.signOut();
    else
      await _auth.signOut();
  }
}

final UserAuth userAuth = UserAuth();
