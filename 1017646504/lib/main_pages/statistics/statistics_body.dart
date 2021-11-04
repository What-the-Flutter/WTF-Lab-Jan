import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../entity/statistics.dart';

import 'statistics_cubit.dart';
import 'statistics_state.dart';

class StatisticsPage extends StatefulWidget {
  @override
  _StatisticsPageState createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  @override
  void initState() {
    BlocProvider.of<StatisticsCubit>(context).initialize();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StatisticsCubit, StatisticsState>(
      builder: (context, state) {
        return ListView(
          shrinkWrap: true,
          physics: const ScrollPhysics(),
          children: [
            _summary(),
          ],
        );
      },
    );
  }

  Widget _summary() {
    Widget _dropdown() {
      return Align(
        alignment: Alignment.topLeft,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: DropdownButton<String>(
            value: BlocProvider.of<StatisticsCubit>(context).state.selectedTimeline,
            items: <String>[
              'Today',
              'Past week',
            ].map<DropdownMenuItem<String>>((value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: BlocProvider.of<StatisticsCubit>(context).setSelectedTimeline,
          ),
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
          padding: const EdgeInsets.all(8),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(value.toString()),
                Text(text),
              ],
            ),
          ),
        );
      }

      int _countDayPages() {
        final today = DateTime.now();
        return BlocProvider.of<StatisticsCubit>(context)
            .state
            .pages
            .where((element) =>
                element.creationTime.isAfter(DateTime(today.year, today.month, today.day, 0, 0)))
            .length;
      }

      int _countDayEvents() {
        final today = DateTime.now();
        return BlocProvider.of<StatisticsCubit>(context)
            .state
            .events
            .where((element) =>
                element.creationTime.isAfter(DateTime(today.year, today.month, today.day, 0, 0)))
            .length;
      }

      int _countDayFavourites() {
        final today = DateTime.now();
        return BlocProvider.of<StatisticsCubit>(context)
            .state
            .events
            .where((element) =>
                (element.creationTime.isAfter(DateTime(today.year, today.month, today.day, 0, 0)) &&
                    element.isFavourite))
            .length;
      }

      int _countWeekPages() {
        final today = DateTime.now();
        return BlocProvider.of<StatisticsCubit>(context)
            .state
            .pages
            .where((element) =>
                (element.creationTime.isAfter(DateTime(today.year, today.month, 5, 0, 0)) &&
                    element.creationTime.isBefore(DateTime(today.year, today.month, 12, 0, 0))))
            .length;
      }

      int _countWeekEvents() {
        final today = DateTime.now();
        return BlocProvider.of<StatisticsCubit>(context)
            .state
            .events
            .where((element) =>
                (element.creationTime.isAfter(DateTime(today.year, today.month, 5, 0, 0)) &&
                    element.creationTime.isBefore(DateTime(today.year, today.month, 12, 0, 0))))
            .length;
      }

      int _countWeekFavourites() {
        final today = DateTime.now();
        return BlocProvider.of<StatisticsCubit>(context)
            .state
            .events
            .where((element) =>
                (element.creationTime.isAfter(DateTime(today.year, today.month, 5, 0, 0)) &&
                    element.isFavourite &&
                    element.creationTime.isBefore(DateTime(today.year, today.month, 12, 0, 0))))
            .length;
      }

