import 'package:bloc/bloc.dart';
import '../repository/messages_repository.dart';
import '../repository/pages_repository.dart';

import '../repository/property_page.dart';
import 'event_page_cubit.dart';

part 'home_screen_state.dart';

class HomeScreenCubit extends Cubit<HomeScreenInitial> {
  final PagesRepository repository;

  final List<EventPageCubit> list = <EventPageCubit>[];

  HomeScreenCubit({this.repository}) : super(HomeScreenInitial());

  void removePage(int iPage) {
    repository.removePage(iPage);
    emit(HomeScreenInitial());
  }

  void addPage(PropertyPage page) {
    repository.addPage(
      page.copyWith(
        isPin: false,
        creationTime: DateTime.now(),
        messages: MessagesRepository(),
        lastModifiedTime: DateTime.now(),
      ),
    );
    emit(HomeScreenInitial());
  }

  void updateList() {
    repository.eventPages.sort();
    for (var i = 0; i < repository.eventPages.length; i++) {
      list[i].refreshDate(i);
    }
    //emit(HomeScreenInitial());
  }
}
