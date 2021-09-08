import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/category.dart';
import '../models/event.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final List<Category> _categoryList = <Category>[
    Category(
      name: 'Travel',
      iconData: Icons.flight_takeoff_rounded,
      createdTime: DateTime.now(),
    ),
    Category(
      name: 'Family',
      iconData: Icons.family_restroom_rounded,
      createdTime: DateTime.now(),
    ),
    Category(
      name: 'Sport',
      iconData: Icons.sports_tennis_rounded,
      createdTime: DateTime.now(),
    ),
  ];

  HomeCubit() : super(HomeState());

  void init() => emit(state.copyWith(categoryList: _categoryList));

  void addCategory(Category category) {
    state.categoryList.add(category);
   _updateCategoryList();
  }

  void deleteCategory(int index) {
    state.categoryList.removeAt(index);
    _updateCategoryList();
  }

  void editCategory(int index, Category category) {
    state.categoryList[index] = category;
    _updateCategoryList();
  }

  void _updateCategoryList(){
    emit(state.copyWith(categoryList: state.categoryList));
  }

  void addEvents(List<Event> events, Category category){
    final categories = List<Category>.from(state.categoryList);
    final index = categories.indexOf(category);
    for (var event in events) {
      categories[index].eventList.add(event);
    }
    emit(state.copyWith(categoryList: categories));
  }
}
