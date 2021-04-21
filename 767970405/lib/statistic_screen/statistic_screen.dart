import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:my_chat_journal/data/model/label_model.dart';
import 'package:my_chat_journal/data/model/model_message.dart';

import '../data/constants/constants.dart';
import '../data/extension.dart';
import 'statistic_cubit.dart';

class StatisticScreen extends StatelessWidget {
  static const routeName = '/StatisticScreen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Statistics'),
      ),
      body: ListView(
        children: <Widget>[
          _panelFilter(),
          BlocBuilder<StatisticCubit, StatisticState>(
            builder: (context, state) {
              switch (state.typeStatistic) {
                case TypeStatistic.labels:
                  return _labelsStatistic();
                case TypeStatistic.mood:
                  return _moodStatistic();
                case TypeStatistic.charts:
                  return _chartsStatistic();
                case TypeStatistic.times:
                  return _timesStatistic();
                case TypeStatistic.summary:
                  return _summaryStatistic(context);
                default:
                  return _summaryStatistic(context);
              }
            },
          ),
        ],
      ),
      bottomNavigationBar: _bottomNavigationBar,
    );
  }

  Widget get _bottomNavigationBar {
    return BlocBuilder<StatisticCubit, StatisticState>(
      builder: (context, state) {
        return BottomNavigationBar(
          currentIndex: state.typeStatistic.index,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              label: 'Labels',
              icon: Icon(
                Icons.bubble_chart,
              ),
            ),
            BottomNavigationBarItem(
              label: 'Mood',
              icon: Icon(
                Icons.mood,
              ),
            ),
            BottomNavigationBarItem(
              label: 'Charts',
              icon: Icon(
                Icons.stacked_line_chart,
              ),
            ),
            BottomNavigationBarItem(
              label: 'Times',
              icon: Icon(
                Icons.schedule,
              ),
            ),
            BottomNavigationBarItem(
              label: 'Summary',
              icon: Icon(
                Icons.insert_chart,
              ),
            ),
          ],
          onTap: context.read<StatisticCubit>().changeStatistic,
        );
      },
    );
  }

  Widget _panelFilter() {
    return Padding(
      padding: EdgeInsets.all(5.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Column(
              children: <Widget>[
                BlocBuilder<StatisticCubit, StatisticState>(
                  builder: (context, state) {
                    return ExpansionTile(
                      key: ValueKey(state.selectedTime),
                      title: Text(state.selectedTime.name),
                      children: <Widget>[
                        ListTile(
                          title: Text('Today'),
                          subtitle: Text(
                            DateFormat.yMMMd().format(
                              DateTime.now(),
                            ),
                          ),
                          onTap: () {
                            context
                                .read<StatisticCubit>()
                                .groupMessageByToday();
                            context.read<StatisticCubit>().changeTime(0);
                          },
                        ),
                        ListTile(
                          title: Text('Past 7 days'),
                          subtitle: Text(
                            '${DateFormat.yMMMd().format(DateTime.now().subtract(Duration(days: 7)))} -'
                            ' ${DateFormat.yMMMd().format(DateTime.now())}',
                          ),
                          onTap: () {
                            context
                                .read<StatisticCubit>()
                                .groupMessageByWeek();
                            context.read<StatisticCubit>().changeTime(1);
                          },
                        ),
                        ListTile(
                            title: Text('Past 30 days'),
                            subtitle: Text(
                              '${DateFormat.yMMMd().format(DateTime.now().subtract(Duration(days: 30)))} -'
                              ' ${DateFormat.yMMMd().format(DateTime.now())}',
                            ),
                            onTap: ()  {
                              context
                                  .read<StatisticCubit>()
                                  .groupMessageByMonth();
                              context.read<StatisticCubit>().changeTime(2);
                            }),
                        ListTile(
                            title: Text('This Year'),
                            subtitle: Text(
                              '${DateTime.now().year}',
                            ),
                            onTap: () async {
                              await context
                                  .read<StatisticCubit>()
                                  .groupMessageByYear();
                              context.read<StatisticCubit>().changeTime(3);
                            }),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
          Icon(
            Icons.filter_list,
            size: 30,
          ),
        ],
      ),
    );
  }

  Widget _labelsStatistic() {
    return Container();
  }

  Widget _moodStatistic() {
    return Container();
  }

  Widget _chartsStatistic() {
    return Container();
  }

  Widget _timesStatistic() {
    return Container();
  }

  Widget _summaryStatistic(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Panel(
              color: Colors.blue,
              filter: (element) => true,
              label: 'Total',
            ),
            Panel(
              color: Colors.green,
              filter: (element) => element.isFavor,
              label: 'Bookmark',
            ),
          ],
        ),
        Row(
          children: <Widget>[
            Panel(
              color: Colors.red,
              filter: (element) => element.indexCategory != -1,
              label: 'Label',
            ),
            Panel(
              color: Colors.yellow,
              filter: (element) => false,
              label: 'Mood',
            ),
            Panel(
              color: Colors.orange,
              filter: (element) => false,
              label: 'Todo',
            ),
          ],
        ),
        BlocBuilder<StatisticCubit, StatisticState>(
          builder: (context, state) {
            return Container(
              margin: EdgeInsets.all(5.0),
              constraints: BoxConstraints(
                maxHeight: size.height * (4 / 10),
                maxWidth: size.width * (9 / 10),
              ),
              child: charts.BarChart(
                [
                  charts.Series<OrdinalSales, String>(
                    id: 'Bookmark',
                    colorFn: (sales, _) => sales.color,
                    domainFn: (sales, _) => sales.date,
                    measureFn: (sales, _) => sales.count,
                    data: context.read<StatisticCubit>().filterMsg(
                          (element) => element.isFavor,
                          charts.Color.fromHex(code: 'FFFFEB3B'),
                        ),
                  ),
                  charts.Series<OrdinalSales, String>(
                    id: 'Labels',
                    colorFn: (sales, _) => sales.color,
                    domainFn: (sales, _) => sales.date,
                    measureFn: (sales, _) => sales.count,
                    data: context.read<StatisticCubit>().filterMsg(
                          (element) => element.indexCategory != -1,
                          charts.Color.fromHex(code: 'FFF44336'),
                        ),
                  ),
                  charts.Series<OrdinalSales, String>(
                    id: 'Total',
                    domainFn: (sales, _) => sales.date,
                    measureFn: (sales, _) => sales.count,
                    data: context.read<StatisticCubit>().filterMsg(
                          (element) => true,
                          charts.Color.fromHex(code: 'FF2196F3'),
                        ),
                  ),
                ],
                animate: true,
                barGroupingType: charts.BarGroupingType.stacked,
              ),
            );
          },
        ),
      ],
    );
  }
}

class Panel extends StatelessWidget {
  final Color color;
  final bool Function(ModelMessage) filter;
  final String label;

  const Panel({
    Key key,
    this.color,
    this.filter,
    this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.all(5.0),
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * (10 / 100),
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          color: color,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              BlocBuilder<StatisticCubit, StatisticState>(
                builder: (context, state) => Text(
                    '${context.read<StatisticCubit>().countFilterMsg(filter)}'),
              ),
              Text(label),
            ],
          ),
        ),
      ),
    );
  }
}
