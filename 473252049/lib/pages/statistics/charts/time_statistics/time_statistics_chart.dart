import 'package:charts_flutter/flutter.dart';
import 'package:flutter/material.dart';

import 'time_statistics_data.dart';

class TimeStatisticsChart extends StatelessWidget {
  final List<TimeStatisticsData> dataList;

  const TimeStatisticsChart({Key key, this.dataList}) : super(key: key);

  List<Series<TimeStatisticsData, DateTime>> _getSeriesData() {
    return [
      Series(
        id: 'Time Statistics',
        data: dataList,
        domainFn: (data, _) => data.dateTime,
        measureFn: (data, _) => data.recordsCount,
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TimeSeriesChart(
        _getSeriesData(),
        animate: true,
        defaultRenderer: BarRendererConfig<DateTime>(),
        behaviors: [
          SelectNearest(),
          DomainHighlighter(),
        ],
      ),
    );
  }
}
