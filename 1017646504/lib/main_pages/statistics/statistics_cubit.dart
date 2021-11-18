import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/database_access.dart';
import 'statistics_state.dart';

class StatisticsCubit extends Cubit<StatisticsState> {
  StatisticsCubit(StatisticsState state) : super(state);

  final _db = DatabaseAccess.instance();

  void initialize() async {
    emit(
      state.copyWith(
        events: await _db.fetchAllEvents(),
        pages: await _db.fetchPages(),
      ),
    );
  }

  void setSelectedTimeline(String? value) => emit(state.copyWith(selectedTimeline: value));
}
