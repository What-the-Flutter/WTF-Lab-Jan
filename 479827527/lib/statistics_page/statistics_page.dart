import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'cubit_statistics_page.dart';
import 'states_statistics_page.dart';
import 'statistics.dart';

class StatisticsPage extends StatefulWidget {
  @override
  _StatisticsPageState createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  @override
  void initState() {
    BlocProvider.of<CubitStatisticsPage>(context).init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CubitStatisticsPage, StatesStatisticsPage>(
      builder: (context, state) {
        return Scaffold(
          appBar: _appBar(state),
          body: _statisticsFields(state),
        );
      },
    );
  }

  AppBar _appBar(StatesStatisticsPage state) {
    return AppBar(
      title: Text(
        'Statistics',
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: DropdownButton<String>(
            style: TextStyle(
              color:
                  Theme.of(context).floatingActionButtonTheme.backgroundColor,
            ),
            hint: Text(
              'Select period',
              style: TextStyle(
                color:
                    Theme.of(context).floatingActionButtonTheme.backgroundColor,
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
            onChanged: (value) => BlocProvider.of<CubitStatisticsPage>(context)
                .setSelectedPeriod(value),
            items: <String>['Past 7 days', 'Past 30 days', 'Past year']
                .map<DropdownMenuItem<String>>((value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  ClipRRect _notesBox(StatesStatisticsPage state) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(
        20.0,
      ),
      child: Container(
        height: 120,
        width: MediaQuery.of(context).size.width / 2,
        color: Colors.blue,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(
              top: 35.0,
            ),
            child: Column(
              children: [
                Text(
                  '${state.countOfNotesInPeriod ?? '-'}',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Notes',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Expanded _eventsBox(StatesStatisticsPage state) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.only(
          left: 18,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(
            20.0,
          ),
          child: Container(
            height: 120,
            color: Colors.green,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 35.0,
                ),
                child: Column(
                  children: [
                    Text(
                      '${state.countOfEventsInPeriod ?? '-'}',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'Events',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Padding _bookmarkedEventsBox(StatesStatisticsPage state) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 10.0,
        right: 10.0,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(
          20.0,
        ),
        child: Container(
          height: 120,
          width: MediaQuery.of(context).size.width,
          color: Colors.orangeAccent,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(
                top: 35.0,
              ),
              child: Column(
                children: [
                  Text(
                    '${state.countOfBookmarkedEventsInPeriod ?? '-'}',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'Bookmarked events',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Column _statisticsFields(StatesStatisticsPage state) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(
            10.0,
          ),
          child: Row(
            children: <Widget>[
              _notesBox(state),
              _eventsBox(state),
            ],
          ),
        ),
        _bookmarkedEventsBox(state),
        Expanded(
          child: charts.BarChart(
            BlocProvider.of<CubitStatisticsPage>(context)
                        .state
                        .selectedPeriod ==
                    'Past 7 days'
                ? _createWeekStatistics()
                : BlocProvider.of<CubitStatisticsPage>(context)
                            .state
                            .selectedPeriod ==
                        'Past 30 days'
                    ? _createMonthStatistics()
                    : _createYearStatistics(),
            barGroupingType: charts.BarGroupingType.stacked,
            animate: true,
            domainAxis: charts.OrdinalAxisSpec(
                renderSpec: charts.SmallTickRendererSpec(labelRotation: 60)),
          ),
        ),
      ],
    );
  }

  List<charts.Series<Statistics, String>> _chartsSeries(
    Function countEvents,
    Function countNotes,
    int value,
    int limit,
    int period,
  ) {
    return [
      charts.Series<Statistics, String>(
        id: 'events',
        measureFn: (sales, _) => sales.value,
        data: _generateList(countEvents, value, <Statistics>[], limit, period),
        colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
        domainFn: (sales, _) => sales.text,
      ),
      charts.Series<Statistics, String>(
        id: 'notes',
        measureFn: (sales, _) => sales.value,
        data: _generateList(countNotes, value, <Statistics>[], limit, period),
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (sales, _) => sales.text,
      ),
    ];
  }

  List<charts.Series<Statistics, String>> _createYearStatistics() {
    int _countYearEvents(int monthDifference) {
      return BlocProvider.of<CubitStatisticsPage>(context)
          .state
          .events
          .where((element) =>
              DateFormat().add_yMMMd().parse(element.date).isAfter(DateTime(
                  DateTime.now().year,
                  DateTime.now().month - monthDifference)) &&
              DateFormat().add_yMMMd().parse(element.date).isBefore(DateTime(
                  DateTime.now().year,
                  DateTime.now().month - monthDifference + 1)))
          .length;
    }

    int _countYearNotes(int monthDifference) {
      return BlocProvider.of<CubitStatisticsPage>(context)
          .state
          .notes
          .where((note) =>
              DateFormat().add_yMMMd().parse(note.date).isAfter(DateTime(
                  DateTime.now().year,
                  DateTime.now().month - monthDifference)) &&
              DateFormat().add_yMMMd().parse(note.date).isBefore(DateTime(
                  DateTime.now().year,
                  DateTime.now().month - monthDifference + 1)))
          .length;
    }

    return _chartsSeries(_countYearEvents, _countYearNotes, 10, -1, 1);
  }

  List<charts.Series<Statistics, String>> _createMonthStatistics() {
    int _countMonthEvents(int dayDifference) {
      return BlocProvider.of<CubitStatisticsPage>(context)
          .state
          .events
          .where((element) =>
              DateFormat().add_yMMMd().parse(element.date).isAfter(DateTime(
                  DateTime.now().year,
                  DateTime.now().month,
                  DateTime.now().day - dayDifference)) &&
              DateFormat().add_yMMMd().parse(element.date).isBefore(DateTime(
                  DateTime.now().year,
                  DateTime.now().month,
                  DateTime.now().day - dayDifference + 2)))
          .length;
    }

    int _countMonthNotes(int dayDifference) {
      return BlocProvider.of<CubitStatisticsPage>(context)
          .state
          .notes
          .where((element) =>
              DateFormat().add_yMMMd().parse(element.date).isAfter(DateTime(
                  DateTime.now().year,
                  DateTime.now().month,
                  DateTime.now().day - dayDifference)) &&
              DateFormat().add_yMMMd().parse(element.date).isBefore(DateTime(
                  DateTime.now().year,
                  DateTime.now().month,
                  DateTime.now().day - dayDifference + 2)))
          .length;
    }

    return _chartsSeries(_countMonthNotes, _countMonthEvents, 29, 0, 30);
  }

  List<charts.Series<Statistics, String>> _createWeekStatistics() {
    int _countWeekEvents(int dayDifference) {
      return BlocProvider.of<CubitStatisticsPage>(context)
          .state
          .events
          .where((element) =>
              DateFormat().add_yMMMd().parse(element.date).isAfter(DateTime(
                  DateTime.now().year,
                  DateTime.now().month,
                  DateTime.now().day - dayDifference)) &&
              DateFormat().add_yMMMd().parse(element.date).isBefore(DateTime(
                  DateTime.now().year,
                  DateTime.now().month,
                  DateTime.now().day - dayDifference + 2)))
          .length;
    }

    int _countWeekNotes(int dayDifference) {
      return BlocProvider.of<CubitStatisticsPage>(context)
          .state
          .notes
          .where((element) =>
              DateFormat().add_yMMMd().parse(element.date).isAfter(DateTime(
                  DateTime.now().year,
                  DateTime.now().month,
                  DateTime.now().day - dayDifference)) &&
              DateFormat().add_yMMMd().parse(element.date).isBefore(DateTime(
                  DateTime.now().year,
                  DateTime.now().month,
                  DateTime.now().day - dayDifference + 2)))
          .length;
    }

    return _chartsSeries(_countWeekNotes, _countWeekEvents, 7, 0, 7);
  }

  List<Statistics> _generateList(Function(int) function, int difference,
      List<Statistics> list, int limit, int period) {
    switch (period) {
      case 30:
        list.add(Statistics(
            '${DateFormat.d().format(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day - difference))}',
            function(difference + 1)));
        break;
      case 7:
        list.add(Statistics(
            '${DateFormat.MMMd().format(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day - difference))}',
            function(difference + 1)));
        break;
      case 1:
        list.add(Statistics(
            '${DateFormat.MMM().format(DateTime(DateTime.now().year, DateTime.now().month - 1 - difference, DateTime.now().day))}',
            function(difference + 1)));
        break;
    }

    if (difference != limit) {
      return _generateList(function, difference - 1, list, limit, period);
    }
    return list;
  }
}
