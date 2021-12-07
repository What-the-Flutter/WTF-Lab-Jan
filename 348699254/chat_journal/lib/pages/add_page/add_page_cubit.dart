import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import '../../data/models/activity_page.dart';
import '../../data/repository/page_repository.dart';
import 'add_page_state.dart';

class AddPageCubit extends Cubit<AddPageState> {
  final ActivityPageRepository pageRepository;

  AddPageCubit(this.pageRepository)
      : super(
    AddPageState(
      selectedIconIndex: 0,
      pageList: [],
    ),
  );

  void init() {
    emit(
      state.copyWith(
        selectedIconIndex: 0,
        pageList: state.pageList,
      ),
    );
  }

  void setIconIndex(int index) {
    emit(
      state.copyWith(selectedIconIndex: index),
    );
  }

  void addPage(String pageName, List iconList) {
    final page = ActivityPage(
      id: const Uuid().v4(),
      name: pageName,
      icon: iconList[state.selectedIconIndex],
      creationDate: DateTime.now().toString(),
      isPinned: false,
    );
    state.pageList.insert(0, page);
    pageRepository.insertActivityPage(page);
    emit(state.copyWith(pageList: state.pageList));
  }

  void edit(String pageName, List iconList, int selectedPageIndex) {
    final editedPage = state.pageList[selectedPageIndex].copyWith(
      name: pageName,
      icon: iconList[state.selectedIconIndex],
    );
    pageRepository.updateActivityPage(editedPage);
  }
}
