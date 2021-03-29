import 'dart:async';

import 'package:bloc/bloc.dart';

import 'creating_suggestion_screen_event.dart';
import 'creating_suggestion_screen_state.dart';

class CreatingSuggestionScreenBloc
    extends Bloc<CreatingSuggestionScreenEvent, CreatingSuggestionScreenState> {
  CreatingSuggestionScreenBloc(CreatingSuggestionScreenState initialState)
      : super(initialState);

  @override
  Stream<CreatingSuggestionScreenState> mapEventToState(
      CreatingSuggestionScreenEvent event) async* {
    if (event is CreatingSuggestionScreenInit) {
      yield* _mapCreatingSuggestionScreenInitToState();
    } else if (event is CurrentImageChanged) {
      yield* _mapCurrentImageChangedToState(event);
    } else if (event is AddButtonChanged) {
      yield* _mapAddButtonChangedToState(event);
    }
  }

  Stream<CreatingSuggestionScreenState>
      _mapCreatingSuggestionScreenInitToState() async* {
    yield state.copyWith(
      currentImagePath: 'assets/images/journal.png',
      isWriting: false,
    );
  }

  Stream<CreatingSuggestionScreenState> _mapCurrentImageChangedToState(
      CurrentImageChanged event) async* {
    yield state.copyWith(
      currentImagePath: event.currentImagePath,
    );
  }

  Stream<CreatingSuggestionScreenState> _mapAddButtonChangedToState(
      AddButtonChanged event) async* {
    yield state.copyWith(
      isWriting: event.isWriting,
    );
  }
}
