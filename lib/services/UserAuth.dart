import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:inbedidea/pages/first_page.dart';

class UserAuth {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<void> signInWithGoogle(context) async {
    final googleSignInAccount = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken);

    final AuthResult authResult = await _auth.signInWithCredential(credential);

    final user = authResult.user;
    print('succefful sign in with google ${user.email}');
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => FirstPage()));
  }

  void signOutGoogle() async {
    await _googleSignIn.signOut();
    print('user signed out');
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



}

final UserAuth userAuth = UserAuth();
