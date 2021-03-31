import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

class TimeSeriesChart extends StatelessWidget {
  final List<charts.Series> eventMessagesList;
  final bool isAnimate;

  TimeSeriesChart({@required this.eventMessagesList, this.isAnimate});

  @override
  Widget build(BuildContext context) {
    return charts.TimeSeriesChart(
      eventMessagesList,
      animate: isAnimate,
      dateTimeFactory: const charts.LocalDateTimeFactory(),
    );
  }
}
