import 'package:chat_journal/data/database_access.dart';
import 'package:chat_journal/tab_page/statistics/statistics_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StatisticsCubit extends Cubit<StatisticsState> {
  StatisticsCubit(StatisticsState state) : super(state);

  final _db = DatabaseAccess.instance();

  void initialize() async {
    emit(
      state.copyWith(
        labels: await _db.fetchLabels(),
        events: await _db.fetchAllEvents(),
        pages: await _db.fetchPages(),
      ),
    );
  }

  void setSelectedTimeline(String value) =>
      emit(state.copyWith(selectedTimeline: value));
}
