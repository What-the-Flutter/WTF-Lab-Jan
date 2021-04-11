import 'package:bloc/bloc.dart';

import '../../properties/property_page.dart';
import '../../repository/pages_repository.dart';

part 'home_screen_state.dart';

class HomeScreenCubit extends Cubit<HomeScreenState> {
  PagesRepository repository;

  HomeScreenCubit({
    this.repository,
  }) : super(
    HomeScreenStateAwait(currentIndex: 0),
  );

  void loadData() async {
    emit(
      HomeScreenStateShow(
        pages: await repository.pagesList(),
        currentIndex: state.currentIndex,
      ),
    );
  }

  void removePage(int index) async {
    repository.removeMessages(state.list[index].id);
    repository.removePage(state.list[index].id);
    final list = await repository.pagesList();
    list.sort();
    emit(
      state.copyWith(
        list: list,
      ),
    );
  }

  void addPage(PropertyPage page) async {
    repository.addPage(
      page.copyWith(
        isPin: false,
        creationTime: DateTime.now(),
        lastModifiedTime: DateTime.now(),
      ),
    );
    final list = await repository.pagesList();
    list.sort();
    emit(
      HomeScreenStateShow(
        pages: list,
        currentIndex: state.currentIndex,
      ),
    );
  }

  void editPage(PropertyPage page) async {
    repository.editPage(page);
    final list = await repository.pagesList();
    list.sort();
    emit(
      HomeScreenStateShow(
        pages: list,
        currentIndex: state.currentIndex,
      ),
    );
  }

  void pinPage(int index) async {
    repository.editPage(
      state.list[index].copyWith(
        isPin: !state.list[index].isPin,
      ),
    );
    final list = await repository.pagesList();
    list.sort();
    emit(
      state.copyWith(
        list: list,
      ),
    );
  }

  void gettingOutFreeze() {
    emit(
      HomeScreenStateShow(
        pages: state.list,
        currentIndex: state.currentIndex,
      ),
    );
  }
}
