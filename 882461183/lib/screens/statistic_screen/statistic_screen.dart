import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '/models/chart_data.dart';
import '../statistic_filter_screen/statistic_filter_screen.dart';
import 'statistic_screen_cubit.dart';

class StatisticsScreen extends StatefulWidget {
  @override
  _StatisticsScreenState createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  final String today = 'Today';
  final String pastSevenDays = 'Past 7 days';
  final String pastThirtyDays = 'Past 30 days';
  final String thisYear = 'This Year';
  final pageFilterResult = [];

  @override
  void initState() {
    super.initState();
    BlocProvider.of<StatisticsCubit>(context)
        .showTotalListPastMonth(pageFilterResult);
    BlocProvider.of<StatisticsCubit>(context)
        .showBookmarkListPastMonth(pageFilterResult);
    BlocProvider.of<StatisticsCubit>(context)
        .showCategoryListPastMonth(pageFilterResult);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StatisticsCubit, StatisticScreenState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const Text('Statistics'),
          ),
          body: _bodyStructure(state),
          bottomNavigationBar: _bottomNavigationBar(),
        );
      },
    );
  }

  Widget _bodyStructure(StatisticScreenState state) {
    return Column(
      children: <Widget>[
        Container(
          margin: const EdgeInsets.all(10),
          child: Row(
            children: <Widget>[
              Expanded(
                child: _dropdownTimePeriodMenu(state),
              ),
              IconButton(
                icon: Icon(
                  Icons.filter_list,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                onPressed: () async {
                  pageFilterResult.clear();
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => StatisticsFiltersScreen(),
                    ),
                  );
                  if (result != null) {
                    pageFilterResult.addAll(result);
                  }
                },
              ),
            ],
          ),
        ),
        Row(
          children: <Widget>[
            Expanded(
              child: _summaryStatisticsContainer(
                  '${state.summaryTotalList.length}',
                  'Total',
                  Colors.blueAccent),
            ),
            Expanded(
              child: _summaryStatisticsContainer(
                  '${state.summaryBookmarkList.length}',
                  'Bookmarks',
                  Colors.greenAccent),
            ),
            Expanded(
              child: _summaryStatisticsContainer(
                  '${state.summaryCategoryList.length}',
                  'Category',
                  Colors.purpleAccent),
            ),
          ],
        ),
        _summaryStatisticsChart(state),
      ],
    );
  }

  Widget _summaryStatisticsContainer(
    String eventAmount,
    String title,
    Color color,
  ) {
    return Container(
      width: double.infinity,
      height: 60,
      margin: const EdgeInsets.fromLTRB(5, 6, 5, 6),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            eventAmount,
            style: const TextStyle(fontSize: 18),
          ),
          Text(title),
        ],
      ),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }

  Widget _summaryStatisticsChart(StatisticScreenState state) {
    final chartData = <ChartData>[];
    _initializeChartData(state, chartData);
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.only(top: 80),
      child: SfCartesianChart(
        primaryXAxis: CategoryAxis(),
        series: <ChartSeries>[
          StackedColumnSeries<ChartData, String>(
              dataSource: chartData,
              color: Colors.purpleAccent,
              xValueMapper: (events, _) => events.chartName,
              yValueMapper: (events, _) => events.categoryY),
          StackedColumnSeries<ChartData, String>(
              dataSource: chartData,
              color: Colors.greenAccent,
              xValueMapper: (events, _) => events.chartName,
              yValueMapper: (events, _) => events.bookmarkY),
          StackedColumnSeries<ChartData, String>(
              dataSource: chartData,
              color: Colors.blueAccent,
              xValueMapper: (events, _) => events.chartName,
              yValueMapper: (events, _) => events.totalY),
        ],
      ),
    );
  }

  void _initializeChartData(
      StatisticScreenState state, List<ChartData> chartData) {
    if (state.timePeriod == today) {
      _initializeTodayAndYearChartData(state, chartData, 'Today statistics');
    } else if (state.timePeriod == pastSevenDays) {
      _initializeWeekChartData(state, chartData);
    } else if (state.timePeriod == pastThirtyDays) {
      _initializeMonthChartData(state, chartData);
    } else if (state.timePeriod == thisYear) {
      _initializeTodayAndYearChartData(
          state, chartData, '${DateTime.now().year} statistics');
    }
  }

  void _initializeWeekChartData(
    StatisticScreenState state,
    List<ChartData> chartData,
  ) {
    for (var i = 0; i <= 7; i++) {
      chartData.add(
        ChartData(
            chartName: '$i',
            totalY: state.summaryTotalList
                .where((event) =>
                    DateTime.now().difference(event.date).inDays == i)
                .length,
            bookmarkY: state.summaryBookmarkList
                .where((event) =>
                    DateTime.now().difference(event.date).inDays == i)
                .length,
            categoryY: state.summaryCategoryList
                .where((event) =>
                    DateTime.now().difference(event.date).inDays == i)
                .length),
      );
    }
  }

  void _initializeMonthChartData(
      StatisticScreenState state, List<ChartData> chartData) {
    for (var i = 0; i <= 30; i++) {
      chartData.add(
        ChartData(
            chartName: '$i',
            totalY: state.summaryTotalList
                .where((event) =>
                    DateTime.now().difference(event.date).inDays == i)
                .length,
            bookmarkY: state.summaryBookmarkList
                .where((event) =>
                    DateTime.now().difference(event.date).inDays == i)
                .length,
            categoryY: state.summaryCategoryList
                .where((event) =>
                    DateTime.now().difference(event.date).inDays == i)
                .length),
      );
    }
  }

  void _initializeTodayAndYearChartData(
    StatisticScreenState state,
    List<ChartData> chartData,
    String chartName,
  ) {
    chartData.add(
      ChartData(
        chartName: chartName,
        totalY: state.summaryTotalList.length,
        bookmarkY: state.summaryBookmarkList.length,
        categoryY: state.summaryCategoryList.length,
      ),
    );
  }

  Widget _dropdownTimePeriodMenu(StatisticScreenState state) {
    return DropdownButton<String>(
      value: state.timePeriod,
      isExpanded: true,
      icon: const Icon(Icons.keyboard_arrow_down),
      elevation: 16,
      underline: Container(
        height: 1,
        color: Colors.grey,
      ),
      onChanged: (newValue) {
        BlocProvider.of<StatisticsCubit>(context).selectTimePeriod(newValue!);
        _showResultLists(newValue);
      },
      items: <String>[today, pastSevenDays, pastThirtyDays, thisYear]
          .map<DropdownMenuItem<String>>((value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  void _showResultLists(String newValue) {
    final bloc = BlocProvider.of<StatisticsCubit>(context);
    if (newValue == today) {
      bloc.showTotalListToday(pageFilterResult);
      bloc.showBookmarkListToday(pageFilterResult);
      bloc.showCategoryListToday(pageFilterResult);
    } else if (newValue == thisYear) {
      bloc.showTotalListThisYear(pageFilterResult);
      bloc.showBookmarkListThisYear(pageFilterResult);
      bloc.showCategoryListThisYear(pageFilterResult);
    } else if (newValue == pastThirtyDays) {
      bloc.showTotalListPastMonth(pageFilterResult);
      bloc.showBookmarkListPastMonth(pageFilterResult);
      bloc.showCategoryListPastMonth(pageFilterResult);
    } else if (newValue == pastSevenDays) {
      bloc.showTotalListPastWeek(pageFilterResult);
      bloc.showBookmarkListPastWeek(pageFilterResult);
      bloc.showCategoryListPastWeek(pageFilterResult);
    }
  }

  BottomNavigationBar _bottomNavigationBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: [
        const BottomNavigationBarItem(
          icon: Icon(Icons.bubble_chart),
          label: ('Labels'),
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.mood),
          label: ('Mood'),
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.multiline_chart),
          label: ('Charts'),
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.access_time),
          label: ('Times'),
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.insert_chart),
          label: ('Summary'),
        )
      ],
    );
  }
}
