import 'package:flutter_bloc/flutter_bloc.dart';

import '../../database/firebase_repository.dart';
import '../../database/sqlite_repository.dart';
import '../../models/page_model.dart';
import '../../services/entity_repository.dart';
import '../../shared_preferences/sp_settings_helper.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final SharedPreferencesProvider _sharedPreferencesProvider =
      SharedPreferencesProvider();

  late final IRepository<PageModel> dbPageHelper =
      (_sharedPreferencesProvider.getDatabase() == 0)
          ? FireBasePageHelper()
          : SqlitePageRepository();

  HomeCubit() : super(const HomeState(listOfPages: []));

  void init() async {
    emit(
      state.copyWith(listOfPages: await dbPageHelper.getEntityList(null)),
    );
  }

  void deletePage(int index, PageModel page) {
    final newListOfPages = state.listOfPages!;
    newListOfPages.removeAt(index);
    emit(state.copyWith(listOfPages: newListOfPages));

    dbPageHelper.delete(page, null);
  }
}
