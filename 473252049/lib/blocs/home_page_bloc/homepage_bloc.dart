import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../extensions/list_get_element.dart';
import '../../model/category.dart';

part 'homepage_event.dart';
part 'homepage_state.dart';

class HomepageBloc extends Bloc<HomepageEvent, HomepageState> {
  final List<Category> categories;

  HomepageBloc(this.categories) : super(HomepageInitial(categories));

  @override
  Stream<HomepageState> mapEventToState(
    HomepageEvent event,
  ) async* {
    if (event is CategoriesSorted) {
      categories.sort((a, b) => a.compareTo(b));
      yield CategoriesSortSuccess(categories);
    } else if (event is CategorySelected) {
      categories.get(event.category).isSelected = true;
      yield CategorySelectSuccess(categories, event.category);
    } else if (event is CategoryUnselected) {
      categories.get(event.category).isSelected = false;
      yield CategoryUnselectSuccess(categories);
    } else if (event is CategoryPinned) {
      categories.get(event.category).isPinned = true;
      yield* mapEventToState(CategoriesSorted());
      yield CategoryPinSuccess(categories);
    } else if (event is CategoryUnpinned) {
      categories.get(event.category).isPinned = false;
      yield* mapEventToState(CategoriesSorted());
      yield CategoryUnpinSuccess(categories);
    } else if (event is CategoryPinChanged) {
      if (event.category.isPinned) {
        yield* mapEventToState(CategoryUnpinned(event.category));
      } else {
        yield* mapEventToState(CategoryPinned(event.category));
      }
    } else if (event is CategoryUpdateStarted) {
      yield CategoryUpdateInProcess(categories, event.category);
    } else if (event is CategoryUpdateCancelled) {
      yield CategoryUpdateCancelSuccess(categories);
    } else if (event is CategoryUpdated) {
      categories.get(event.category)
        ..icon = event.newIconData
        ..name = event.newName;
      yield* mapEventToState(CategoriesSorted());
      yield CategoryUpdateSuccess(categories);
    } else if (event is CategoryDeleteStarted) {
      yield CategoryDeleteInProcess(categories, event.category);
    } else if (event is CategoryDeleteCancelled) {
      yield CategoryDeleteCancelSuccess(categories);
    } else if (event is CategoryDeleted) {
      categories.remove(event.category);
      yield CategoryDeleteSuccess(categories);
    } else if (event is CategoryAddStarted) {
      yield CategoryAddInProcess(categories);
    } else if (event is CategoryAddCancelled) {
      yield CategoryAddCancelSuccess(categories);
    } else if (event is CategoryAdded) {
      categories.add(event.category);
      yield* mapEventToState(CategoriesSorted());
      yield CategoryAddSuccess(categories);
    }
  }

  @override
  void onTransition(Transition<HomepageEvent, HomepageState> transition) {
    print(transition);
    super.onTransition(transition);
  }
}
