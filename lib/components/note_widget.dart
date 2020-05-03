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
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
          ),
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: Column(
                children: <Widget>[
                  Text(
                    '$noteText \n',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: FittedBox(
                      fit: BoxFit.fitWidth,
                      child: RichText(
                        text: TextSpan(children: <TextSpan>[
                          TextSpan(
                              text: 'Idea was captured at: ',
                              style: TextStyle(fontSize: 22)),
                          TextSpan(text: '\n'),
                          TextSpan(
                            text: '  $date',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 22),
                          )
                        ]),
                      ),
                    ),
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
