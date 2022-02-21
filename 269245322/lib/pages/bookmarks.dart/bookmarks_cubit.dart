import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_lab_project/database/firebase_repository.dart';
import 'package:my_lab_project/pages/bookmarks.dart/bookmarks_state.dart';

import '../../shared_preferences/sp_settings_helper.dart';
import '../../style/app_themes.dart';
import '../../style/theme_cubit.dart';

class BookmarksCubit extends Cubit<BookmarksState> {
  final FireBaseNoteHelper _fireBaseNoteHelper = FireBaseNoteHelper();

  BookmarksCubit()
      : super(
          BookmarksState(
            notesList: [],
            pagesFilterList: [],
            iconsFilterList: [],
            bookmarkButtonEnable: false,
          ),
        );

  void initState() async {
    emit(
      state.copyWith(notesList: await _fireBaseNoteHelper.getAllNotes()),
    );
  }

  void initPagesFilterList() {}

  void updatePagesFilterList() {}

  void initiconsFilterList() {}

  void updateiconsFilterList() {}

  void applyFiltersToNotesList() {}

  void bookmarkButtonEnable(bool state) {}
}
