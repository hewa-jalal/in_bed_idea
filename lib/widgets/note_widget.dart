import 'package:flutter/material.dart';

class NoteWidget extends StatelessWidget {
  final String noteText;
  final String userId;
  final String userName;
  final String date;

  NoteWidget(this.noteText, this.userId, this.userName, this.date);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white24,
      child: Container(
        child: ExpansionTile(
          title: Text(
            noteText,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            softWrap: false,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
          ),
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: Column(
                children: <Widget>[
                  Text(
                    noteText,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
                  ),
                  Text(
                    userId,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
                  ),
                  Text(
                    userName ?? 'null',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
                  ),
                  Text(
                    date ?? 'null',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
