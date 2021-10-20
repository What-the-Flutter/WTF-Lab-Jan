import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repositories/database.dart';
import '../entity/category.dart';

part 'add_page_state.dart';

class AddPageCubit extends Cubit<AddPageState> {
  AddPageCubit()
      : super(
          const AddPageState(
            selectedIconIndex: 0,
            categories: [],
          ),
        );

  final DatabaseProvider _databaseProvider = DatabaseProvider();

  void init(Category? category, List<Category>? categories) {
    emit(
      state.copyWith(
        category: category,
        categories: categories,
      ),
    );
  }

  void setSelectedIconIndex(int selectedIconIndex) => emit(
        state.copyWith(
          selectedIconIndex: selectedIconIndex,
        ),
      );
}
