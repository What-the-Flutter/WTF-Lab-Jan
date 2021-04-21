import 'package:bloc/bloc.dart';

import '../data/model/model_page.dart';
import '../data/repository/pages_repository.dart';

part 'home_screen_state.dart';

class HomeScreenCubit extends Cubit<HomeScreenState> {
  final PagesRepository repository;

  HomeScreenCubit({
    this.repository,
  }) : super(
          HomeScreenState(
            pages: <ModelPage>[],
            currentIndex: 0,
            isLoad: true,
          ),
        ) {
    loadData();
  }

  void loadData() async {
    await repository.pagesAPI.init();
    final pages = await repository.pages();
    pages.sort();
    emit(
      state.copyWith(
        pages: pages,
        isLoad: false,
      ),
    );
  }

  String receiveTitlePage(int pageId) {
    return state.pages
        .where((element) => element.id == pageId)
        .toList()[0]
        .title;
  }

  void removePage(int index) {
    repository.removeMessages(state.pages[index].id);
    repository.removePage(state.pages[index].id);
    state.pages.removeAt(index);
    emit(
      state.copyWith(
        pages: state.pages,
      ),
    );
  }

  void addPage(ModelPage page) async {
    var newPage = page.copyWith(
      isPinned: false,
      creationTime: DateTime.now(),
      lastModifiedTime: DateTime.now(),
    );
    var id = await repository.addPage(newPage);
    state.pages.add(newPage.copyWith(id: id));
    emit(
      state.copyWith(
        pages: state.pages,
      ),
    );
  }

  void pinPage(int index) {
    var editingPage = state.pages[index].copyWith(
      isPinned: !state.pages[index].isPinned,
    );
    repository.editPage(editingPage);
    state.pages[index] = editingPage;
    state.pages.sort();
    emit(
      state.copyWith(
        pages: state.pages,
      ),
    );
  }

  void editPage(ModelPage page) {
    repository.editPage(page);
    var list = state.pages.where((element) => element.id == page.id).toList();
    var index = state.pages.indexOf(list[0]);
    state.pages[index] = page;
    emit(
      state.copyWith(
        pages: state.pages,
      ),
    );
  }

  void changeScreen(int index) {
    emit(
      state.copyWith(
        currentIndex: index,
      ),
    );
  }
}
