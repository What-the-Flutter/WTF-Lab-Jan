import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeState(index: 0));

  void tabSelect(int index) {
    emit(HomeState(index: index));
  }
}
