import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_lab_project/models/page_model.dart';
import '../../database/firebase_repository.dart';
import '../../models/note_model.dart';

import 'statistics_state.dart';

class StatisticsCubit extends Cubit<StatisticsState> {
  final FireBaseNoteHelper _fireBaseNoteHelper = FireBaseNoteHelper();
  final FireBasePageHelper _fireBasePageHelper = FireBasePageHelper();

  StatisticsCubit()
      : super(
          StatisticsState(
            pagesList: [],
            filteredPagesList: [],
            notesList: [],
            totalNotesCount: 0,
            totalPagesCount: 0,
            totalBookmarksCount: 0,
            period: periods.month,
          ),
        );

  void initState() async {
    final initPagesList = await _fireBasePageHelper.getEntityList(null);
    final initNotesList = await _fireBaseNoteHelper.getAllNotes();

    final initBookMerkedNotesList = <NoteModel>[];
    for (final note in initNotesList) {
      if (note.isFavorite == true) initBookMerkedNotesList.add(note);
    }

    emit(
      state.copyWith(
        pagesList: initPagesList,
        filteredPagesList: initPagesList,
        notesList: initNotesList,
        totalNotesCount: initNotesList.length,
        totalPagesCount: initPagesList.length,
        totalBookmarksCount: initBookMerkedNotesList.length,
      ),
    );
  }

  void changePeriod(int index) {
    final newPeriod = periods.values.elementAt(index);
    _emitFilterByPeriod(newPeriod);
    emit(
      state.copyWith(
        period: newPeriod,
      ),
    );
  }

  void _emitFilterByPeriod(periods period) {
    final List<PageModel> newFilteredPagesList;
    switch (period) {
      case periods.day:
        newFilteredPagesList = _filterByPeriod(1);
        break;
      case periods.week:
        newFilteredPagesList = _filterByPeriod(7);
        break;
      case periods.month:
        newFilteredPagesList = _filterByPeriod(30);
        break;
    }
    emit(state.copyWith(filteredPagesList: newFilteredPagesList));
  }

  List<PageModel> _filterByPeriod(int numOfDays) {
    final resultNotesList = <PageModel>[];
    for (final page in state.pagesList) {
      final pageDateTime = DateTime.parse(page.cretionDate);
      final difference = (DateTime.now().month * 30 + DateTime.now().day) -
          (pageDateTime.month * 30 + pageDateTime.day);
      print('1: ${DateTime.now().month * 30 + DateTime.now().day}');
      print('2: ${pageDateTime.month * 30 + pageDateTime.day}');
      print(difference);
      if (difference <= numOfDays) resultNotesList.add(page);
    }
    return resultNotesList;
  }
}
