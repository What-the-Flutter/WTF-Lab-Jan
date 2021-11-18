import 'package:bloc/bloc.dart';
import '../../../models/char_data.dart';

import '../../../models/filter_parameters.dart';
import '../../../repository/labels_repository.dart';
import '../../../repository/messages_repository.dart';
import 'summary_statistics_state.dart';

class SummaryStatisticsPageCubit extends Cubit<SummaryStatisticsPageState> {
  final LabelsRepository labelsRepository;
  final MessagesRepository messagesRepository;

  SummaryStatisticsPageCubit(this.labelsRepository, this.messagesRepository)
      : super(SummaryStatisticsPageState(
          isGraphicVisible: false,
          labels: [],
          messages: [],
          selectedPeriod: 'This year',
          selectedLabelIndex: -1,
          parameters: FilterParameters(
            onlyCheckedMessages: false,
            isDateSelected: false,
            arePagesIgnored: true,
            selectedPages: [],
            selectedTags: [],
            selectedLabels: [],
            searchText: '',
            date: DateTime.now(),
          ),
          summaryData: [],
        ));

  void init() async {
    await loadMessages();
    await loadLabels();
    setSummaryData();
  }

  Future<void> loadLabels() async {
    final labels = await labelsRepository.labelsList();
    emit(
      state.copyWith(
        labels: labels,
      ),
    );
  }

  Future<void> loadMessages() async {
    final messages = await messagesRepository.allMessagesList();
    emit(
      state.copyWith(
        messages: messages,
      ),
    );
  }

  void setFilterParameters(FilterParameters parameters) {
    emit(
      state.copyWith(
        parameters: parameters,
      ),
    );
    init();
  }

  bool areDaysEqual(DateTime day1, DateTime day2) {
    if (day1.year == day2.year &&
        day1.month == day2.month &&
        day1.day == day2.day) {
      return true;
    } else {
      return false;
    }
  }

  int compareDays(DateTime day1, DateTime day2) {
    final d1 = DateTime.utc(day1.year, day1.month, day1.day);
    final d2 = DateTime.utc(day2.year, day2.month, day2.day);
    return d1.compareTo(d2);
  }

  int compareMonth(DateTime month1, DateTime month2) {
    final m1 = DateTime.utc(month1.year, month1.month);
    final m2 = DateTime.utc(month2.year, month2.month);
    return m1.compareTo(m2);
  }

  int compareHours(DateTime day1, DateTime day2) {
    final d1 = DateTime.utc(day1.year, day1.month, day1.day, day1.hour);
    final d2 = DateTime.utc(day2.year, day2.month, day2.day, day2.hour);
    return d1.compareTo(d2);
  }

  List _filterByPages(List messages) {
    if (state.parameters.arePagesIgnored) {
      messages = messages
          .where(
            (message) =>
                !state.parameters.selectedPages.contains(message.pageId),
          )
          .toList();
    } else {
      messages = messages
          .where(
            (message) =>
                state.parameters.selectedPages.contains(message.pageId),
          )
          .toList();
    }
    return messages;
  }

  void onPeriodSelected(String selectedPeriod) {
    setPeriod(selectedPeriod);
    setSummaryData();
  }

  void setPeriod(String selectedPeriod) {
    emit(
      state.copyWith(
        selectedPeriod: selectedPeriod,
      ),
    );
  }

  void setSummaryData() {
    final summaryData;
    if (state.selectedPeriod == 'Today') {
      summaryData = dayData();
    } else if (state.selectedPeriod == 'Past 7 days') {
      summaryData = weekData();
    } else if (state.selectedPeriod == 'Past 30 days') {
      summaryData = monthData();
    } else {
      summaryData = yearData();
    }
    emit(
      state.copyWith(
        summaryData: summaryData,
      ),
    );
  }

