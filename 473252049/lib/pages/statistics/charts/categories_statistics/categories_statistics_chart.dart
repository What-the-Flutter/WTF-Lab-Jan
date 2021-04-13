import 'package:charts_flutter/flutter.dart';
import 'package:flutter/material.dart';

import 'categories_statistics_data.dart';

class CategoriesStatisticsChart extends StatelessWidget {
  final List<CategoriesStatisticsData> dataList;

  const CategoriesStatisticsChart({Key key, this.dataList}) : super(key: key);

  List<Series> _getSeriesData() {
    return [
      Series(
        id: 'Categories',
        data: dataList,
        domainFn: (data, _) => data.categoryName,
        measureFn: (data, _) => data.recordsCount,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: PieChart(
        _getSeriesData(),
        animate: false,
        defaultRenderer: ArcRendererConfig(
          arcWidth: 100,
          arcRendererDecorators: [
            ArcLabelDecorator(),
          ],
        ),
        behaviors: [
          DatumLegend(
            position: BehaviorPosition.bottom,
            showMeasures: true,
            horizontalFirst: false,
            legendDefaultMeasure: LegendDefaultMeasure.firstValue,
            measureFormatter: (value) {
              return '$value record${value > 1 ? "s" : ""}';
            },
          ),
        ],
      ),
    );
  }
}
