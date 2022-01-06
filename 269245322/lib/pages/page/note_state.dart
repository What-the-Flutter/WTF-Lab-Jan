import 'package:flutter/cupertino.dart';

import '../../models/note_model.dart';
import '../../models/page_model.dart';

class NoteState {
  final bool? isUserEditingeNote;
  final NoteModel? note;
  final List<NoteModel>? notesList;
  final List<NoteModel>? searchNotesList;

  final List<NoteModel>? selcetedNotes;
  final PageModel? page;
  final bool? showNoteIconMenue;
  final bool? isSerchBarDisplayed;
  final IconData? noteIcon;

  NoteState copyWith({
    final NoteModel? note,
    final List<NoteModel>? notesList,
    final List<NoteModel>? searchNotesList,
    final List<NoteModel>? selcetedNotes,
    final bool? isUserEditingeNote,
    final PageModel? page,
    final bool? showNoteIconMenue,
    final bool? isSerchBarDisplayed,
    final IconData? noteIcon,
  }) {
    return NoteState(
      isUserEditingeNote: isUserEditingeNote ?? this.isUserEditingeNote,
      note: note ?? this.note,
      notesList: notesList ?? this.notesList,
      searchNotesList: searchNotesList ?? this.searchNotesList,
      selcetedNotes: selcetedNotes ?? this.selcetedNotes,
      page: page ?? this.page,
      showNoteIconMenue: showNoteIconMenue ?? this.showNoteIconMenue,
      isSerchBarDisplayed: isSerchBarDisplayed ?? this.isSerchBarDisplayed,
      noteIcon: noteIcon ?? this.noteIcon,
    );
  }

  const NoteState({
    this.page,
    this.notesList,
    this.searchNotesList,
    this.selcetedNotes,
    this.note,
    this.isUserEditingeNote,
    this.showNoteIconMenue,
    this.isSerchBarDisplayed,
    this.noteIcon,
  });
}
