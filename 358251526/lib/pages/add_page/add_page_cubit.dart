import 'package:bloc/bloc.dart';
import '../../util/db_provider.dart';
import '../../util/domain.dart';

part 'add_page_state.dart';

class AddPageCubit extends Cubit<AddPageState> {
  AddPageCubit()
      : super(
          AddPageState(selectedIconIndex: 0),
        );

  final DBProvider _databaseProvider = DBProvider();

  void init(int index) {
    setSelectedIconIndex(index);
  }

  void setSelectedIconIndex(int selectedIconIndex) => emit(
        state.updateSelectedIconIndex(selectedIconIndex),
      );

  void editPage(Category category) =>
      _databaseProvider.updateCategory(category);

  Future<void> addPage(Category category) async =>
      category.id = await _databaseProvider.insertCategory(category);
}
