import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';
import '../../models/category.dart';
import '../../repository/home_repositore.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeRepository repository;

  HomeCubit(this.repository) : super(HomeAwaitInitial()) {
    loadData();
  }

  Future<void> loadData() async {
    emit(HomeShow(
      await repository.getAll(),
      HomeMethod.show,
    ));
  }

  Future<void> add(
      Categories categories, String description, String title) async {
    final category = Category(
      id: Uuid().v1(),
      assetImage: categories.img,
      description: description,
      title: title,
      categories: categories,
    );
    await repository.add(category);
    emit(HomeShow(repository.list, HomeMethod.add));
  }

  Future<void> remove(String index) async {
    await repository.delete(index);
    emit(HomeShow(updateList(repository.list), HomeMethod.delete));
  }

  Future<void> update(Category category, String desc, String title,
      Categories categories) async {
    await repository.update(category, desc, title, categories);
    emit(HomeShow(repository.list, HomeMethod.edit));
  }

  Future<void> pin(int index) async {
    await repository.pin(repository.list[index]);
    emit(HomeShow(repository.list, homeMethod(state.method)));
  }

  List<Category> repositoryForSharing(Category category) {
    final allCategories = repository.list;
    return allCategories..remove(category);
  }

  List<Category> updateList(List<Category> list) => List.from(list);

  HomeMethod homeMethod(HomeMethod method) {
    if (method == HomeMethod.pin) {
      return HomeMethod.unPin;
    } else {
      return HomeMethod.pin;
    }
  }
}
