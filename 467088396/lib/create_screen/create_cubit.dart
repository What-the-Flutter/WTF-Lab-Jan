import 'package:flutter_bloc/flutter_bloc.dart';

import '../constants.dart';
import '../models/category.dart';
import 'create_state.dart';

class CreatePageCubit extends Cubit<CreatePageState> {
  CreatePageCubit() : super(CreatePageState());

  void init(){
    emit(state.copyWith(index: 0));
  }

  Category? createCategory(String title) {
    if (title.isEmpty) {
      return null;
    }
    var category = Category(
      name: title,
      iconData: icons[state.selectedIcon!],
      createdTime: DateTime.now(),
    );
    return category;
  }

  void editCategory(Category category) {
    emit(state.copyWith());
  }

  void selectIcon(int iconIndex) {
    emit(state.copyWith(index: iconIndex));
  }
}
