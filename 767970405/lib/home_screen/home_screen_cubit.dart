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
          HomeScreenAwait(0),
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
    print('');
  }

  void removePage(int index) async {
    repository.removePage(state.list[index].id);
    emit(
      state.copyWith(
        list: await repository.pages(),
      ),
    );
    print('');
  }

  void addPage(ModelPage page) async {
    repository.addPage(
      page.copyWith(
        isPin: false,
        creationTime: DateTime.now(),
        lastModifiedTime: DateTime.now(),
      ),
    );
    emit(
      state.copyWith(
        list: await repository.pages(),
      ),
    );
    print('');
  }

  void pinPage(int index) async {
    repository.editPage(
      state.list[index].copyWith(
        isPin: !state.list[index].isPin,
      ),
    );
    emit(
      state.copyWith(
        list: await repository.pages(),
      ),
    );
    state.list.sort();
    emit(state.copyWith(list: List<ModelPage>.from(state.list)));
  }

  void editPage(ModelPage page) async {
    repository.editPage(page);
    emit(
      state.copyWith(
        list: await repository.pages(),
      ),
    );
  }

  ModelPage getPage(int index) {
    return state.list[index];
  }

  // void addMessage(int index, List<ModelMessage> list) {
  //   repository.eventPages[index].messages.messages.addAll(list);
  // }

  void changeScreen(int index) {
    emit(state.copyWith(currentIndex: index));
  }
}
