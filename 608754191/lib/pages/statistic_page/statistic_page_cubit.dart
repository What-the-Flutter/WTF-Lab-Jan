import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../entity/message.dart';
import '../../repositories/database.dart';
import 'statistic_page_state.dart';

class StatisticPageCubit extends Cubit<StatisticPageState> {
  StatisticPageCubit()
      : super(
          StatisticPageState(),
        );
  final DatabaseProvider _databaseProvider = DatabaseProvider();

  void init() async {
    setMessageList(<Message>[]);
    setMessageList(
      await _databaseProvider.fetchFullMessageList(),
    );
  }

  void setSelectedPeriod(String period) {
    emit(
      state.copyWith(
        selectedPeriod: period,
      ),
    );
    countStatisticsData();
  }

  void countStatisticsData() {
    var dayDifference = 0;
    var yearDifference = 0;

    switch (state.selectedPeriod) {
      case 'last week':
        dayDifference = 8;
        yearDifference = 0;
        break;
      case 'last month':
        dayDifference = 31;
        yearDifference = 0;
        break;
      case 'last year':
        dayDifference = 0;
        yearDifference = 1;
        break;
    }

    final countOfMessages = state.listMessages!
        .where(
          (element) =>
              DateFormat().add_yMd().add_jm().parse(element.time).isAfter(
                    DateTime(
                      DateTime.now().year - yearDifference,
                      DateTime.now().month,
                      DateTime.now().day - dayDifference,
                    ),
                  ) &&
              DateFormat().add_yMd().add_jm().parse(element.time).isBefore(
                    DateTime(
                      DateTime.now().year + yearDifference,
                      DateTime.now().month,
                      DateTime.now().day + 1,
                    ),
                  ),
        )
        .length;

    final countOfBookmarkedEvents =
        state.listMessages!.where((element) => element.bookmarkIndex == 1).length;

    setCountOfMessages(countOfMessages);
    setCountOfBookmarkedMessages(countOfBookmarkedEvents);
  }

  void setCountOfMessages(int count) {
    emit(
      state.copyWith(
        messageCountInThePeriod: count,
      ),
    );
  }

  void setCountOfBookmarkedMessages(int count) {
    emit(
      state.copyWith(
        countOfBookmarkedMessagesInPeriod: count,
      ),
    );
  }

  void setMessageList(List<Message> messageList) {
    emit(
      state.copyWith(
        listMessages: messageList,
      ),
    );
  }
}
