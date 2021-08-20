import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../ui/pages/stats/models/category_count.dart';
import '../utils/constants.dart';

class StatsPieChart extends StatefulWidget {
  final Iterable<CategoryCount> data;

  const StatsPieChart({Key? key, required this.data}) : super(key: key);

  @override
  _StatsPieChartState createState() => _StatsPieChartState();
}

class _StatsPieChartState extends State<StatsPieChart> {
  int touchedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final defaultRadius = MediaQuery.of(context).size.width / 4;
    return Stack(children: [
      PieChart(
        PieChartData(
          pieTouchData: PieTouchData(touchCallback: (pieTouchResponse) {
            setState(() {
              if (pieTouchResponse.touchedSection != null) {
                final index = pieTouchResponse.touchedSection!.touchedSectionIndex;
                touchedIndex = index == -1 ? 0 : index;
              } else {
                touchedIndex = 0;
              }
            });
          }),
          borderData: FlBorderData(show: false),
          sectionsSpace: 0,
          centerSpaceRadius: defaultRadius * 0.8,
          sections: _mapData(defaultRadius),
        ),
      ),
      Center(
        child: Wrap(
          children: [
            Column(
              children: [
                Text(
                  '${widget.data.elementAt(touchedIndex).count}',
                  style: Theme.of(context).textTheme.bodyText2?.copyWith(
                        fontSize: FontSize.large * 2,
                        fontWeight: FontWeight.w500,
                        color: widget.data.elementAt(touchedIndex).category.color,
                      ),
                ),
                Text(
                  'notes',
                  style: Theme.of(context).textTheme.bodyText2?.copyWith(
                        color: widget.data.elementAt(touchedIndex).category.color,
                      ),
                )
              ],
            ),
          ],
        ),
      )
    ]);
  }

  List<PieChartSectionData> _mapData(double defaultRadius) {
    return List.generate(
      widget.data.length,
      (index) {
        final category = widget.data.elementAt(index).category;
        final count = widget.data.elementAt(index).count;
        final isSelected = index == touchedIndex;
        return PieChartSectionData(
          color: isSelected ? category.color : category.color.withOpacity(0.9),
          value: count.toDouble(),
          radius: isSelected ? defaultRadius * 0.9 : defaultRadius * 0.8,
          showTitle: false,
          badgeWidget: Wrap(children: [
            Column(
              children: [
                SizedBox(
                  child: Image.asset('assets/${category.image}'),
                  height: defaultRadius / 2,
                ),
              ],
            ),
          ]),
          badgePositionPercentageOffset: 1,
        );
      },
    );
  }
}
