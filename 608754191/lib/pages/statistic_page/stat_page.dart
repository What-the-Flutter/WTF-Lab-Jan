import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_wtf/pages/statistic_page/statistic_page_state.dart';
import 'statistic_page_cubit.dart';

class TestingStatisticPage extends StatefulWidget {
  @override
  _StatisticPageState createState() => _StatisticPageState();
}

class _StatisticPageState extends State<TestingStatisticPage> {
  @override
  void initState() {
    BlocProvider.of<StatisticPageCubit>(context).init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StatisticPageCubit, StatisticPageState>(builder: (context, statisticState) {
      return Scaffold(
        appBar: _statisticsAppBar(statisticState),
        body: Center(
          child: Text('statistic'),
        ),
      );
    });
  }

  AppBar _statisticsAppBar(StatisticPageState state) {
    return AppBar(
      title: const Text(
        'Statistics',
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: DropdownButton<String>(
            style: TextStyle(
              color: Theme.of(context).floatingActionButtonTheme.backgroundColor,
            ),
            hint: Text(
              'Select period',
              style: TextStyle(
                color: Theme.of(context).floatingActionButtonTheme.backgroundColor,
              ),
            ),
            value: state.selectedPeriod,
            icon: const Icon(
              Icons.timeline,
              size: 25,
              color: Colors.white,
            ),
            underline: Container(
              height: 2,
            ),
            onChanged: (value) =>
                BlocProvider.of<StatisticPageCubit>(context).setSelectedPeriod(value!),
            items: <String>['last week', 'last month', 'last year'].map<DropdownMenuItem<String>>(
              (value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                  ),
                );
              },
            ).toList(),
          ),
        ),
      ],
    );
  }
}
