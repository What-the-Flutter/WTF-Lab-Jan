import '../../models/event_message.dart';
import '../../models/time_series_of_event_messages.dart';

class SummaryScreenState {
  List<EventMessage> eventMessageList;
  List<TimeSeriesOfEventMessages> timeSeriesCountOfEventMessagesList;
  int countOfAllEventMessages;
  int countOfFavoriteEventMessages;
  int countOfCategoryEventMessages;
  int countOfImageEventMessages;

  SummaryScreenState(
    this.eventMessageList,
    this.timeSeriesCountOfEventMessagesList,
    this.countOfAllEventMessages,
    this.countOfFavoriteEventMessages,
    this.countOfCategoryEventMessages,
    this.countOfImageEventMessages,
  );

  SummaryScreenState copyWith({
    final List<EventMessage> eventMessageList,
    final List<TimeSeriesOfEventMessages> timeSeriesCountOfEventMessagesList,
    final int countOfAllEventMessages,
    final int countOfFavoriteEventMessages,
    final int countOfCategoryEventMessages,
    final int countOfImageEventMessages,
  }) {
    return SummaryScreenState(
      eventMessageList ?? this.eventMessageList,
      timeSeriesCountOfEventMessagesList ??
          this.timeSeriesCountOfEventMessagesList,
      countOfAllEventMessages ?? this.countOfAllEventMessages,
      countOfFavoriteEventMessages ?? this.countOfFavoriteEventMessages,
      countOfCategoryEventMessages ?? this.countOfCategoryEventMessages,
      countOfImageEventMessages ?? this.countOfImageEventMessages,
    );
  }
}
