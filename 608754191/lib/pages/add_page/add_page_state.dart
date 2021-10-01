part of 'add_page_cubit.dart';

class AddPageState {
  int selectedIconIndex;

  AddPageState({required this.selectedIconIndex});

  AddPageState copyWith(int selectedIconIndex) => AddPageState(
        selectedIconIndex: selectedIconIndex,
      );
}
