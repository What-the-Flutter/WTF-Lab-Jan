import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:intl/intl.dart';

import '../../db_helper/db_helper.dart';
import '../../models/event_message.dart';
import 'summary_event.dart';
import 'summary_state.dart';
import 'timing_chart.dart';

class SummaryScreenBloc extends Bloc<SummaryScreenEvent, SummaryScreenState> {
  SummaryScreenBloc(SummaryScreenState initialState) : super(initialState);

  final DBHelper _dbHelper = DBHelper();

  @override
  Stream<SummaryScreenState> mapEventToState(SummaryScreenEvent event) async* {
    if (event is SummaryEventMessageListInit) {
      yield* _mapEventMessageListInitToState(event);
    }
  }

  Stream<SummaryScreenState> _mapEventMessageListInitToState(
      SummaryEventMessageListInit event) async* {
    final eventMessageList = await _dbHelper.dbEventMessagesList();
    var countOfFavoriteEventMessages = 0;
    var countOfCategoryEventMessages = 0;
    var countOfImageEventMessages = 0;
    for (final eventMessage in eventMessageList) {
      if (eventMessage.isFavorite == 1) countOfFavoriteEventMessages++;
      if (eventMessage.nameOfCategory != null &&
          eventMessage.nameOfCategory != 'null') countOfCategoryEventMessages++;
      if (eventMessage.isImageMessage == 1) countOfImageEventMessages++;
    }
    yield state.copyWith(
      eventMessageList: eventMessageList,
      timeSeriesCountOfEventMessagesList:
          _timeSeriesCountOfEventMessagesList(eventMessageList),
      countOfAllEventMessages: eventMessageList.length,
      countOfFavoriteEventMessages: countOfFavoriteEventMessages,
      countOfCategoryEventMessages: countOfCategoryEventMessages,
      countOfImageEventMessages: countOfImageEventMessages,
    );
  }

  List<TimeSeriesCountOfEventMessages> _timeSeriesCountOfEventMessagesList(
      List<EventMessage> eventMessageList) {
    var timeSeriesCountOfEventMessagesList = <TimeSeriesCountOfEventMessages>[];
    if (eventMessageList.isNotEmpty) {
      eventMessageList.sort((a, b) {
        final aDate = DateFormat.yMMMd().add_jm().parse(a.time);
        final bDate = DateFormat.yMMMd().add_jm().parse(b.time);
        return bDate.compareTo(aDate);
      });

      var time = eventMessageList.first.time;
      var counter = 1;
      for (final eventMessage in eventMessageList) {
        if (time == eventMessage.time &&
            eventMessage.id != eventMessageList.first.id) {
          counter++;
        } else {
          timeSeriesCountOfEventMessagesList.add(
            TimeSeriesCountOfEventMessages(
              time: DateFormat.yMMMd().add_jm().parse(time),
              countOfEventMessages: counter,
            ),
          );
          time = eventMessage.time;
          counter = 1;
        }
      }
    }
    return timeSeriesCountOfEventMessagesList;
  }
}
