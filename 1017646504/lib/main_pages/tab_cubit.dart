import 'package:flutter_bloc/flutter_bloc.dart';

import 'tab_state.dart';

class TabCubit extends Cubit<TabState> {
  TabCubit(TabState state) : super(state);

  void setSelected(int selected) => emit(
        state.copyWith(prevIndex: state.currIndex, currIndex: selected),
      );
}
