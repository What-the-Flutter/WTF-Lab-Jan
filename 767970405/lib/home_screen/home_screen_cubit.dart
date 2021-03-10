import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:my_chat_journal/data/model/model_page.dart';
import 'package:my_chat_journal/data/repository/messages_repository.dart';
import 'package:my_chat_journal/data/repository/pages_repository.dart';


part 'home_screen_state.dart';

class HomeScreenCubit extends Cubit<HomeScreenState> {
  final PagesRepository repository;

  HomeScreenCubit({
    this.repository,
  }) : super(
          HomeScreenState(
            list: repository.eventPages,
          ),
        );

  void removePage(int index) {
    repository.removePage(index);
    emit(HomeScreenState(list: List.from(repository.eventPages)));
  }

  void addPage(ModelPage page) {
    repository.addPage(
      page.copyWith(
        isPin: false,
        creationTime: DateTime.now(),
        messages: MessagesRepository(),
        lastModifiedTime: DateTime.now(),
      ),
    );
    emit(HomeScreenState(list: List.from(repository.eventPages)));
  }

  void pinPage(int index) {
    repository.eventPages[index] = state.list[index].copyWith(
      isPin: !state.list[index].isPin,
    );
    repository.eventPages.sort();
    emit(HomeScreenState(list: List.from(repository.eventPages)));
  }

  void editPage(int index, ModelPage page) {
    repository.eventPages[index] = repository.eventPages[index].copyWith(
      title: page.title,
      icon: page.icon,
    );
    emit(HomeScreenState(list: List.from(repository.eventPages)));
  }
}
