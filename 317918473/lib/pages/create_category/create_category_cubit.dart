import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import '../../models/category.dart';
import '../../repository/icons_repository.dart';


part 'create_category_state.dart';

class CreateCategoryCubit extends Cubit<CreateCategoryState> {
  final IconsRepository iconsRepository;

  CreateCategoryCubit(this.iconsRepository)
      : super(CreateCategoryInitial(isSelected: false));

  Category? init(BuildContext context, Category? category) {
    if (category == null) {
      emit(CreateCategoryInitial(isSelected: false));
    } else {
      emit(CreateCategoryUpdateChoose(
          index: category.categories, category: category, isSelected: true));
      return category;
    }
  }

  void onChooseIcon(Categories index) {
    if (state.index == index) {
      emit(state.copyWith(index: null, isSelected: false));
    } else {
      if (state is CreateCategoryUpdateChoose) {
        emit(state.copyWith(index: index, isSelected: true));
      } else {
        emit(CreateCategoryAddChoose(index: index, isSelected: true));
      }
    }
  }
}
