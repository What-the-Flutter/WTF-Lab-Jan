import 'package:chat_journal/pages/statistics/labels_statistics/labels_statistics_screen.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'statistics_state.dart';

class StatisticsPageCubit extends Cubit<StatisticsPageState> {
  StatisticsPageCubit()
      : super(
          StatisticsPageState(
            isColorChanged: false,
            statisticsType: LabelsStatisticsPage(),
          ),
        );

  void changeStatisticsType(Widget statisticsType) {
    emit(
      state.copyWith(statisticsType: statisticsType,),
    );
  }

  void gradientAnimation() async {
    emit(
      state.copyWith(isColorChanged: false,),
    );
    await Future.delayed(
      const Duration(milliseconds: 30),
    );
    emit(
      state.copyWith(isColorChanged: true,),
    );
  }
}
