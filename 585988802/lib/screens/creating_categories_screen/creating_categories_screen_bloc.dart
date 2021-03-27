import 'dart:async';

import 'package:bloc/bloc.dart';

import 'creating_categories_screen_event.dart';
import 'creating_categories_screen_state.dart';

class CreatingCategoriesScreenBloc
    extends Bloc<CreatingCategoriesScreenEvent, CreatingCategoriesScreenState> {
  CreatingCategoriesScreenBloc(CreatingCategoriesScreenState initialState)
      : super(initialState);

  @override
  Stream<CreatingCategoriesScreenState> mapEventToState(
      CreatingCategoriesScreenEvent event) async* {
    if (event is CreatingCategoriesScreenInit) {
      yield* _mapCreatingCategoriesScreenInitToState();
    } else if (event is CurrentImageChanged) {
      yield* _mapCurrentImageChangedToState(event);
    } else if (event is AddButtonChanged) {
      yield* _mapAddButtonChangedToState(event);
    }
  }

  Stream<CreatingCategoriesScreenState>
      _mapCreatingCategoriesScreenInitToState() async* {
    yield state.copyWith(
      currentImagePath: 'assets/images/journal.png',
      isWriting: false,
    );
  }

  Stream<CreatingCategoriesScreenState> _mapCurrentImageChangedToState(
      CurrentImageChanged event) async* {
    yield state.copyWith(
      currentImagePath: event.currentImagePath,
    );
  }

  Stream<CreatingCategoriesScreenState> _mapAddButtonChangedToState(
      AddButtonChanged event) async* {
    yield state.copyWith(
      isWriting: event.isWriting,
    );
  }
}
