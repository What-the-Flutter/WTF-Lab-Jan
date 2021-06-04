part of 'create_category_cubit.dart';

@immutable
abstract class CreateCategoryState extends Equatable {
  final Categories? index;
  final bool isSelected;

  const CreateCategoryState({this.index, required this.isSelected});

  @override
  List<Object?> get props => [index, isSelected];

  CreateCategoryState copyWith({
    final Categories? index,
    required final bool isSelected,
  });
}

class CreateCategoryInitial extends CreateCategoryState {
  CreateCategoryInitial({
    required bool isSelected,
    Categories? index,
  }) : super(isSelected: isSelected);

  @override
  CreateCategoryState copyWith({
    Categories? index,
    required bool isSelected,
  }) {
    return CreateCategoryInitial(
      index: index,
      isSelected: isSelected,
    );
  }
}

class CreateCategoryAddChoose extends CreateCategoryState {
  CreateCategoryAddChoose({
    required Categories? index,
    required bool isSelected,
  }) : super(
          index: index,
          isSelected: isSelected,
        );

  @override
  CreateCategoryState copyWith({
    Categories? index,
    required bool isSelected,
  }) {
    return CreateCategoryAddChoose(
      index: index,
      isSelected: isSelected,
    );
  }
}

class CreateCategoryUpdateChoose extends CreateCategoryState {
  final Category? category;

  CreateCategoryUpdateChoose({
    required Categories? index,
    this.category,
    required bool isSelected,
  }) : super(
          index: index,
          isSelected: isSelected,
        );

  @override
  CreateCategoryState copyWith({
    Categories? index,
    required bool isSelected,
  }) {
    return CreateCategoryUpdateChoose(
      index: index,
      category: category,
      isSelected: isSelected,
    );
  }
}
