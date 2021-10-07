import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_wtf/pages/entity/category.dart';
import 'package:task_wtf/util/database.dart';

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
  void addCategory(String text) async {
    final categoryId = state.categories.length;
    var category = Category(
      title: text,
      subTitleMessage: 'Add event',
      iconIndex: state.selectedIconIndex,
      categoryId: categoryId + 1,
    );
    state.categories.insert(0, category);
    category.categoryId = await _databaseProvider.insertCategory(category);
    emit(
      state.copyWith(
        categories: state.categories,
      ),
    );
  }
}
