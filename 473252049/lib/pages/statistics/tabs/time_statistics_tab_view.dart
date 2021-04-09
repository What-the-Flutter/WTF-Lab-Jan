import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../repositories/local_database/local_database_records_repository.dart';
import '../charts/time_statistics/cubit/timestatistics_cubit.dart';
import '../charts/time_statistics/time_statistics_chart.dart';

class TimeStatisticsTabView extends StatelessWidget {
  const TimeStatisticsTabView({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        return TimestatisticsCubit(
          recordsRepository: LocalDatabaseRecordsRepository(),
        )..loadChart();
      },
      child: Builder(
        builder: (context) {
          return BlocBuilder<TimestatisticsCubit, TimestatisticsState>(
            builder: (context, state) {
              if (state.dataList == null) {
                return CircularProgressIndicator();
              }
              if (state.dataList.isEmpty) {
                return Center(
                  child: Text('No records in selected period'),
                );
              }
              return SafeArea(
                child: Column(
                  children: [
                    SelectPeriodDropdownButton(),
                    TimeStatisticsChart(
                      dataList: state.dataList,
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class SelectPeriodDropdownButton extends StatefulWidget {
  @override
  _SelectPeriodDropdownButtonState createState() =>
      _SelectPeriodDropdownButtonState();
}

class _SelectPeriodDropdownButtonState
    extends State<SelectPeriodDropdownButton> {
  List<SelectPeriodDropdownMenuItem> menuItems;
  SelectPeriodDropdownMenuItem _currentItem;

  @override
  void initState() {
    super.initState();
    menuItems = getDropdownItemsList(context);
    _currentItem = menuItems.first;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<SelectPeriodDropdownMenuItem>(
      value: _currentItem,
      icon: Icon(Icons.access_time),
      items: menuItems
          .map((e) => DropdownMenuItem(child: Text(e.name), value: e))
          .toList(),
      onChanged: (value) {
        setState(() {
          _currentItem = value;
        });
        value.onSelect();
      },
    );
  }
}

List<SelectPeriodDropdownMenuItem> getDropdownItemsList(BuildContext context) {
  return [
    SelectPeriodDropdownMenuItem(
      name: 'Week',
      onSelect: () => context.read<TimestatisticsCubit>().loadChart(),
    ),
    SelectPeriodDropdownMenuItem(
      name: 'Month',
      onSelect: () => context.read<TimestatisticsCubit>().loadMonthChart(),
    )
  ];
}

class SelectPeriodDropdownMenuItem {
  final String name;
  final void Function() onSelect;

  SelectPeriodDropdownMenuItem({this.name, this.onSelect});
}
