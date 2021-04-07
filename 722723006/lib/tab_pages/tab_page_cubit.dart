import 'package:flutter_bloc/flutter_bloc.dart';

class TabPageCubit extends Cubit<int> {
  TabPageCubit(int state) : super(state);

  void setSelectedIndex(int selectedIndex) => emit(selectedIndex);
}
