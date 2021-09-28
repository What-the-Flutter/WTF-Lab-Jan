part of 'add_page_cubit.dart';

class AddPageState {
  final int selectedIconIndex;

  const AddPageState({required this.selectedIconIndex});

  AddPageState updateSelectedIconIndex(final int selectedIconIndex) =>
      AddPageState(selectedIconIndex: selectedIconIndex);
}
