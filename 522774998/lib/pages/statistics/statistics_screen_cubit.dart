import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repository/messages_repository.dart';
import '../../repository/pages_repository.dart';
import 'statistics_screen_state.dart';

class StatisticsCubit extends Cubit<StatisticsState> {
  final MessagesRepository messagesRepository;
  final PagesRepository pagesRepository;

  StatisticsCubit(
    StatisticsState state,
    this.messagesRepository,
    this.pagesRepository,
  ) : super(state);

  void initialize() async {
    emit(
      state.copyWith(
        messages: await messagesRepository.messagesFromAllPages(),
        pages: await pagesRepository.pagesList(),
      ),
    );
  }

  void setTimeline(String timeline) {
    emit(
      state.copyWith(timeline: timeline),
    );
  }
}
