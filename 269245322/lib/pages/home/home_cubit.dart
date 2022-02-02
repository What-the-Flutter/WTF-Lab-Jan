import 'package:flutter_bloc/flutter_bloc.dart';
import '../../database/firebase_db_helper.dart';
import '../../database/note_db_helper.dart';

import '../../models/page_model.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final DBHelper _dbHelper = DBHelper();
  final FireBaseHelper _fireBaseHelper = FireBaseHelper();

  HomeCubit() : super(const HomeState(listOfPages: []));

  void init() async {
    emit(
      state.copyWith(listOfPages: await _fireBaseHelper.dbPagesList()),
    );
  }

  void deletePage(int index, PageModel page) {
    var newListOfPages = state.listOfPages!;
    newListOfPages.removeAt(index);
    emit(state.copyWith(listOfPages: newListOfPages));
    //_dbHelper.deleteAllNotesFromPage(page.title);
    //_dbHelper.deletePage(page);
    _fireBaseHelper.deletePage(page.dbTitle!);
  }
}
