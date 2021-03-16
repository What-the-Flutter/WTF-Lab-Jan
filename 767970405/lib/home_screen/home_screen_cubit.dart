import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../data/model/model_page.dart';
import '../data/repository/pages_repository.dart';

part 'home_screen_state.dart';

class HomeScreenCubit extends Cubit<HomeScreenState> {
  final PagesRepository repository;

  HomeScreenCubit({
    this.repository,
  }) : super(
          HomeScreenAwait(currentIndex: 0),
        ) {
    loadData();
  }

  void loadData() async {
    emit(
      HomeScreenShow(
        pages: await repository.pages(),
        currentIndex: state.currentIndex,
      ),
    );
  }

  void removePage(int index) async {
    repository.removeMessages(state.list[index].id);
    repository.removePage(state.list[index].id);
    var list = await repository.pages();
    list.sort();
    emit(
      state.copyWith(
        list: list,
      ),
    );
  }

  void addPage(ModelPage page) async {
    repository.addPage(
      page.copyWith(
        isPin: false,
        creationTime: DateTime.now(),
        lastModifiedTime: DateTime.now(),
      ),
    );
    var list = await repository.pages();
    list.sort();
    emit(
      HomeScreenShow(
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
    var list = await repository.pages();
    list.sort();
    emit(
      state.copyWith(
        list: list,
      ),
    );
  }

  void editPage(ModelPage page) async {
    repository.editPage(page);
    var list = await repository.pages();
    list.sort();
    emit(
      HomeScreenShow(
        pages: list,
        currentIndex: state.currentIndex,
      ),
    );
  }

  void gettingOutFreeze() {
    emit(
      HomeScreenShow(
        pages: state.list,
        currentIndex: state.currentIndex,
      ),
    );
  }

  void changeScreen(int index) {
    emit(state.copyWith(currentIndex: index));
  }
}
