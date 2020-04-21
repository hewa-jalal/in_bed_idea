class Note {
  final String noteText;
  final String noteId;
  final String noteUsername;
  final String date;

  Note(this.noteText, this.noteId, this.noteUsername, this.date);

  factory Note.fromMap(Map data) {
    return Note(data['text'], data['userId'], data['userName'], data['date']);
  }
}
