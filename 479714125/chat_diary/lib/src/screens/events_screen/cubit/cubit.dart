import 'package:bloc/bloc.dart';
import 'package:chat_diary/src/models/event_model.dart';
import 'package:equatable/equatable.dart';

import '../../../models/page_model.dart';

part 'state.dart';

class EventScreenCubit extends Cubit<EventScreenState> {
  EventScreenCubit(PageModel page)
      : super(EventScreenState(
          page: page,
          countOfSelected: 0,
          isEditing: false,
          isImageSelected: false,
        ));

  void addEvent(EventModel model) {
    state.page.events.insert(0, model);
    emit(state.copyWith(page: state.page));
  }
}
