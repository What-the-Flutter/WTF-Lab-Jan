import 'package:flutter_bloc/flutter_bloc.dart';

import '../../database.dart';
import '../../models/events_model.dart';
import 'add_page_state.dart';

class AddPageCubit extends Cubit<AddPageState> {
  AddPageCubit()
      : super(
          AddPageState(selectedIconIndex: 0, eventPages: []),
        );

  Future<void> addPage(
    String text,
    List iconsList,
  ) async {
    final page = EventPages(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: text,
      date: DateTime.now().millisecondsSinceEpoch,
      icon: iconsList[state.selectedIconIndex],
      isFixed: false,
    );
    await DBProvider.db.insertPage(page);
  }

  Future<void> init() async {
    emit(
      state.copyWith(
        eventPages: await DBProvider.db.eventPagesList(),
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
    DBProvider.db.updatePage(tempEventPage);
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
