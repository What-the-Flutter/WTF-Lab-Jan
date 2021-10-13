import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/events_model.dart';
import '../../repository/pages_repository.dart';
import 'add_page_state.dart';

class AddPageCubit extends Cubit<AddPageState> {
  final PagesRepository pagesRepository;
  AddPageCubit(this.pagesRepository)
      : super(
          AddPageState(selectedIconIndex: 0, eventPages: []),
        );

  void addPage(
    String text,
    List iconsList
  )  {
    final page = EventPages(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: text,
      date: DateTime.now(),
      icon: iconsList[state.selectedIconIndex],
      isFixed: false,
    );
    pagesRepository.insertPage(page);
  }

  Future<void> init() async {
    emit(
      state.copyWith(
        eventPages: await pagesRepository.eventPagesList(),
      ),
    );
  }

  void edit(
    int selectedPageIndex,
    String text,
    List iconsList,
  ) {
    final tempEventPage = state.eventPages[selectedPageIndex].copyWith(
      name: text,
      icon: iconsList[state.selectedIconIndex],
    );
    pagesRepository.updatePage(tempEventPage);
  }

  void setIconIndex(int i) {
    emit(
      state.copyWith(selectedIconIndex: i),
    );
  }

  void returnToHomePage(
    bool needsEditing,
    int selectedPageIndex,
    String text,
    List iconsList,
  ) {
    if (needsEditing) {
      init();
      edit(selectedPageIndex, text, iconsList);
    } else {
      addPage(text, iconsList);
    }
  }
}
