import 'package:flutter_bloc/flutter_bloc.dart';

class TabCubit extends Cubit<int> {
  TabCubit(int state) : super(state);

  void setSelected(int selected) => emit(selected);
}
