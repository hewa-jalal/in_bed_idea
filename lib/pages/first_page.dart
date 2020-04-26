import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flushbar/flushbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:inbedidea/pages/music_page.dart';
import 'package:inbedidea/pages/notes_page.dart';
import 'package:inbedidea/models/user_model.dart';
import 'package:inbedidea/pages/welcome_page.dart';
import 'package:provider/provider.dart';
import 'package:screen/screen.dart';
import 'package:torch_compat/torch_compat.dart';

class FirstPage extends StatefulWidget {
  @override
  _FirstPageState createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  Firestore _firestore = Firestore.instance;
  String noteText;
  GoogleSignIn _googleAuth = GoogleSignIn(scopes: ['email']);
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final authUser = Provider.of<FirebaseUser>(context);
    print('first page => ${authUser.email}');
    bool _isFlashOn = false;
//    Screen.setBrightness(0.0);
    Screen.keepOn(true);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.music_note),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => MusicPage()));
            },
          ),
          // <======= Note List Button ========>
          IconButton(
            icon: Icon(Icons.highlight),
            onPressed: () {
              if (_isFlashOn) {
                TorchCompat.turnOff();
                _isFlashOn = false;
              } else {
                TorchCompat.turnOn();
                _isFlashOn = true;
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
            child: Text('Log out'),
            onPressed: signOut,
          )
        ],
      ),
      body: Container(
        margin: EdgeInsets.all(4),
        child: Container(
          height: double.infinity,
          child: TextField(
            decoration: InputDecoration.collapsed(
              hintText: 'Write down your great idea...',
            ),
            onChanged: (value) => noteText = value.trim(),
          ),
        ),
      ),
      floatingActionButton: Builder(
        builder: (context) => FloatingActionButton(
          child: Icon(Icons.check),
          onPressed: () {
            if (noteText.isEmpty) {
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Text('Please write something'),
                ),
              );
            } else {
              _firestore.collection('notes').add({
                'text': noteText,
                'userId': authUser.uid,
                'userName': authUser.email,
                'date': DateTime.now()
              });
              FlushbarHelper.createSuccess(message: 'Idea saved')
                ..show(context);
            }
          },
        ),
      ),
    );
  }

  void signOut() {
    setState(() {
      _googleAuth.signOut();
      _auth.signOut();
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => WelcomePage()));
    });
  }
}
