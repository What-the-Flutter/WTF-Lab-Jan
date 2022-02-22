import 'package:bloc/bloc.dart';

part 'main_screen_state.dart';

class MainScreenCubit extends Cubit<MainscreenState> {
  MainScreenCubit() : super(MainscreenState());

  void selectTab(int i) {
    if (state.selectedTab == i) {
      emit(state);
    } else {
      emit(state.copyWith(selectedTab: i));
    }
  }
}
