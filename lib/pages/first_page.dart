import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
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
    final userId = Provider.of<UserModel>(context, listen: false).userId;
    final userName = Provider.of<UserModel>(context, listen: false).userName;
    bool isFlashOn = false;
    Screen.setBrightness(0.0);
    Screen.keepOn(true);
    return Scaffold(
      appBar: AppBar(
        title: Text('In bed ideas'),
        actions: <Widget>[
          // <======= Lamp Button ======>
          IconButton(
            icon: Icon(Icons.highlight),
            onPressed: () {
              if (isFlashOn) {
                TorchCompat.turnOff();
                isFlashOn = false;
              } else {
                TorchCompat.turnOn();
                isFlashOn = true;
              }
            },
          ),
          // <======= Note List Button ========>
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
              _firestore.collection('notes').add(
                  {'text': noteText, 'userId': userId, 'userName': userName});
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Text('Note Saved'),
                ),
              );
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
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => WelcomePage()));
    });
  }
}
