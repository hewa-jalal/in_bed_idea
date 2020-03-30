import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inbedidea/models/user_model.dart';
import 'package:inbedidea/pages/note_widget.dart';
import 'package:provider/provider.dart';

class NotesPage extends StatelessWidget {
  final Firestore _firestore = Firestore.instance;

  @override
  Widget build(BuildContext context) {
    final userId = Provider.of<UserModel>(context).userId;
    print('user Id in notes Page $userId');
    return Scaffold(
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
          final notes = snapshot.data.documents;
          List<NoteWidget> notesWidgets = [];
          for (var note in notes) {
            final noteText = note.data['text'];
            final noteId = note.data['userId'];
            final noteUserName = note.data['userName'];
            final noteWidget = NoteWidget(noteText, noteId, noteUserName);
            notesWidgets.add(noteWidget);
          }
          return ListView.builder(
            itemBuilder: (context, index) {
              NoteWidget noteWidget = notesWidgets[index];
              return noteWidget;
            },
            itemCount: notesWidgets.length,
          );
        },
      ),
    );
  }
}
