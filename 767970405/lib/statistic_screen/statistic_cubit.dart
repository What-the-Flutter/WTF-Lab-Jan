import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:intl/intl.dart';

import '../data/constants/constants.dart';
import '../data/extension.dart';
import '../data/model/model_message.dart';
import '../data/repository/messages_repository.dart';

part 'statistic_state.dart';

class StatisticCubit extends Cubit<StatisticState> {
  final MessagesRepository repository;

  StatisticCubit({
    this.repository,
  }) : super(
          StatisticState(
            typeStatistic: TypeStatistic.labels,
            selectedTime: TypeTimeDiagram.today,
            list: <ModelMessage>[],
          ),
        ) {
    groupMessageByToday();
  }

  void changeStatistic(int index) {
    emit(state.copyWith(typeStatistic: TypeStatistic.values[index]));
  }

  void changeTime(int index) {
    emit(state.copyWith(selectedTime: TypeTimeDiagram.values[index]));
  }

  void groupMessageByToday() async {
    var message = await repository.messages();
    var today = DateTime.now();
    message = message
        .where((element) => element.pubTime.isSameDateByDay(today))
        .toList();
    emit(state.copyWith(list: message));
  }

  void groupMessageByWeek() async {
    var message = await repository.messages();
    var today = DateTime.now();
    var weekAgo = today.subtract(Duration(days: 7));
    message = message
        .where((element) =>
            weekAgo.isBefore(element.pubTime) && today.isAfter(element.pubTime))
        .toList();
    emit(state.copyWith(list: message));
  }

  void groupMessageByMonth() async {
    var message = await repository.messages();
    var today = DateTime.now();
    var weekAgo = today.subtract(Duration(days: 30));
    message = message
        .where((element) =>
            weekAgo.isBefore(element.pubTime) && today.isAfter(element.pubTime))
        .toList();
    emit(state.copyWith(list: message));
  }

  void groupMessageByYear() async {
    var message = await repository.messages();
    var today = DateTime.now();
    message =
        message.where((element) => element.pubTime.year == today.year).toList();
    emit(state.copyWith(list: message));
  }

  int countFilterMsg(bool Function(ModelMessage) filter) {
    return state.list.where(filter).toList().length;
  }

  List<OrdinalSales> filterMsg(
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
