import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:chat_journal/models/char_data.dart';
import 'package:chat_journal/models/filter_parameters.dart';
import 'package:chat_journal/theme/themes.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../models/events_model.dart';
import '../../../repository/labels_repository.dart';
import '../../../repository/messages_repository.dart';
import 'charts_statistics_state.dart';

class ChartsStatisticsPageCubit extends Cubit<ChartsStatisticsPageState> {
  final LabelsRepository labelsRepository;
  final MessagesRepository messagesRepository;

  ChartsStatisticsPageCubit(this.labelsRepository, this.messagesRepository)
      : super(
          ChartsStatisticsPageState(
            isGraphicVisible: false,
            labels: [],
            messages: [],
            selectedLabels: [],
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
            series: [],
          ),
        );

  void init() async {
    await loadMessages();
    await loadLabels();
    reset();
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

  void onLabelPressed(Label label) {
    isLabelSelected(label) ? unselectLabel(label) : selectLabel(label);
    setSummaryData();
    changeSeries();
  }

  bool isLabelSelected(Label label) {
    return state.selectedLabels.contains(label);
  }

  void selectLabel(Label label) {
    final selectedLabels = state.selectedLabels;
    selectedLabels.add(label);
    emit(
      state.copyWith(
        selectedLabels: selectedLabels,
      ),
    );
  }

  void unselectLabel(Label label) {
    final selectedLabels = state.selectedLabels;
    selectedLabels.remove(label);

    emit(
      state.copyWith(
        selectedLabels: selectedLabels,
      ),
    );
  }

  void reset() {
    emit(
      state.copyWith(
        selectedLabels: [],
        summaryData: [],
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
    changeSeries();
  }

  void setPeriod(String selectedPeriod) {
    emit(
      state.copyWith(
        selectedPeriod: selectedPeriod,
      ),
    );
  }

  void changeSeries() {
    final List<ChartSeries<dynamic, dynamic>> series = [];
    final random = Random();
    for (var i = 0; i < state.summaryData.length; i++) {
      series.add(
        AreaSeries<ChartData, String>(
          dataSource: state.summaryData[i],
          xValueMapper: (data, _) => data.x,
          yValueMapper: (data, _) => data.y,
          name: i.toString(),
          color: graphicColors[random.nextInt(3)].withOpacity(0.3),
        ),
      );
    }
    emit(
      state.copyWith(
        series: series,
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

  List<List<ChartData>> yearData() {
    final List<List<ChartData>> yearData = [];
    var messages = state.messages;
    if (state.parameters.selectedPages.isNotEmpty) {
      messages = _filterByPages(messages);
    }
    final maxIndex = 12;
    final dateNow = DateTime.now();
    for (var j = 0; j < state.selectedLabels.length; j++) {
      List<ChartData> tempData = [];
      for (var i = 0; i < maxIndex; i++) {
        final date = DateTime(dateNow.year, dateNow.month - maxIndex + i + 1);
        final labelsNumber = messages
            .where((message) =>
                state.selectedLabels[j].icon == message.icon &&
                compareMonth(message.date, date) == 0)
            .length;

        tempData.add(
          ChartData(
            (i + 1).toString(),
            labelsNumber.toDouble(),
          ),
        );
      }
      yearData.add(tempData);
    }
    return yearData;
  }

  List<List<ChartData>> monthData() {
    final List<List<ChartData>> monthData = [];
    var messages = state.messages;
    if (state.parameters.selectedPages.isNotEmpty) {
      messages = _filterByPages(messages);
    }
    final dateNow = DateTime.now();
    var maxIndex = 30;
    for (var j = 0; j < state.selectedLabels.length; j++) {
      List<ChartData> tempData = [];
      for (var i = 0; i < maxIndex; i++) {
        final date =
            DateTime(dateNow.year, dateNow.month, dateNow.day - maxIndex + i);
        final labelsNumber = messages
            .where((message) =>
                state.selectedLabels[j].icon == message.icon &&
                compareDays(message.date, date) == 0)
            .length;
        tempData.add(
          ChartData(
            (i + 1).toString(),
            labelsNumber.toDouble(),
          ),
        );
      }
      monthData.add(tempData);
    }
    return monthData;
  }

  List<List<ChartData>> weekData() {
    final List<List<ChartData>> weekData = [];
    var messages = state.messages;
    if (state.parameters.selectedPages.isNotEmpty) {
      messages = _filterByPages(messages);
    }
    final dateNow = DateTime.now();
    var maxIndex = 7;
    for (var j = 0; j < state.selectedLabels.length; j++) {
      List<ChartData> tempData = [];
      for (var i = 0; i < maxIndex; i++) {
        final date = DateTime(
          dateNow.year,
          dateNow.month,
          dateNow.day - maxIndex + i,
        );
        final labelsNumber = messages
            .where((message) =>
                state.selectedLabels[j].icon == message.icon &&
                compareDays(message.date, date) == 0)
            .length;
        tempData.add(
          ChartData(
            (i + 1).toString(),
            labelsNumber.toDouble(),
          ),
        );
      }
      weekData.add(tempData);
    }
    return weekData;
  }

  List<List<ChartData>> dayData() {
    final List<List<ChartData>> dayData = [];
    var messages = state.messages;
    if (state.parameters.selectedPages.isNotEmpty) {
      messages = _filterByPages(messages);
    }
    final dateNow = DateTime.now();
    var maxIndex = 24;
    for (var j = 0; j < state.selectedLabels.length; j++) {
      List<ChartData> tempData = [];
      for (var i = 0; i < maxIndex; i++) {
        final date = DateTime(
          dateNow.year,
          dateNow.month,
          dateNow.day,
          dateNow.hour - maxIndex + i,
        );
        final labelsNumber = messages
            .where((message) =>
                state.selectedLabels[j].icon == message.icon &&
                compareHours(message.date, date) == 0)
            .length;
        tempData.add(
          ChartData(
            (i + 1).toString(),
            labelsNumber.toDouble(),
          ),
        );
      }
      dayData.add(tempData);
    }
    return dayData;
  }
}
