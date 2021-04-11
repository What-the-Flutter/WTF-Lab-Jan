import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../theme/theme_cubit.dart';
import 'statistics_screen_cubit.dart';
import 'statistics_screen_state.dart';

class StatisticsScreen extends StatefulWidget {
  static const routeName = '/Statistics';

  @override
  _StatisticsScreenState createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  @override
  void initState() {
    BlocProvider.of<StatisticsCubit>(context).initialize();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StatisticsCubit, StatisticsState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.only(right: 40),
              child: Text(
                'Summary',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w400),
              ),
            ),
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: _body(),
        );
      },
    );
  }

  Widget _body() {
    Widget _dropdownButton() {
      return Container(
        margin: EdgeInsets.all(20.0),
        alignment: Alignment.topLeft,
        child: DropdownButton<String>(
          value: BlocProvider.of<StatisticsCubit>(context).state.timeline,
          icon: Icon(
            Icons.keyboard_arrow_down,
          ),
          iconSize: 24,
          style: TextStyle(
              color:
                  BlocProvider.of<ThemeCubit>(context).state.theme.primaryColor,
              fontSize: 16),
          underline: Container(
            height: 2,
            color: BlocProvider.of<ThemeCubit>(context).state.theme.accentColor,
          ),
          onChanged: BlocProvider.of<StatisticsCubit>(context).setTimeline,
          items: <String>['Today', 'Past 7 days', 'Past 20 days', 'This year']
              .map<DropdownMenuItem<String>>(
            (value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            },
          ).toList(),
        ),
      );
    }

    int _countPagesDay() {
      final today = DateTime.now();
      final i = BlocProvider.of<StatisticsCubit>(context)
          .state
          .pages
          .where((element) => element.creationTime
              .isAfter(DateTime(today.year, today.month, today.day)))
          .length;
      return i;
    }

    int _countMessagesDay() {
      final today = DateTime.now();
      return BlocProvider.of<StatisticsCubit>(context)
          .state
          .messages
          .where((element) => element.time
              .isAfter(DateTime(today.year, today.month, today.day)))
          .length;
    }

    int _countBookmarksDay() {
      final today = DateTime.now();
      return BlocProvider.of<StatisticsCubit>(context)
          .state
          .messages
          .where((element) => (element.time
                  .isAfter(DateTime(today.year, today.month, today.day)) &&
              element.isBookmark))
          .length;
    }

    int _countTotalDay() {
      return _countMessagesDay() + _countPagesDay() + _countBookmarksDay();
    }

    int _countPages(int daysAgo, int monthsAgo) {
      final today = DateTime.now();
      print(DateTime(today.year, today.month - monthsAgo, today.day - daysAgo));
      print(DateTime(today.year, today.month, today.day));
      return BlocProvider.of<StatisticsCubit>(context)
          .state
          .pages
          .where(
            (element) => (element.creationTime.isAfter(DateTime(today.year,
                    today.month - monthsAgo, today.day - daysAgo)) &&
                element.creationTime
                    .isBefore(DateTime(today.year, today.month, today.day))),
          )
          .length;
    }

    int _countMessages(int daysAgo, int monthsAgo) {
      final today = DateTime.now();
      return BlocProvider.of<StatisticsCubit>(context)
          .state
          .messages
          .where(
            (element) => (element.time.isAfter(DateTime(today.year,
                    today.month - monthsAgo, today.day - daysAgo)) &&
                element.time
                    .isBefore(DateTime(today.year, today.month, today.day))),
          )
          .length;
    }

    int _countBookmarks(int daysAgo, int monthsAgo) {
      final today = DateTime.now();
      return BlocProvider.of<StatisticsCubit>(context)
          .state
          .messages
          .where((element) => (element.time.isAfter(DateTime(
                  today.year, today.month - monthsAgo, today.day - daysAgo)) &&
              element.isBookmark &&
              element.time
                  .isBefore(DateTime(today.year, today.month, today.day))))
          .length;
    }

    int _countTotal(int daysAgo, int monthsAgo) {
      return _countMessages(daysAgo, monthsAgo) +
          _countPages(daysAgo, monthsAgo) +
          _countBookmarks(daysAgo, monthsAgo);
    }

    Widget _grid() {
      Widget _infoTile(int value, String text, Color color) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: color,
          ),
          padding: const EdgeInsets.all(5),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  value.toString(),
                  style: TextStyle(fontSize: 18),
                ),
                Text(
                  text,
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
          ),
        );
      }

      List<Widget> variants() {
        var daysAgo = 0;
        var monthsAgo = 0;
        switch (BlocProvider.of<StatisticsCubit>(context).state.timeline) {
          case 'Today':
            return [
              _infoTile(_countTotalDay(), 'Total', Colors.lightBlueAccent[100]),
              _infoTile(
                  _countPagesDay(), 'Pages', Colors.lightGreenAccent[100]),
              _infoTile(
                  _countMessagesDay(), 'Messages', Colors.orangeAccent[100]),
              _infoTile(
                  _countBookmarksDay(), 'Bookmarks', Colors.purpleAccent[100]),
            ];
          case 'Past 7 days':
            daysAgo = 7;
            break;
          case 'Past 20 days':
            daysAgo = 20;
            break;
          default:
            monthsAgo = DateTime.now().month - DateTime.january;
        }
        return [
          _infoTile(_countTotal(daysAgo, monthsAgo), 'Total',
              Colors.lightBlueAccent[100]),
          _infoTile(_countPages(daysAgo, monthsAgo), 'Pages',
              Colors.lightGreenAccent[100]),
          _infoTile(_countMessages(daysAgo, monthsAgo), 'Messages',
              Colors.orangeAccent[100]),
          _infoTile(_countBookmarks(daysAgo, monthsAgo), 'Bookmarks',
              Colors.purpleAccent[100]),
        ];
      }

      return GridView.count(
        childAspectRatio: 3 / 1,
        shrinkWrap: true,
        padding: const EdgeInsets.all(5),
        crossAxisSpacing: 5,
        mainAxisSpacing: 5,
        crossAxisCount: 2,
        children: variants(),
      );
    }

    List<Statistics> generateHoursStatistics(
        int start, int end, Function(int) func) {
      final list = <Statistics>[];
      for (var i = start; i <= end; i++) {
        list.add(Statistics('$i', func(i)));
      }
      return list;
    }

    List<Statistics> generateDaysStatistics(
        int start, int end, Function(int) func) {
      final list = <Statistics>[];
      for (var i = end; i >= start; i--) {
        list.add(Statistics(
            DateFormat('EEEE')
                .format(DateTime.now().subtract(Duration(days: i)))
                .substring(0, 3),
            func(i)));
      }
      return list;
    }

    List<Statistics> generateMonthStatistics(
        int start, int end, Function(int) func) {
      final list = <Statistics>[];
      for (var i = end; i >= start; i--) {
        list.add(Statistics(
            DateFormat('d').format(DateTime.now().subtract(Duration(days: i))),
            func(i)));
      }
      return list;
    }

    List<Statistics> generateYearStatistics(
        int start, int end, Function(int) func) {
      final list = <Statistics>[];
      final today = DateTime.now();
      DateTime date;
      for (var i = start; i >= end - 1; i--) {
        date = today;
        date = DateTime(date.year, date.month - i, date.day, 0, 0);
        list.add(Statistics(
            DateFormat('MMM').format(date).substring(0, 3), func(i + 1)));
        print('DATE $date');
      }
      return list;
    }

    Widget _chart() {
      final today = DateTime.now();
      List<charts.Series<Statistics, String>> createTodayData() {
        var today = DateTime.now();
        today = DateTime(today.year, today.month, today.day, 0, 0);

        int countPages(int start) => BlocProvider.of<StatisticsCubit>(context)
            .state
            .pages
            .where((element) =>
                (element.creationTime.isAfter(
                    DateTime(today.year, today.month, today.day, start, 0))) &&
                element.creationTime.isBefore(
                    DateTime(today.year, today.month, today.day, start + 1, 0)))
            .length;

        int countMessages(int start) => BlocProvider.of<StatisticsCubit>(
                context)
            .state
            .messages
            .where((element) =>
                (element.time.isAfter(
                    DateTime(today.year, today.month, today.day, start, 0))) &&
                element.time.isBefore(
                    DateTime(today.year, today.month, today.day, start + 1, 0)))
            .length;

        int countBookmarks(int start) => BlocProvider.of<StatisticsCubit>(
                context)
            .state
            .messages
            .where((element) =>
                (element.isBookmark &&
                    element.time.isAfter(DateTime(
                        today.year, today.month, today.day, start, 0))) &&
                element.time.isBefore(
                    DateTime(today.year, today.month, today.day, start + 1, 0)))
            .length;

        int countTotal(int start) =>
            countBookmarks(start) + countMessages(start) + countPages(start);

        return [
          charts.Series<Statistics, String>(
            id: 'total',
            measureFn: (sales, _) => sales.value,
            data: generateHoursStatistics(0, 24, countTotal),
            colorFn: (_, __) => charts.Color.fromHex(code: '#A4EAF1'),
            domainFn: (sales, _) => sales.text,
          ),
          charts.Series<Statistics, String>(
            id: 'pages',
            measureFn: (sales, _) => sales.value,
            data: generateHoursStatistics(0, 24, countPages),
            colorFn: (_, __) => charts.Color.fromHex(code: '#BAF67F'),
            domainFn: (sales, _) => sales.text,
          ),
          charts.Series<Statistics, String>(
            id: 'messages',
            measureFn: (sales, _) => sales.value,
            data: generateHoursStatistics(0, 24, countMessages),
            colorFn: (_, __) => charts.Color.fromHex(code: '#FFC966'),
            domainFn: (sales, _) => sales.text,
          ),
          charts.Series<Statistics, String>(
            id: 'bookmarks',
            measureFn: (sales, _) => sales.value,
            data: generateHoursStatistics(0, 24, countBookmarks),
            colorFn: (_, __) => charts.Color.fromHex(code: '#EE82EE'),
            domainFn: (sales, _) => sales.text,
          ),
        ];
      }

      int countPagesForDays(int daysAgo) =>
          BlocProvider.of<StatisticsCubit>(context)
              .state
              .pages
              .where((element) =>
                  (element.creationTime.isAfter(DateTime(
                      today.year, today.month, today.day - daysAgo, 0, 0))) &&
                  element.creationTime.isBefore(DateTime(
                      today.year, today.month, today.day - daysAgo + 1, 0, 0)))
              .length;

      int countMessagesForDays(int daysAgo) =>
          BlocProvider.of<StatisticsCubit>(context)
              .state
              .messages
              .where((element) =>
                  (element.time.isAfter(DateTime(
                      today.year, today.month, today.day - daysAgo, 0, 0))) &&
                  element.time.isBefore(DateTime(
                      today.year, today.month, today.day - daysAgo + 1, 0, 0)))
              .length;

      int countBookmarksForDays(int daysAgo) =>
          BlocProvider.of<StatisticsCubit>(context)
              .state
              .messages
              .where((element) =>
                  (element.isBookmark &&
                      element.time.isAfter(DateTime(today.year, today.month,
                          today.day - daysAgo, 0, 0))) &&
                  element.time.isBefore(DateTime(
                      today.year, today.month, today.day - daysAgo + 1, 0, 0)))
              .length;

      int countTotalForDays(int daysAgo) =>
          countBookmarksForDays(daysAgo) +
          countMessagesForDays(daysAgo) +
          countPagesForDays(daysAgo);

      List<charts.Series<Statistics, String>> createWeekData() {
        return [
          charts.Series<Statistics, String>(
            id: 'total',
            measureFn: (sales, _) => sales.value,
            data: generateDaysStatistics(1, 7, countTotalForDays),
            colorFn: (_, __) => charts.Color.fromHex(code: '#A4EAF1'),
            domainFn: (sales, _) => sales.text,
          ),
          charts.Series<Statistics, String>(
            id: 'pages',
            measureFn: (sales, _) => sales.value,
            data: generateDaysStatistics(1, 7, countPagesForDays),
            colorFn: (_, __) => charts.Color.fromHex(code: '#BAF67F'),
            domainFn: (sales, _) => sales.text,
          ),
          charts.Series<Statistics, String>(
            id: 'messages',
            measureFn: (sales, _) => sales.value,
            data: generateDaysStatistics(1, 7, countMessagesForDays),
            colorFn: (_, __) => charts.Color.fromHex(code: '#FFC966'),
            domainFn: (sales, _) => sales.text,
          ),
          charts.Series<Statistics, String>(
            id: 'bookmarks',
            measureFn: (sales, _) => sales.value,
            data: generateDaysStatistics(1, 7, countBookmarksForDays),
            colorFn: (_, __) => charts.Color.fromHex(code: '#EE82EE'),
            domainFn: (sales, _) => sales.text,
          ),
        ];
      }

      List<charts.Series<Statistics, String>> createMonthData() {
        return [
          charts.Series<Statistics, String>(
            id: 'total',
            measureFn: (sales, _) => sales.value,
            data: generateMonthStatistics(1, 20, countTotalForDays),
            colorFn: (_, __) => charts.Color.fromHex(code: '#A4EAF1'),
            domainFn: (sales, _) => sales.text,
          ),
          charts.Series<Statistics, String>(
            id: 'pages',
            measureFn: (sales, _) => sales.value,
            data: generateMonthStatistics(1, 20, countPagesForDays),
            colorFn: (_, __) => charts.Color.fromHex(code: '#BAF67F'),
            domainFn: (sales, _) => sales.text,
          ),
          charts.Series<Statistics, String>(
            id: 'messages',
            measureFn: (sales, _) => sales.value,
            data: generateMonthStatistics(1, 20, countMessagesForDays),
            colorFn: (_, __) => charts.Color.fromHex(code: '#FFC966'),
            domainFn: (sales, _) => sales.text,
          ),
          charts.Series<Statistics, String>(
            id: 'bookmarks',
            measureFn: (sales, _) => sales.value,
            data: generateMonthStatistics(1, 20, countBookmarksForDays),
            colorFn: (_, __) => charts.Color.fromHex(code: '#EE82EE'),
            domainFn: (sales, _) => sales.text,
          ),
        ];
      }

      List<charts.Series<Statistics, String>> createYearData() {
        final today = DateTime.now();

        int countPages(int monthsAgo) => BlocProvider.of<StatisticsCubit>(
                context)
            .state
            .pages
            .where((element) =>
                (element.creationTime.isAfter(DateTime(
                    today.year, today.month - monthsAgo, today.day, 0, 0))) &&
                element.creationTime.isBefore(DateTime(
                    today.year, today.month - monthsAgo + 1, today.day, 0, 0)))
            .length;

        int countMessages(int monthsAgo) => BlocProvider.of<StatisticsCubit>(
                context)
            .state
            .messages
            .where((element) =>
                (element.time.isAfter(DateTime(
                    today.year, today.month - monthsAgo, today.day, 0, 0))) &&
                element.time.isBefore(DateTime(
                    today.year, today.month - monthsAgo + 1, today.day, 0, 0)))
            .length;

        int countBookmarks(int monthsAgo) =>
            BlocProvider.of<StatisticsCubit>(context)
                .state
                .messages
                .where((element) =>
                    (element.isBookmark &&
                        element.time.isAfter(DateTime(today.year,
                            today.month - monthsAgo, today.day, 0, 0))) &&
                    element.time.isBefore(DateTime(today.year,
                        today.month - monthsAgo + 1, today.day, 0, 0)))
                .length;

        int countTotal(int monthsAgo) =>
            countBookmarks(monthsAgo) +
            countMessages(monthsAgo) +
            countPages(monthsAgo);

        return [
          charts.Series<Statistics, String>(
            id: 'total',
            measureFn: (sales, _) => sales.value,
            data: generateYearStatistics(
                DateTime.now().month, DateTime.january, countTotal),
            colorFn: (_, __) => charts.Color.fromHex(code: '#A4EAF1'),
            domainFn: (sales, _) => sales.text,
          ),
          charts.Series<Statistics, String>(
            id: 'pages',
            measureFn: (sales, _) => sales.value,
            data:
                generateYearStatistics(DateTime.now().month, DateTime.january, countPages),
            colorFn: (_, __) => charts.Color.fromHex(code: '#BAF67F'),
            domainFn: (sales, _) => sales.text,
          ),
          charts.Series<Statistics, String>(
            id: 'messages',
            measureFn: (sales, _) => sales.value,
            data: generateYearStatistics(
                DateTime.now().month, DateTime.january, countMessages),
            colorFn: (_, __) => charts.Color.fromHex(code: '#FFC966'),
            domainFn: (sales, _) => sales.text,
          ),
          charts.Series<Statistics, String>(
            id: 'bookmarks',
            measureFn: (sales, _) => sales.value,
            data: generateYearStatistics(
                DateTime.now().month, DateTime.january, countBookmarks),
            colorFn: (_, __) => charts.Color.fromHex(code: '#EE82EE'),
            domainFn: (sales, _) => sales.text,
          ),
        ];
      }

      List<charts.Series<Statistics, String>> selectBarChart(String variant) {
        switch (variant) {
          case 'Today':
            return createTodayData();
          case 'Past 7 days':
            return createWeekData();
          case 'Past 20 days':
            return createMonthData();
          default:
            return createYearData();
        }
      }

      return Container(
        height: 400,
        child: charts.BarChart(
          selectBarChart(
              BlocProvider.of<StatisticsCubit>(context).state.timeline),
          barGroupingType: charts.BarGroupingType.stacked,
        ),
      );
    }

    return Column(
      children: [
        _dropdownButton(),
        ListView(
          shrinkWrap: true,
          physics: ScrollPhysics(),
          children: [
            _grid(),
            _chart(),
          ],
        ),
      ],
    );
  }
}

class Statistics {
  final String text;
  final int value;

  Statistics(
    this.text,
    this.value,
  );
}
