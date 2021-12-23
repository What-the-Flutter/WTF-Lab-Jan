import 'package:flutter/cupertino.dart';
import 'note_model.dart';

class PageModel {
  late String title;
  late IconData icon;
  late final Key pageKey;
  int numOfNotes = 0;
  late final DateTime cretionDate;
  DateTime get getCretionDate => cretionDate;
  late DateTime lastModifedDate;
  DateTime get getlastModifedDate => lastModifedDate;
  List<NoteModel> notesList = [];

  PageModel({
    required this.title,
    required this.icon,
  }) {
    pageKey = UniqueKey();
  }

  void addNote(NoteModel note) {
    notesList.add(note);
    numOfNotes++;
  }
}
