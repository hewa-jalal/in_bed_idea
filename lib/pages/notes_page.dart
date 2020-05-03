import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:inbedidea/components/note_widget.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class NotesPage extends StatelessWidget {
  final Firestore _firestore = Firestore.instance;

  @override
  Widget build(BuildContext context) {
    final userId = Provider.of<FirebaseUser>(context).uid;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.blueGrey[800],
        body: Padding(
          padding: const EdgeInsets.all(2.0),
          child: StreamBuilder<QuerySnapshot>(
            stream: _firestore
                .collection('notes')
                .where('userId', isEqualTo: userId)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData)
                return Center(
                  child: CircularProgressIndicator(),
                );
              else if (snapshot.data.documents.isEmpty) {
                return Center(
                  child: FittedBox(
                    child: Text(
                      'you don\'t have any notes',
                      style: TextStyle(fontSize: 26),
                    ),
                  ),
                );
              }
              final List<DocumentSnapshot> notes = snapshot.data.documents;
              List<NoteWidget> notesWidgets = [];
              for (var note in notes) {
                final noteText = note.data['text'];
                final noteId = note.data['userId'];
                final noteUserName = note.data['userName'];
                final date = DateFormat.yMd('en_US')
                    .add_jm()
                    .format(note.data['date'].toDate());
                final noteWidget =
                    NoteWidget(noteText, noteId, noteUserName, date);
                notesWidgets.add(noteWidget);
              }
              return ListView.builder(
                itemBuilder: (context, index) => notesWidgets[index],
                itemCount: notesWidgets.length,
              );
            },
          ),
        ),
      ),
    );
  }
}