      return GridView.count(
        childAspectRatio: 3 / 1,
        shrinkWrap: true,
        padding: const EdgeInsets.all(5),
        crossAxisSpacing: 5,
        mainAxisSpacing: 5,
        crossAxisCount: 2,
        children: BlocProvider.of<StatisticsCubit>(context).state.selectedTimeline == 'Today'
            ? [
                _infoTile(_countDayPages(), 'Pages', Colors.red),
                _infoTile(_countDayEvents(), 'Events', Colors.purple),
                _infoTile(_countDayFavourites(), 'Favourites', Colors.greenAccent),
              ]
            : [
                _infoTile(_countWeekPages(), 'Pages', Colors.red),
                _infoTile(_countWeekEvents(), 'Events', Colors.purple),
                _infoTile(_countWeekFavourites(), 'Favourites', Colors.greenAccent),
              ],
      );
    }

    Widget _chart() {
      List<charts.Series<Statistics, String>> createTodayData() {
        var today = DateTime.now();
        today = DateTime(today.year, today.month, today.day, 0, 0);

        int countPages(int start) => BlocProvider.of<StatisticsCubit>(context)
            .state
            .pages
            .where((element) =>
                (element.creationTime
                    .isAfter(DateTime(today.year, today.month, today.day, start, 0))) &&
                element.creationTime
                    .isBefore(DateTime(today.year, today.month, today.day, start + 1, 0)))
            .length;

        int countEvents(int start) => BlocProvider.of<StatisticsCubit>(context)
            .state
            .events
            .where((element) =>
                (element.creationTime
                    .isAfter(DateTime(today.year, today.month, today.day, start, 0))) &&
                element.creationTime
                    .isBefore(DateTime(today.year, today.month, today.day, start + 1, 0)))
            .length;

        int countFavourites(int start) => BlocProvider.of<StatisticsCubit>(context)
            .state
            .events
            .where((element) =>
                (element.isFavourite &&
                    element.creationTime
                        .isAfter(DateTime(today.year, today.month, today.day, start, 0))) &&
                element.creationTime
                    .isBefore(DateTime(today.year, today.month, today.day, start + 1, 0)))
            .length;

        BlocProvider.of<StatisticsCubit>(context).state.events.forEach((element) {
          print(element.creationTime);
        });

        print(countEvents(13));

        List<Statistics> _generate(Function(int) func) => [
              Statistics('0', func(0)),
              Statistics('1', func(1)),
              Statistics('2', func(2)),
              Statistics('3', func(3)),
              Statistics('4', func(4)),
              Statistics('5', func(5)),
              Statistics('6', func(6)),
              Statistics('7', func(7)),
              Statistics('8', func(8)),
              Statistics('9', func(9)),
              Statistics('10', func(10)),
              Statistics('11', func(11)),
              Statistics('12', func(12)),
              Statistics('13', func(13)),
              Statistics('14', func(14)),
              Statistics('15', func(15)),
              Statistics('16', func(16)),
              Statistics('17', func(17)),
              Statistics('18', func(18)),
              Statistics('19', func(19)),
              Statistics('20', func(20)),
              Statistics('21', func(21)),
              Statistics('22', func(22)),
              Statistics('23', func(23)),
              Statistics('24', 0),
            ];

        return [
          charts.Series<Statistics, String>(
            id: 'pages',
            measureFn: (sales, _) => sales.value,
            data: _generate(countPages),
            colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
            domainFn: (sales, _) => sales.text,
          ),
          charts.Series<Statistics, String>(
            id: 'events',
            measureFn: (sales, _) => sales.value,
            data: _generate(countEvents),
            colorFn: (_, __) => charts.MaterialPalette.deepOrange.shadeDefault,
            domainFn: (sales, _) => sales.text,
          ),
          charts.Series<Statistics, String>(
            id: 'favourites',
            measureFn: (sales, _) => sales.value,
            data: _generate(countFavourites),
            colorFn: (_, __) => charts.MaterialPalette.pink.shadeDefault,
            domainFn: (sales, _) => sales.text,
          ),
        ];
      }

      List<charts.Series<Statistics, String>> createWeekData() {
        var today = DateTime.now();

        int countPages(int start) => BlocProvider.of<StatisticsCubit>(context)
            .state
            .pages
            .where((element) =>
                (element.creationTime.isAfter(DateTime(today.year, today.month, start, 0, 0))) &&
                element.creationTime.isBefore(DateTime(today.year, today.month, start + 1, 0, 0)))
            .length;

        int countEvents(int start) => BlocProvider.of<StatisticsCubit>(context)
            .state
            .events
            .where((element) =>
                (element.creationTime.isAfter(DateTime(today.year, today.month, start, 0, 0))) &&
                element.creationTime.isBefore(DateTime(today.year, today.month, start + 1, 0, 0)))
            .length;

        int countFavourites(int start) => BlocProvider.of<StatisticsCubit>(context)
            .state
            .events
            .where((element) =>
                (element.isFavourite &&
                    element.creationTime.isAfter(DateTime(today.year, today.month, start, 0, 0))) &&
                element.creationTime.isBefore(DateTime(today.year, today.month, start + 1, 0, 0)))
            .length;

        List<Statistics> _generate(Function(int) func) => [
              Statistics('Mon', func(5)),
              Statistics('Tue', func(6)),
              Statistics('Wed', func(7)),
              Statistics('Thu', func(8)),
              Statistics('Fri', func(9)),
              Statistics('Sat', func(10)),
              Statistics('Sun', func(11)),
            ];

        return [
          charts.Series<Statistics, String>(
            id: 'pages',
            measureFn: (sales, _) => sales.value,
            data: _generate(countPages),
            colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
            domainFn: (sales, _) => sales.text,
          ),
          charts.Series<Statistics, String>(
            id: 'events',
            measureFn: (sales, _) => sales.value,
            data: _generate(countEvents),
            colorFn: (_, __) => charts.MaterialPalette.deepOrange.shadeDefault,
            domainFn: (sales, _) => sales.text,
          ),
          charts.Series<Statistics, String>(
            id: 'favourites',
            measureFn: (sales, _) => sales.value,
            data: _generate(countFavourites),
            colorFn: (_, __) => charts.MaterialPalette.pink.shadeDefault,
            domainFn: (sales, _) => sales.text,
          ),
        ];
      }

      return Container(
        height: 200,
        child: charts.BarChart(
          BlocProvider.of<StatisticsCubit>(context).state.selectedTimeline == 'Today'
              ? createTodayData()
              : createWeekData(),
          barGroupingType: charts.BarGroupingType.stacked,
        ),
      );
    }

    return Column(
      children: [
        _dropdown(),
        _grid(),
        _chart(),
      ],
    );
  }
}
