import 'package:flutter/cupertino.dart';
import 'note_object.dart';

class PageObject {
  late String title;
  late IconData icon;
  late final Key pageKey;
  int numOfNotes = 0;
  late final DateTime cretionDate;
  DateTime get getCretionDate => cretionDate;
  late DateTime lastModifedDate;
  DateTime get getlastModifedDate => lastModifedDate;
  List<NoteObject> notesList = [];

  PageObject({
    required this.title,
    required this.icon,
  }) {
    pageKey = UniqueKey();
  }

  void addNote(NoteObject note) {
    notesList.add(note);
    numOfNotes++;
  }
}
