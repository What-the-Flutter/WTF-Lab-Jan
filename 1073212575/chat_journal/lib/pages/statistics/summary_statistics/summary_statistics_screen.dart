import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../models/char_data.dart';
import '../../../models/filter_parameters.dart';
import '../../../theme/themes.dart';
import '../statistics_filters/statistics_filters_screen.dart';
import 'summary_statistics_cubit.dart';
import 'summary_statistics_state.dart';

class SummaryStatisticsPage extends StatefulWidget {
  @override
  _SummaryStatisticsPageState createState() => _SummaryStatisticsPageState();
}

class _SummaryStatisticsPageState extends State<SummaryStatisticsPage> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<SummaryStatisticsPageCubit>(context).init();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SummaryStatisticsPageCubit, SummaryStatisticsPageState>(
      builder: (blocContext, state) {
        return Column(
          children: [
            Row(
              children: [
                _timePeriods(state),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: _filtersButton(),
                  ),
                ),
              ],
            ),
            _graphicDescription(),
            _graphic2(state),
          ],
        );
      },
    );
  }

  Widget _timePeriods(SummaryStatisticsPageState state) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 50),
      child: DropdownButton<String>(
        value: state.selectedPeriod,
        icon: Icon(
          Icons.arrow_downward,
          color: Theme.of(context).colorScheme.background,
        ),
        iconSize: 24,
        elevation: 16,
        style: TextStyle(
          color: Theme.of(context).colorScheme.background,
        ),
        underline: Container(
          height: 2,
          color: Theme.of(context).colorScheme.surface,
        ),
        onChanged: (newValue) {
          BlocProvider.of<SummaryStatisticsPageCubit>(context)
              .onPeriodSelected(newValue!);
        },
        items: <String>[
          'Today',
          'Past 7 days',
          'Past 30 days',
          'This year',
        ].map<DropdownMenuItem<String>>((value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }

  Widget _filtersButton() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 40),
      child: IconButton(
        icon: Icon(
          Icons.filter_list_rounded,
          color: Theme.of(context).colorScheme.primary,
        ),
        onPressed: () async {
          FilterParameters parameters = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => StatisticsFiltersPage(),
            ),
          );
          BlocProvider.of<SummaryStatisticsPageCubit>(context)
              .setFilterParameters(parameters);
        },
      ),
    );
  }

  Widget _graphicDescription() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 20,
                height: 20,
                color: graphicColors[0],
              ),
              Text(
                ' - total',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.background,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Container(
                width: 20,
                height: 20,
                color: graphicColors[1],
              ),
              Text(
                ' - bookmarks',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.background,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Container(
                width: 20,
                height: 20,
                color: graphicColors[2],
              ),
              Text(
                ' - labels',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.background,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _graphic2(SummaryStatisticsPageState state) {
    return SfCartesianChart(
      primaryXAxis: CategoryAxis(),
      series: <ChartSeries>[
        StackedColumnSeries<ColumnChartData, String>(
          dataSource: state.summaryData,
          xValueMapper: (sales, _) => sales.x,
          yValueMapper: (sales, _) => sales.y1,
          color: graphicColors[0],
        ),
        StackedColumnSeries<ColumnChartData, String>(
          dataSource: state.summaryData,
          xValueMapper: (sales, _) => sales.x,
          yValueMapper: (sales, _) => sales.y2,
          color: graphicColors[1],
        ),
        StackedColumnSeries<ColumnChartData, String>(
          dataSource: state.summaryData,
          xValueMapper: (sales, _) => sales.x,
          yValueMapper: (sales, _) => sales.y3,
          color: graphicColors[2],
        ),
      ],
    );
  }
}
