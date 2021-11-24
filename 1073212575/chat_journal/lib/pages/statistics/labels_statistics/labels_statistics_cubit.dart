import 'package:bloc/bloc.dart';
import '../../../models/filter_parameters.dart';
import '../../../repository/labels_repository.dart';
import '../../../repository/messages_repository.dart';

import 'labels_statistics_state.dart';

class LabelsStatisticsPageCubit extends Cubit<LabelsStatisticsPageState> {
  final LabelsRepository labelsRepository;
  final MessagesRepository messagesRepository;

  LabelsStatisticsPageCubit(this.labelsRepository, this.messagesRepository)
      : super(LabelsStatisticsPageState(
          labels: [],
          messages: [],
          selectedPeriod: 'Today',
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
        ));

  void init() {
    loadLabels();
    loadMessages();
  }

  void loadLabels() async {
    final labels = await labelsRepository.labelsList();
    emit(
      state.copyWith(
        labels: labels,
      ),
    );
  }

  void loadMessages() async {
    final messages = await messagesRepository.allMessagesList();
    emit(
      state.copyWith(
        messages: messages,
      ),
    );
  }

  void setPeriod(String selectedPeriod) {
    emit(
      state.copyWith(
        selectedPeriod: selectedPeriod,
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

  void delete(String labelId) {
    labelsRepository.deleteLabel(labelId);
    init();
  }

  int compareDays(DateTime day1, DateTime day2) {
    final d1 = DateTime.utc(day1.year, day1.month, day1.day);
    final d2 = DateTime.utc(day2.year, day2.month, day2.day);
    return d1.compareTo(d2);
  }

  int labelNumber(int i) {
    final date;
    final number;
    var messages = state.messages;
    final icon = state.labels[i].icon;
    if (state.parameters.selectedPages.isNotEmpty) {
      messages = _filterByPages(messages);
    }
    if (state.selectedPeriod == 'Today') {
      date = DateTime.now();
    } else if (state.selectedPeriod == 'Past 7 days') {
      date = DateTime.now().subtract(const Duration(days: 7));
    } else if (state.selectedPeriod == 'Past 30 days') {
      date = DateTime.now().subtract(const Duration(days: 30));
    } else if (state.selectedPeriod == 'This year') {
      date = DateTime.now().subtract(const Duration(days: 365));
    } else {
      number = messages.where((message) => message.icon == icon).length;
      return number;
    }
    number = messages
        .where((message) =>
            message.icon == icon && compareDays(message.date, date) >= 0)
        .length;

    return number;
  }

  String labelInfo(int i) {
    final numbers = [];
    var messages = state.messages;
    final icon = state.labels[i].icon;
    if (state.parameters.selectedPages.isNotEmpty) {
      messages = _filterByPages(messages);
    }
    final dates = [
      DateTime.now(),
      DateTime.now().subtract(const Duration(days: 7)),
      DateTime.now().subtract(const Duration(days: 30)),
      DateTime.now().subtract(const Duration(days: 365)),
    ];

    final lastNumber = messages.where((message) => message.icon == icon).length;
    for (var date in dates) {
      final number = messages
          .where((message) =>
              message.icon == icon && compareDays(message.date, date) >= 0)
          .length;
      numbers.add(number);
    }
    numbers.add(lastNumber);
    final info = 'Used \n${numbers[0]} time(s) today,'
        '\n${numbers[1]} time(s) in last 7 days,'
        '\n${numbers[2]} time(s) in last 30 days,'
        '\n${numbers[3]} time(s) in last year,'
        '\n${numbers[4]} time(s) in total';
    return info;
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
}
