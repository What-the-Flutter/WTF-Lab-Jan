import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cubit_statistics_page.dart';
import 'states_statistics_page.dart';
import 'statistics.dart';

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({Key? key}) : super(key: key);

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
          appBar: _appBar,
          body: _statisticsPageBody(state),
        );
      },
    );
  }

  AppBar get _appBar {
    return AppBar(
      centerTitle: true,
      title: const Text('Statistics'),
    );
  }

  Column _statisticsPageBody(StatesStatisticsPage state) {
    return Column(
      children: [
        _dropDownButtonWithPeriod(state),
        Expanded(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    _infoBox(state.countOfNotes, 'Notes', Colors.blue),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child:
                            _infoBox(state.countOfEvents, 'Events', Colors.red),
                      ),
                    ),
                  ],
                ),
              ),
              _infoBox(state.countOfBookmarkedEvents, 'Bookmarked Events',
                  Colors.green),
              Expanded(
                child: charts.BarChart(
                  _createStatistics(state),
                  barGroupingType: charts.BarGroupingType.stacked,
                  animate: true,
                  domainAxis: const charts.OrdinalAxisSpec(
                    renderSpec: charts.SmallTickRendererSpec(
                      labelRotation: 60,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  List<charts.Series<Statistics, String>> _createStatistics(
      StatesStatisticsPage state) {
    var difference = state.selectedPeriod == 'Past 30 days'
        ? 29
        : state.selectedPeriod == 'Past 7 days'
            ? 7
            : 10;
    var limit = state.selectedPeriod == 'Past year' ? -1 : 0;
    var eventsList = BlocProvider.of<CubitStatisticsPage>(context)
        .generateList('Events', difference, <Statistics>[], limit, 0);
    BlocProvider.of<CubitStatisticsPage>(context)
        .setCount('Events', eventsList);
    var notesList = BlocProvider.of<CubitStatisticsPage>(context)
        .generateList('Notes', difference, <Statistics>[], limit, 0);
    BlocProvider.of<CubitStatisticsPage>(context).setCount('Notes', notesList);
    var bookmarkedEventsList = BlocProvider.of<CubitStatisticsPage>(context)
        .generateList('BookmarkedEvents', difference, <Statistics>[], limit, 0);
    BlocProvider.of<CubitStatisticsPage>(context)
        .setCount('BookmarkedEvents', bookmarkedEventsList);
    return [
      charts.Series<Statistics, String>(
        id: 'events',
        measureFn: (statistics, _) => statistics.value,
        data: eventsList,
        colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
        domainFn: (statistics, _) => statistics.text,
      ),
      charts.Series<Statistics, String>(
        id: 'notes',
        measureFn: (statistics, _) => statistics.value,
        data: notesList,
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (statistics, _) => statistics.text,
      ),
      charts.Series<Statistics, String>(
        id: 'bookmarkedEvents',
        measureFn: (statistics, _) => statistics.value,
        data: bookmarkedEventsList,
        colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
        domainFn: (statistics, _) => statistics.text,
      ),
    ];
  }

  ClipRRect _infoBox(int value, String text, Color color) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(
        20.0,
      ),
      child: Container(
        height: 120,
        width: MediaQuery.of(context).size.width / 2,
        color: color,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(
              top: 35.0,
            ),
            child: Column(
              children: [
                Text(
                  '$value',
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
                Text(
                  text,
                  style: const TextStyle(
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

  Container _dropDownButtonWithPeriod(StatesStatisticsPage state) {
    return Container(
      padding: const EdgeInsets.only(top: 8.0, left: 15, bottom: 8.0),
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
        underline: Container(
          height: 2,
        ),
        onChanged: (value) => BlocProvider.of<CubitStatisticsPage>(context)
            .setSelectedPeriod(value!),
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
    );
  }
}
