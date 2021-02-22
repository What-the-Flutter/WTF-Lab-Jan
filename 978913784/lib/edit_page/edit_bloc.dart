import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tuple/tuple.dart';

import '../page.dart';
import 'edit_event.dart';

class EditBloc extends Bloc<EditEvent, Tuple2<JournalPage, bool>> {
  EditBloc(initialState) : super(initialState);

  @override
  Stream<Tuple2<JournalPage, bool>> mapEventToState(EditEvent event) async* {
    if(event is IconChanged) {
      yield* _mapIconChanged(event);
    } else if (event is AllowanceUpdated) {
      yield* _mapAllowanceUpdated(event);
    }
  }

  Stream<Tuple2<JournalPage, bool>> _mapIconChanged(IconChanged event) async* {
    final updatedState = Tuple2<JournalPage, bool>(state.item1.copyWith(icon: event.icon),state.item2);
    yield updatedState;
  }

  Stream<Tuple2<JournalPage, bool>> _mapAllowanceUpdated(AllowanceUpdated event) async*{
    final updatedState = Tuple2<JournalPage, bool>(state.item1,event.isAllowed);
    yield updatedState;
  }
}