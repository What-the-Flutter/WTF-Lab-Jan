import 'package:my_lab_project/models/note_model.dart';

import '../../models/page_model.dart';

enum periods {
  day,
  week,
  month,
}

class StatisticsState {
  final List<PageModel> pagesList;
  final List<PageModel> filteredPagesList;
  final List<NoteModel> notesList;
  final int totalNotesCount;
  final int totalPagesCount;
  final int totalBookmarksCount;
  final periods period;

  StatisticsState({
    required this.pagesList,
    required this.filteredPagesList,
    required this.notesList,
    required this.totalNotesCount,
    required this.totalPagesCount,
    required this.totalBookmarksCount,
    required this.period,
  });

  StatisticsState copyWith({
    final List<PageModel>? pagesList,
    final List<PageModel>? filteredPagesList,
    final List<NoteModel>? notesList,
    final int? totalNotesCount,
    final int? totalPagesCount,
    final int? totalBookmarksCount,
    final periods? period,
  }) {
    return StatisticsState(
      pagesList: pagesList ?? this.pagesList,
      filteredPagesList: filteredPagesList ?? this.filteredPagesList,
      notesList: notesList ?? this.notesList,
      totalNotesCount: totalNotesCount ?? this.totalNotesCount,
      totalPagesCount: totalPagesCount ?? this.totalPagesCount,
      totalBookmarksCount: totalBookmarksCount ?? this.totalBookmarksCount,
      period: period ?? this.period,
    );
  }
}
