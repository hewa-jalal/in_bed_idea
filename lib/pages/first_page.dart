import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flexible_toast/flutter_flexible_toast.dart';
import 'package:inbedidea/pages/notes_page.dart';
import 'package:inbedidea/models/user_model.dart';
import 'package:provider/provider.dart';
import 'package:screen/screen.dart';
import 'package:torch_compat/torch_compat.dart';

import 'account_page.dart';

class FirstPage extends StatefulWidget {
  @override
  _FirstPageState createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  Firestore _firestore = Firestore.instance;
  String noteText;

  @override
  Widget build(BuildContext context) {
  final userId = Provider.of<UserModel>(context, listen: false).userId;
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
          )
        ],
      ),
      body: Container(
        margin: EdgeInsets.all(4),
        child: TextField(
          decoration: InputDecoration.collapsed(
            hintText: 'Write down your great idea...',
          ),
          onChanged: (value) {
            noteText = value.trim();
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.check),
        onPressed: () {
          _firestore.collection('notes').add({
            'text': noteText,
            'userId': userId
          });
          FlutterFlexibleToast.showToast(message: 'Saved Note');
        },
      ),
    );
  }
}
