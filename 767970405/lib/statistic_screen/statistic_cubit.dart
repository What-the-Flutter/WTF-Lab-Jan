import 'package:bloc/bloc.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';

import '../data/constants/constants.dart';
import '../data/extension.dart';
import '../data/model/model_message.dart';
import '../data/model/search_item_data.dart';
import '../data/repository/messages_repository.dart';

part 'statistic_state.dart';

class StatisticCubit extends Cubit<StatisticState> {
  final MessagesRepository repository;

  StatisticCubit({
    this.repository,
  }) : super(
          StatisticState(
            typeStatistic: TypeStatistic.summary,
            selectedTime: TypeTimeDiagram.today,
            list: <ModelMessage>[],
          ),
        ) {
    groupMessageByToday(<SearchItemData>[]);
  }

  void updateStatistic(List<SearchItemData> selectedPages) {
    switch (state.selectedTime) {
      case TypeTimeDiagram.today:
        groupMessageByToday(selectedPages);
        break;
      case TypeTimeDiagram.pastSevenDays:
        groupMessageByWeek(selectedPages);
        break;
      case TypeTimeDiagram.pastThirtyDays:
        groupMessageByMonth(selectedPages);
        break;
      case TypeTimeDiagram.thisYear:
        groupMessageByYear(selectedPages);
        break;
    }
  }

  void changeStatistic(int index) {
    emit(state.copyWith(typeStatistic: TypeStatistic.values[index]));
  }

  void changeTime(int index) {
    emit(state.copyWith(selectedTime: TypeTimeDiagram.values[index]));
  }

  Future<List<ModelMessage>> filterMsgByPage(
      List<SearchItemData> selectedPages) async {
    var message = await repository.messages();
    if (selectedPages.isNotEmpty) {
      return message.where((element) {
        for (var i = 0; i < selectedPages.length; i++) {
          if (selectedPages[i].id == element.pageId) {
            return true;
          }
        }
        return false;
      }).toList();
    }
    return message;
  }

  void groupMessageByToday(List<SearchItemData> selectedPages) async {
    var message = await filterMsgByPage(selectedPages);
    var today = DateTime.now();
    message = message
        .where((element) => element.pubTime.isSameDateByDay(today))
        .toList();
    emit(state.copyWith(list: message));
  }

  void groupMessageByWeek(List<SearchItemData> selectedPages) async {
    var message = await filterMsgByPage(selectedPages);
    var today = DateTime.now();
    var weekAgo = today.subtract(Duration(days: 7));
    message = message
        .where((element) =>
            weekAgo.isBefore(element.pubTime) && today.isAfter(element.pubTime))
        .toList();
    emit(state.copyWith(list: message));
  }

  void groupMessageByMonth(List<SearchItemData> selectedPages) async {
    var message = await filterMsgByPage(selectedPages);
    var today = DateTime.now();
    var weekAgo = today.subtract(Duration(days: 30));
    message = message
        .where((element) =>
            weekAgo.isBefore(element.pubTime) && today.isAfter(element.pubTime))
        .toList();
    emit(state.copyWith(list: message));
  }

  void groupMessageByYear(List<SearchItemData> selectedPages) async {
    var message = await filterMsgByPage(selectedPages);
    var today = DateTime.now();
    message =
        message.where((element) => element.pubTime.year == today.year).toList();
    emit(state.copyWith(list: message));
  }

  int countFilterMsg(bool Function(ModelMessage) filter) {
    return state.list.where(filter).toList().length;
  }

  List<OrdinalSales> filterMsgByDate(
    bool Function(ModelMessage) filter,
    charts.Color color,
  ) {
    var msg = state.list.where(filter).toList();
    var dateFormat = _receiveDateFormat();
    var list = <List<ModelMessage>>[];
    var temp = <ModelMessage>[];
    for (var i = 0; i < msg.length - 1; i++) {
      temp.add(msg[i]);
      if (!_compare(msg[i].pubTime, msg[i + 1].pubTime)) {
        list.add(List.from(temp));
        temp = <ModelMessage>[];
      }
    }
    if (msg.isNotEmpty) {
      temp.add(msg[msg.length - 1]);
      list.add(List.from(temp));
    }

    return List<OrdinalSales>.generate(
      list.length,
      (index) {
        return OrdinalSales(
          date: dateFormat.format(
            list[index][0].pubTime,
          ),
          count: list[index].length,
          color: color,
        );
      },
    );
  }

  bool _compare(DateTime arg1, DateTime arg2) {
    if (state.selectedTime == TypeTimeDiagram.today) {
      return arg1.isSameDateByHour(arg2);
    } else if (state.selectedTime == TypeTimeDiagram.thisYear) {
      return arg1.isSameDateByMonth(arg2);
    } else {
      return arg1.isSameDateByDay(arg2);
    }
  }

  DateFormat _receiveDateFormat() {
    switch (state.selectedTime) {
      case TypeTimeDiagram.today:
        return DateFormat.H();
        break;
      case TypeTimeDiagram.pastSevenDays:
      case TypeTimeDiagram.pastThirtyDays:
        return DateFormat.yMd();
      case TypeTimeDiagram.thisYear:
        return DateFormat.yM();
      default:
        return null;
    }
  }
}

class OrdinalSales {
  final String date;
  final int count;
  final charts.Color color;

  OrdinalSales({
    this.date,
    this.count,
    this.color,
  });
}
