import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'app_home_state.dart';

class AppHomeCubit extends Cubit<AppHomeState> {
  AppHomeCubit() : super(const AppHomeState());

  void togglePage(int index) => emit(state.copyWith(index));
}
