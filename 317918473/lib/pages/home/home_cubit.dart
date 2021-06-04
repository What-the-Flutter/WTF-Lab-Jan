import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../models/category.dart';
import '../../repository/home_repositore.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeRepository repository;

  HomeCubit(this.repository) : super(HomeInitial(repository.list));

  void add(Categories categories, String descripton, String title) {
    var id = 0;
    if (repository.list.isNotEmpty) {
      id = repository.list.indexOf(repository.list.last) + 1;
    }
    final category =
        Category(id, categories.img, descripton, title, categories);
    repository.add(category);
    emit(HomeShow(repository.list, HomeMethod.add));
  }

  void remove(int index) {
    repository.delete(index);
    if (repository.list.isEmpty) {
      emit(HomeInitial([]));
    } else {
      print('delete');
      emit(HomeShow(repository.list, HomeMethod.delete));
    }
  }

  void update(int index, String desc, String title, Categories categories) {
    repository.update(index, desc, title, categories);
    emit(HomeShow(repository.list, HomeMethod.edit));
  }

  void pin(int index) {
    repository.pin(index);
    emit(HomeShow(updateList(repository.list), HomeMethod.unPin));
  }

  List<Category> repositoryForSharing(Category category) {
    final allCategories = repository.list;
    return allCategories..remove(category);
  }

  List<Category> updateList(List<Category> list) => List.from(list);
}