  List<ColumnChartData> yearData() {
    final List<ColumnChartData> yearData = [];
    var messages = state.messages;
    if (state.parameters.selectedPages.isNotEmpty) {
      messages = _filterByPages(messages);
    }
    final dateNow = DateTime.now();
    for (var i = 0; i < 12; i++) {
      final date = DateTime(dateNow.year, dateNow.month - 12 + i);
      final totalNumber = messages
          .where((message) => compareMonth(message.date, date) == 0)
          .length;
      final bookmarksNumber = messages
          .where((message) =>
              message.isMarked == true && compareMonth(message.date, date) == 0)
          .length;
      final labelsNumber = messages
          .where((message) =>
              message.icon != '0xf00f1' &&
              compareMonth(message.date, date) == 0)
          .length;
      yearData.add(
        ColumnChartData(
          (i - 1).toString(),
          totalNumber,
          bookmarksNumber,
          labelsNumber,
        ),
      );
    }
    return yearData;
  }

  List<ColumnChartData> monthData() {
    final List<ColumnChartData> monthData = [];
    var messages = state.messages;
    if (state.parameters.selectedPages.isNotEmpty) {
      messages = _filterByPages(messages);
    }
    final dateNow = DateTime.now();
    var maxIndex = 30;
    for (var i = 0; i < maxIndex; i++) {
      final date =
          DateTime(dateNow.year, dateNow.month, dateNow.day - maxIndex + i);
      final totalNumber = messages
          .where((message) => compareDays(message.date, date) == 0)
          .length;

      final bookmarksNumber = messages
          .where((message) =>
              message.isMarked == true && compareDays(message.date, date) == 0)
          .length;

      final labelsNumber = messages
          .where((message) =>
              message.icon != '0xf00f1' && compareDays(message.date, date) == 0)
          .length;
      monthData.add(
        ColumnChartData(
          (i - 1).toString(),
          totalNumber,
          bookmarksNumber,
          labelsNumber,
        ),
      );
    }
    return monthData;
  }

  List<ColumnChartData> weekData() {
    final List<ColumnChartData> weekData = [];
    var messages = state.messages;
    if (state.parameters.selectedPages.isNotEmpty) {
      messages = _filterByPages(messages);
    }
    final dateNow = DateTime.now();
    var maxIndex = 7;
    for (var i = 0; i < maxIndex; i++) {
      final date =
          DateTime(dateNow.year, dateNow.month, dateNow.day - maxIndex + i);
      final totalNumber = messages
          .where((message) => compareDays(message.date, date) == 0)
          .length;

      final bookmarksNumber = messages
          .where((message) =>
              message.isMarked == true && compareDays(message.date, date) == 0)
          .length;

      final labelsNumber = messages
          .where((message) =>
              message.icon != '0xf00f1' && compareDays(message.date, date) == 0)
          .length;
      weekData.add(
        ColumnChartData(
          (i - 1).toString(),
          totalNumber,
          bookmarksNumber,
          labelsNumber,
        ),
      );
    }
    return weekData;
  }

  List<ColumnChartData> dayData() {
    final List<ColumnChartData> dayData = [];
    var messages = state.messages;
    if (state.parameters.selectedPages.isNotEmpty) {
      messages = _filterByPages(messages);
    }
    final dateNow = DateTime.now();
    var maxIndex = 24;
    for (var i = 0; i < maxIndex; i++) {
      final date = DateTime(
        dateNow.year,
        dateNow.month,
        dateNow.day,
        dateNow.hour - maxIndex + i,
      );
      final totalNumber = messages
          .where((message) => compareHours(message.date, date) == 0)
          .length;

      final bookmarksNumber = messages
          .where((message) =>
              message.isMarked == true && compareHours(message.date, date) == 0)
          .length;

      final labelsNumber = messages
          .where((message) =>
              message.icon != '0xf00f1' &&
              compareHours(message.date, date) == 0)
          .length;
      dayData.add(
        ColumnChartData(
          (i - 1).toString(),
          totalNumber,
          bookmarksNumber,
          labelsNumber,
        ),
      );
    }
    return dayData;
  }
}
