import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../models/statistics.dart';
import '../../ui/theme_cubit/theme_cubit.dart';
import 'statistics_page_cubit.dart';

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({Key? key}) : super(key: key);

  @override
  _StatisticsPageState createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  static final _today = DateTime.now();
  final DateTime _sevenDaysAgoDate =
      DateTime(_today.year, _today.month, _today.day - 7);
  final DateTime _thirtyDaysAgoDate =
      DateTime(_today.year, _today.month, _today.day - 30);

  @override
  void initState() {
    BlocProvider.of<StatisticsPageCubit>(context).init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StatisticsPageCubit, StatisticsPageState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text('Statistics'),
          ),
          body: _statisticsBody(),
        );
      },
    );
  }

  Widget _statisticsBody() {
    return ListView(
      physics: ScrollPhysics(),
      children: [
        ListTile(
          title:
              Text(BlocProvider.of<StatisticsPageCubit>(context).state.period),
          trailing:
              BlocProvider.of<StatisticsPageCubit>(context).state.isSelected
                  ? Icon(Icons.arrow_drop_up)
                  : Icon(Icons.arrow_drop_down),
          onTap: () =>
              BlocProvider.of<StatisticsPageCubit>(context).setSelectedState(),
        ),
        if (BlocProvider.of<StatisticsPageCubit>(context).state.isSelected)
          _columnOfPeriodsListTile(),
        _rowOfStatisticsElements,
        Padding(
          padding: EdgeInsets.only(top: 10),
        ),
        Padding(
          padding: EdgeInsets.only(left: 7, right: 7),
          child: _eventsTileForCurrentPeriod(),
        ),
        _charts(),
      ],
    );
  }
  List<charts.Series<Statistics, String>> _todayDate() {
    int _countHourEvents(int difference) {
      final today = DateTime.now();
      return BlocProvider.of<StatisticsPageCubit>(context)
          .state
          .events
          .where((element) =>
      (DateFormat().add_yMMMd().parse(element.date).isAfter(
          DateTime(today.year, today.month, today.day - 1)) &&
          DateFormat().add_yMMMd().parse(element.date).isBefore(
              DateTime(today.year, today.month, today.day + 1))) &&
          (DateFormat()
              .add_H()
              .parse(element.time)
              .isAfter(DateTime(today.hour - difference)) &&
              DateFormat()
                  .add_H()
                  .parse(element.time)
                  .isBefore(DateTime(today.hour - difference + 2))))
          .length;
    }

    int _countHourBookmarks(int difference) {
      final today = DateTime.now();
      final bookmarkList = BlocProvider.of<StatisticsPageCubit>(context)
          .state
          .events
          .where((element) => element.isBookmarked);
      return bookmarkList
          .where((element) =>
      (DateFormat()
          .add_yMMMd()
          .parse(element.bookmarkCreateTime)
          .isAfter(
          DateTime(today.year, today.month, today.day - 1)) &&
          DateFormat()
              .add_yMMMd()
              .parse(element.bookmarkCreateTime)
              .isBefore(
              DateTime(today.year, today.month, today.day + 1))) &&
          (DateFormat().add_H().parse(element.time).isAfter(DateTime(
              today.year,
              today.month,
              today.day,
              today.hour - difference)) &&
              DateFormat().add_H().parse(element.time).isBefore(DateTime(
                  today.year,
                  today.month,
                  today.day,
                  today.hour - difference + 2))))
          .length;
    }

    int _countNotes(int difference) {
      final today = DateTime.now();
      return BlocProvider.of<StatisticsPageCubit>(context)
          .state
          .notes
          .where((element) =>
      DateFormat()
          .add_yMMMd()
          .parse(element.date)
          .isAfter(DateTime(today.year, today.month, today.day - 1)) &&
          DateFormat()
              .add_yMMMd()
              .parse(element.date)
              .isBefore(DateTime(today.year, today.month, today.day + 1)))
          .length;
    }

    return _chartsSeries(
        _countHourEvents, _countHourEvents, _countHourBookmarks, 24, 0, 2);
  }

  List<charts.Series<Statistics, String>> _weekData() {
    int _countWeekEvents(int dayDifference) {
      return BlocProvider.of<StatisticsPageCubit>(context)
          .state
          .events
          .where((element) =>
      DateFormat().add_yMMMd().parse(element.date).isAfter(DateTime(
          _today.year, _today.month, _today.day - dayDifference)) &&
          DateFormat().add_yMMMd().parse(element.date).isBefore(DateTime(
              _today.year, _today.month, _today.day - dayDifference + 2)))
          .length;
    }

    int _countWeekBookmarks(int dayDifference) {
      final bookmarkList = BlocProvider.of<StatisticsPageCubit>(context)
          .state
          .events
          .where((element) => element.isBookmarked);
      return bookmarkList
          .where((element) =>
      DateFormat()
          .add_yMMMd()
          .parse(element.bookmarkCreateTime)
          .isAfter(DateTime(
          _today.year, _today.month, _today.day - dayDifference)) &&
          DateFormat()
              .add_yMMMd()
              .parse(element.bookmarkCreateTime)
              .isBefore(DateTime(_today.year, _today.month,
              _today.day - dayDifference + 2)))
          .length;
    }

    int _countWeekNotes(int dayDifference) {
      return BlocProvider.of<StatisticsPageCubit>(context)
          .state
          .notes
          .where((element) =>
      DateFormat().add_yMMMd().parse(element.date).isAfter(DateTime(
          _today.year, _today.month, _today.day - dayDifference)) &&
          DateFormat().add_yMMMd().parse(element.date).isBefore(DateTime(
              _today.year, _today.month, _today.day - dayDifference + 2)))
          .length;
    }

    return _chartsSeries(
        _countWeekNotes, _countWeekEvents, _countWeekBookmarks, 7, 0, 7);
  }

  List<charts.Series<Statistics, String>> _monthData() {
    int _countMonthEvents(int dayDifference) {
      return BlocProvider.of<StatisticsPageCubit>(context)
          .state
          .events
          .where((element) =>
      DateFormat().add_yMMMd().parse(element.date).isAfter(DateTime(
          _today.year, _today.month, _today.day - dayDifference)) &&
          DateFormat().add_yMMMd().parse(element.date).isBefore(DateTime(
              _today.year, _today.month, _today.day - dayDifference + 2)))
          .length;
    }

    int _countMonthBookmarks(int dayDifference) {
      final bookmarkList = BlocProvider.of<StatisticsPageCubit>(context)
          .state
          .events
          .where((element) => element.isBookmarked);
      return bookmarkList
          .where((element) =>
      DateFormat()
          .add_yMMMd()
          .parse(element.bookmarkCreateTime)
          .isAfter(DateTime(
          _today.year, _today.month, _today.day - dayDifference)) &&
          DateFormat()
              .add_yMMMd()
              .parse(element.bookmarkCreateTime)
              .isBefore(DateTime(_today.year, _today.month,
              _today.day - dayDifference + 2)))
          .length;
    }

    int _countMonthNotes(int dayDifference) {
      return BlocProvider.of<StatisticsPageCubit>(context)
          .state
          .notes
          .where((element) =>
      DateFormat().add_yMMMd().parse(element.date).isAfter(DateTime(
          _today.year, _today.month, _today.day - dayDifference)) &&
          DateFormat().add_yMMMd().parse(element.date).isBefore(DateTime(
              _today.year, _today.month, _today.day - dayDifference + 2)))
          .length;
    }

    return _chartsSeries(
        _countMonthNotes, _countMonthEvents, _countMonthBookmarks, 29, 0, 30);
  }

  List<Statistics> _generator(Function(int) func, int difference,
      List<Statistics> statisticsList, int limit, int period) {
    switch (period) {
      case 30:
        statisticsList.add(Statistics(
            '${DateFormat.d().format(DateTime(_today.year, _today.month, _today.day - difference))}',
            func(difference + 1)));
        break;
      case 7:
        statisticsList.add(Statistics(
            '${DateFormat.MMMd().format(DateTime(_today.year, _today.month, _today.day - difference))}',
            func(difference + 1)));
        break;
      case 1:
        statisticsList.add(Statistics(
            '${DateFormat.MMM().format(DateTime(_today.year, _today.month - 1 - difference, _today.day))}',
            func(difference + 1)));
        break;
      case 2:
        statisticsList.add(Statistics(
            '${DateFormat.H().format(DateTime(_today.year, _today.month, _today.day, _today.hour - difference))}',
            func(difference + 1)));
        break;
    }

    while (difference != limit) {
      return _generator(func, difference - 1, statisticsList, limit, period);
    }

    return statisticsList;
  }

  List<charts.Series<Statistics, String>> _chartsSeries(
      Function(int) countNotes,
      Function(int) countEvents,
      Function(int) countBookmarks,
      int value,
      int limit,
      period,
      ) {
    return [
      charts.Series<Statistics, String>(
        id: 'notes',
        measureFn: (sales, _) => sales.value,
        data: _generator(countNotes, value, <Statistics>[], limit, period),
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (sales, _) => sales.text,
      ),
      charts.Series<Statistics, String>(
        id: 'events',
        measureFn: (sales, _) => sales.value,
        data: _generator(countEvents, value, <Statistics>[], limit, period),
        colorFn: (_, __) => charts.MaterialPalette.deepOrange.shadeDefault,
        domainFn: (sales, _) => sales.text,
      ),
      charts.Series<Statistics, String>(
        id: 'bookmarks',
        measureFn: (sales, _) => sales.value,
        data: _generator(countBookmarks, value, <Statistics>[], limit, period),
        colorFn: (_, __) => charts.MaterialPalette.pink.shadeDefault,
        domainFn: (sales, _) => sales.text,
      ),
    ];
  }

  List<charts.Series<Statistics, String>> _yearData() {
    int _countYearEvents(int monthDifference) {
      return BlocProvider.of<StatisticsPageCubit>(context)
          .state
          .events
          .where((element) =>
      DateFormat().add_yMMMd().parse(element.date).isAfter(
          DateTime(_today.year, _today.month - monthDifference)) &&
          DateFormat().add_yMMMd().parse(element.date).isBefore(
              DateTime(_today.year, _today.month - monthDifference + 1)))
          .length;
    }

    int _countYearBookmarks(int monthDifference) {
      final bookmarkList = BlocProvider.of<StatisticsPageCubit>(context)
          .state
          .events
          .where((element) => element.isBookmarked);
      return bookmarkList
          .where((element) =>
      DateFormat()
          .add_yMMMd()
          .parse(element.bookmarkCreateTime)
          .isAfter(
          DateTime(_today.year, _today.month - monthDifference)) &&
          DateFormat()
              .add_yMMMd()
              .parse(element.bookmarkCreateTime)
              .isBefore(DateTime(
              _today.year, _today.month - monthDifference + 1)))
          .length;
    }

    int _countYearNotes(int monthDifference) {
      return BlocProvider.of<StatisticsPageCubit>(context)
          .state
          .notes
          .where((element) =>
      DateFormat().add_yMMMd().parse(element.date).isAfter(
          DateTime(_today.year, _today.month - monthDifference)) &&
          DateFormat().add_yMMMd().parse(element.date).isBefore(
              DateTime(_today.year, _today.month - monthDifference + 1)))
          .length;
    }

    return _chartsSeries(
        _countYearNotes, _countYearEvents, _countYearBookmarks, 10, -1, 1);
  }

  Widget _charts() {
    return Container(
      height: 450,
      child: charts.BarChart(
        BlocProvider.of<StatisticsPageCubit>(context).state.period == 'Today'
            ? _todayDate()
            : BlocProvider.of<StatisticsPageCubit>(context).state.period ==
            'Past 7 days'
            ? _weekData()
            : BlocProvider.of<StatisticsPageCubit>(context).state.period ==
            'Past 30 days'
            ? _monthData()
            : _yearData(),
        barGroupingType: charts.BarGroupingType.stacked,
      ),
    );
  }

  Wrap get _rowOfStatisticsElements {
    return Wrap(
      alignment: WrapAlignment.spaceAround,
      children: _infoTileForCurrentPeriod(),
    );
  }

  Widget _eventsTileForCurrentPeriod() {
    var widget;
    switch (BlocProvider.of<StatisticsPageCubit>(context).state.period) {
      case 'Today':
        widget = _infoTile(_countEvents(1, 0), 'Events');
        break;
      case 'Past 7 days':
        widget = _infoTile(_countEvents(8, 0), 'Events');
        break;
      case 'Past 30 days':
        widget = _infoTile(_countEvents(31, 0), 'Events');
        break;
      case 'Past year':
        widget = _infoTile(_countEvents(0, 1), 'Events');
        break;
    }
    return widget;
  }

  List<Widget> _infoTileForCurrentPeriod() {
    var listOfWidgets;
    switch (BlocProvider.of<StatisticsPageCubit>(context).state.period) {
      case 'Today':
        listOfWidgets = <Widget>[
          _infoTile(_countNotes(1, 0), 'Notes'),
          _infoTile(_countBookmarks(1, 0), 'Bookmarks'),
        ];
        break;
      case 'Past 7 days':
        listOfWidgets = <Widget>[
          _infoTile(_countNotes(8, 0), 'Notes'),
          _infoTile(_countBookmarks(8, 0), 'Bookmarks'),
        ];
        break;
      case 'Past 30 days':
        listOfWidgets = <Widget>[
          _infoTile(_countNotes(31, 0), 'Notes'),
          _infoTile(_countBookmarks(31, 0), 'Bookmarks'),
        ];
        break;
      case 'Past year':
        listOfWidgets = <Widget>[
          _infoTile(_countNotes(0, 1), 'Notes'),
          _infoTile(_countBookmarks(0, 1), 'Bookmarks'),
        ];
    }
    return listOfWidgets;
  }

  TextStyle? _textStyle(String period) {
    return BlocProvider.of<StatisticsPageCubit>(context).state.period == period
        ? BlocProvider.of<ThemeCubit>(context).state.isLight
        ? TextStyle(color: Colors.blue)
        : TextStyle(color: Colors.greenAccent)
        : null;
  }

  Widget _columnOfPeriodsListTile() {
    return Column(
      children: [
        ListTile(
          title: Text(
            'Today',
            style: _textStyle('Today'),
          ),
          subtitle: Text(
            DateFormat.yMMMd().format(_today),
            style: _textStyle('Today'),
          ),
          onTap: () {
            BlocProvider.of<StatisticsPageCubit>(context)
                .setSelectedPeriod('Today');
            BlocProvider.of<StatisticsPageCubit>(context).setSelectedState();
          },
          selectedTileColor: Colors.yellow,
        ),
        ListTile(
          title: Text(
            'Past 7 days',
            style: _textStyle('Past 7 days'),
          ),
          subtitle: Text(
            '${DateFormat.yMMMd().format(_sevenDaysAgoDate)} - '
                '${DateFormat.yMMMd().format(_today)}',
            style: _textStyle('Past 7 days'),
          ),
          onTap: () {
            BlocProvider.of<StatisticsPageCubit>(context)
                .setSelectedPeriod('Past 7 days');
            BlocProvider.of<StatisticsPageCubit>(context).setSelectedState();
          },
        ),
        ListTile(
          title: Text(
            'Past 30 days',
            style: _textStyle('Past 30 days'),
          ),
          subtitle: Text(
            '${DateFormat.yMMMd().format(_thirtyDaysAgoDate)} - '
                '${DateFormat.yMMMd().format(_today)}',
            style: _textStyle('Past 30 days'),
          ),
          onTap: () {
            BlocProvider.of<StatisticsPageCubit>(context)
                .setSelectedPeriod('Past 30 days');
            BlocProvider.of<StatisticsPageCubit>(context).setSelectedState();
          },
        ),
        ListTile(
          title: Text(
            'Past year',
            style: _textStyle('Past year'),
          ),
          subtitle: Text(
            DateFormat.y().format(_today),
            style: _textStyle('Past year'),
          ),
          onTap: () {
            BlocProvider.of<StatisticsPageCubit>(context)
                .setSelectedPeriod('Past year');
            BlocProvider.of<StatisticsPageCubit>(context).setSelectedState();
          },
        ),
      ],
    );
  }

  Widget _infoTile(int count, String element) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.red,
      ),
      height: 80,
      padding: const EdgeInsets.all(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            '$count',
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
            ),
          ),
          Text(
            element,
            style: TextStyle(
              fontSize: 15,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  int _countEvents(int dayDifference, int yearDifference) {
    return BlocProvider.of<StatisticsPageCubit>(context)
        .state
        .events
        .where((element) =>
    DateFormat().add_yMMMd().parse(element.date).isAfter(DateTime(
      _today.year - yearDifference,
      _today.month,
      _today.day - dayDifference,
    )) &&
        DateFormat().add_yMMMd().parse(element.date).isBefore(DateTime(
          _today.year + yearDifference,
          _today.month,
          _today.day + 1,
        )))
        .length;
  }

  int _countBookmarks(int dayDifference, int yearDifference) {
    final bookmarkList = BlocProvider.of<StatisticsPageCubit>(context)
        .state
        .events
        .where((element) => element.isBookmarked);
    return bookmarkList
        .where((element) =>
    DateFormat().add_yMMMd().parse(element.bookmarkCreateTime).isAfter(
        DateTime(_today.year - yearDifference, _today.month,
            _today.day - dayDifference)) &&
        DateFormat().add_yMMMd().parse(element.bookmarkCreateTime).isBefore(
            DateTime(_today.year + yearDifference, _today.month,
                _today.day + 1)))
        .length;
  }

  int _countNotes(int dayDifference, int yearDifference) {
    return BlocProvider.of<StatisticsPageCubit>(context)
        .state
        .notes
        .where((element) =>
    DateFormat().add_yMMMd().parse(element.date).isAfter(DateTime(
        _today.year - yearDifference,
        _today.month,
        _today.day - dayDifference)) &&
        DateFormat().add_yMMMd().parse(element.date).isBefore(DateTime(
            _today.year + yearDifference, _today.month, _today.day + 1)))
        .length;
  }
}