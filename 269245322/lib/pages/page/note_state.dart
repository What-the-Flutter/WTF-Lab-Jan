import '../../models/note_model.dart';
import '../../models/page_model.dart';

class NoteState {
  final int? noteIcon;
  final bool showNoteIconMenue;
  final bool isSerchBarDisplayed;
  final bool isUserEditingeNote;

  final PageModel? page;
  final NoteModel? note;

  final List<NoteModel>? notesList;
  final List<NoteModel>? searchNotesList;
  final List<NoteModel>? selcetedNotes;

  const NoteState({
    this.page,
    this.notesList,
    this.searchNotesList,
    this.selcetedNotes,
    this.note,
    required this.isUserEditingeNote,
    required this.showNoteIconMenue,
    required this.isSerchBarDisplayed,
    this.noteIcon,
  });

  NoteState copyWith({
    final NoteModel? note,
    final List<NoteModel>? notesList,
    final List<NoteModel>? searchNotesList,
    final List<NoteModel>? selcetedNotes,
    final bool? isUserEditingeNote,
    final PageModel? page,
    final bool? showNoteIconMenue,
    final bool? isSerchBarDisplayed,
    final int? noteIcon,
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
}
