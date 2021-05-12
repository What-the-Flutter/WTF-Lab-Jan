import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
              _infoTile(
                  BlocProvider.of<StatisticsCubit>(context).countTotalDay(),
                  'Total',
                  Colors.lightBlueAccent[100]),
              _infoTile(
                  BlocProvider.of<StatisticsCubit>(context).countPagesDay(),
                  'Pages',
                  Colors.lightGreenAccent[100]),
              _infoTile(
                  BlocProvider.of<StatisticsCubit>(context).countMessagesDay(),
                  'Messages',
                  Colors.orangeAccent[100]),
              _infoTile(
                  BlocProvider.of<StatisticsCubit>(context).countBookmarksDay(),
                  'Bookmarks',
                  Colors.purpleAccent[100]),
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
          _infoTile(
              BlocProvider.of<StatisticsCubit>(context)
                  .countTotal(daysAgo, monthsAgo),
              'Total',
              Colors.lightBlueAccent[100]),
          _infoTile(
              BlocProvider.of<StatisticsCubit>(context)
                  .countPages(daysAgo, monthsAgo),
              'Pages',
              Colors.lightGreenAccent[100]),
          _infoTile(
              BlocProvider.of<StatisticsCubit>(context)
                  .countMessages(daysAgo, monthsAgo),
              'Messages',
              Colors.orangeAccent[100]),
          _infoTile(
              BlocProvider.of<StatisticsCubit>(context)
                  .countBookmarks(daysAgo, monthsAgo),
              'Bookmarks',
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

    Widget _chart() {
      List<charts.Series<Statistics, String>> createTodayData() {
        return [
          charts.Series<Statistics, String>(
            id: 'total',
            measureFn: (sales, _) => sales.value,
            data: BlocProvider.of<StatisticsCubit>(context)
                .generateHoursStatistics(0, 24,
                    BlocProvider.of<StatisticsCubit>(context).countTotalHours),
            colorFn: (_, __) => charts.Color.fromHex(code: '#A4EAF1'),
            domainFn: (sales, _) => sales.text,
          ),
          charts.Series<Statistics, String>(
            id: 'pages',
            measureFn: (sales, _) => sales.value,
            data: BlocProvider.of<StatisticsCubit>(context)
                .generateHoursStatistics(0, 24,
                    BlocProvider.of<StatisticsCubit>(context).countPagesHours),
            colorFn: (_, __) => charts.Color.fromHex(code: '#BAF67F'),
            domainFn: (sales, _) => sales.text,
          ),
          charts.Series<Statistics, String>(
            id: 'messages',
            measureFn: (sales, _) => sales.value,
            data: BlocProvider.of<StatisticsCubit>(context)
                .generateHoursStatistics(
                    0,
                    24,
                    BlocProvider.of<StatisticsCubit>(context)
                        .countMessagesHours),
            colorFn: (_, __) => charts.Color.fromHex(code: '#FFC966'),
            domainFn: (sales, _) => sales.text,
          ),
          charts.Series<Statistics, String>(
            id: 'bookmarks',
            measureFn: (sales, _) => sales.value,
            data: BlocProvider.of<StatisticsCubit>(context)
                .generateHoursStatistics(
                    0,
                    24,
                    BlocProvider.of<StatisticsCubit>(context)
                        .countBookmarksHours),
            colorFn: (_, __) => charts.Color.fromHex(code: '#EE82EE'),
            domainFn: (sales, _) => sales.text,
          ),
        ];
      }

      List<charts.Series<Statistics, String>> createWeekData() {
        return [
          charts.Series<Statistics, String>(
            id: 'total',
            measureFn: (sales, _) => sales.value,
            data: BlocProvider.of<StatisticsCubit>(context)
                .generateDaysStatistics(
                    1,
                    7,
                    BlocProvider.of<StatisticsCubit>(context)
                        .countTotalForDays),
            colorFn: (_, __) => charts.Color.fromHex(code: '#A4EAF1'),
            domainFn: (sales, _) => sales.text,
          ),
          charts.Series<Statistics, String>(
            id: 'pages',
            measureFn: (sales, _) => sales.value,
            data: BlocProvider.of<StatisticsCubit>(context)
                .generateDaysStatistics(
                    1,
                    7,
                    BlocProvider.of<StatisticsCubit>(context)
                        .countPagesForDays),
            colorFn: (_, __) => charts.Color.fromHex(code: '#BAF67F'),
            domainFn: (sales, _) => sales.text,
          ),
          charts.Series<Statistics, String>(
            id: 'messages',
            measureFn: (sales, _) => sales.value,
            data: BlocProvider.of<StatisticsCubit>(context)
                .generateDaysStatistics(
                    1,
                    7,
                    BlocProvider.of<StatisticsCubit>(context)
                        .countMessagesForDays),
            colorFn: (_, __) => charts.Color.fromHex(code: '#FFC966'),
            domainFn: (sales, _) => sales.text,
          ),
          charts.Series<Statistics, String>(
            id: 'bookmarks',
            measureFn: (sales, _) => sales.value,
            data: BlocProvider.of<StatisticsCubit>(context)
                .generateDaysStatistics(
                    1,
                    7,
                    BlocProvider.of<StatisticsCubit>(context)
                        .countBookmarksForDays),
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
            data: BlocProvider.of<StatisticsCubit>(context)
                .generateMonthStatistics(
                    1,
                    20,
                    BlocProvider.of<StatisticsCubit>(context)
                        .countTotalForDays),
            colorFn: (_, __) => charts.Color.fromHex(code: '#A4EAF1'),
            domainFn: (sales, _) => sales.text,
          ),
          charts.Series<Statistics, String>(
            id: 'pages',
            measureFn: (sales, _) => sales.value,
            data: BlocProvider.of<StatisticsCubit>(context)
                .generateMonthStatistics(
                    1,
                    20,
                    BlocProvider.of<StatisticsCubit>(context)
                        .countPagesForDays),
            colorFn: (_, __) => charts.Color.fromHex(code: '#BAF67F'),
            domainFn: (sales, _) => sales.text,
          ),
          charts.Series<Statistics, String>(
            id: 'messages',
            measureFn: (sales, _) => sales.value,
            data: BlocProvider.of<StatisticsCubit>(context)
                .generateMonthStatistics(
                    1,
                    20,
                    BlocProvider.of<StatisticsCubit>(context)
                        .countMessagesForDays),
            colorFn: (_, __) => charts.Color.fromHex(code: '#FFC966'),
            domainFn: (sales, _) => sales.text,
          ),
          charts.Series<Statistics, String>(
            id: 'bookmarks',
            measureFn: (sales, _) => sales.value,
            data: BlocProvider.of<StatisticsCubit>(context)
                .generateMonthStatistics(
                    1,
                    20,
                    BlocProvider.of<StatisticsCubit>(context)
                        .countBookmarksForDays),
            colorFn: (_, __) => charts.Color.fromHex(code: '#EE82EE'),
            domainFn: (sales, _) => sales.text,
          ),
        ];
      }

      List<charts.Series<Statistics, String>> createYearData() {
        return [
          charts.Series<Statistics, String>(
            id: 'total',
            measureFn: (sales, _) => sales.value,
            data: BlocProvider.of<StatisticsCubit>(context)
                .generateYearStatistics(
                    DateTime.now().month,
                    DateTime.january,
                    BlocProvider.of<StatisticsCubit>(context)
                        .countTotalForMonths),
            colorFn: (_, __) => charts.Color.fromHex(code: '#A4EAF1'),
            domainFn: (sales, _) => sales.text,
          ),
          charts.Series<Statistics, String>(
            id: 'pages',
            measureFn: (sales, _) => sales.value,
            data: BlocProvider.of<StatisticsCubit>(context)
                .generateYearStatistics(
                    DateTime.now().month,
                    DateTime.january,
                    BlocProvider.of<StatisticsCubit>(context)
                        .countPagesForMonths),
            colorFn: (_, __) => charts.Color.fromHex(code: '#BAF67F'),
            domainFn: (sales, _) => sales.text,
          ),
          charts.Series<Statistics, String>(
            id: 'messages',
            measureFn: (sales, _) => sales.value,
            data: BlocProvider.of<StatisticsCubit>(context)
                .generateYearStatistics(
                    DateTime.now().month,
                    DateTime.january,
                    BlocProvider.of<StatisticsCubit>(context)
                        .countMessagesForMonths),
            colorFn: (_, __) => charts.Color.fromHex(code: '#FFC966'),
            domainFn: (sales, _) => sales.text,
          ),
          charts.Series<Statistics, String>(
            id: 'bookmarks',
            measureFn: (sales, _) => sales.value,
            data: BlocProvider.of<StatisticsCubit>(context)
                .generateYearStatistics(
                    DateTime.now().month,
                    DateTime.january,
                    BlocProvider.of<StatisticsCubit>(context)
                        .countBookmarksForMonths),
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
