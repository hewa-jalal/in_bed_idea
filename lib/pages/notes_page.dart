import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inbedidea/models/user_model.dart';
import 'package:inbedidea/widgets/note_widget.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class NotesPage extends StatelessWidget {
  final Firestore _firestore = Firestore.instance;

  @override
  Widget build(BuildContext context) {
    final userId = Provider.of<FirebaseUser>(context).uid;
    return SafeArea(
      child: Scaffold(
        body: StreamBuilder<QuerySnapshot>(
          stream: _firestore
              .collection('notes')
              .where('userId', isEqualTo: userId)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return Center(
                child: CircularProgressIndicator(),
              );
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
    );
  }
}
