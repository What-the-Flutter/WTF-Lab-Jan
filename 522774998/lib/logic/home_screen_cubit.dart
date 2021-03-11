import 'package:bloc/bloc.dart';
import '../repository/messages_repository.dart';
import '../repository/pages_repository.dart';

import '../repository/property_page.dart';
import 'dialog_page_cubit.dart';

part 'home_screen_state.dart';

class HomePageCubit extends Cubit<HomeScreenInitial> {
  final PagesRepository repository;
  final List<DialogPageCubit> list = <DialogPageCubit>[];

  HomePageCubit({this.repository}) : super(HomeScreenInitial());

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
    repository.dialogPages.sort();
    for (var i = 0; i < repository.dialogPages.length; i++) {
      list[i].refreshDate(i);
    }
    emit(HomeScreenInitial());
  }
}
