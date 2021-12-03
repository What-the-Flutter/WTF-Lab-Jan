import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'event_page_state.dart';

class EventPageCubit extends Cubit<EventPageState> {
  EventPageCubit() : super(EventPageInitial());
}
