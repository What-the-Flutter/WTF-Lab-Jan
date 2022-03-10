import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toggle_switch/toggle_switch.dart';

import '../../main.dart';
import 'statistics_cubit.dart';
import 'statistics_state.dart';

class StatisticsPage extends StatefulWidget {
  StatisticsPage({Key? key}) : super(key: key);

  static const routeName = '/pageStatistics';
  final statisticsCubit = StatisticsCubit();
  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  @override
  void initState() {
    super.initState();
    widget.statisticsCubit.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StatisticsCubit, StatisticsState>(
      bloc: widget.statisticsCubit,
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Center(child: Text('Statistics')),
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 1,
                child: staticticTile(
                  color: Colors.blue[200] as Color,
                  width: 230.0,
                  staticticTileCount: state.totalNotesCount,
                  staticticTileText: 'Total count',
                ),
              ),
              Expanded(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    staticticTile(
                      color: Colors.yellow[300] as Color,
                      width: 105.0,
                      staticticTileCount: state.totalPagesCount,
                      staticticTileText: 'Labels',
                    ),
                    staticticTile(
                      color: Colors.green[300] as Color,
                      width: 105.0,
                      staticticTileCount: state.totalBookmarksCount,
                      staticticTileText: 'Bookmarks',
                    ),
                  ],
                ),
              ),
              ToggleSwitch(
                initialLabelIndex: state.period.index,
                totalSwitches: 3,
                labels: ['day', 'week', 'month'],
                animate: true,
                animationDuration: 150,
                onToggle: widget.statisticsCubit.changePeriod,
              ),
              const Expanded(
                flex: 1,
                child: SizedBox(),
              ),
              Expanded(
                flex: 5,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 0.0, horizontal: 20.0),
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 100.0,
                      childAspectRatio: 1.0,
                      crossAxisSpacing: 20.0,
                      mainAxisSpacing: 20.0,
                    ),
                    itemCount: state.filteredPagesList.length,
                    itemBuilder: (context, index) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.grey[300],
                                radius: 35.0,
                                child: Icon(
                                  pageIcons[
                                      state.filteredPagesList[index].icon],
                                ),
                              ),
                              Text(
                                '${state.filteredPagesList[index].numOfNotes}',
                                style: const TextStyle(fontSize: 30.0),
                              ),
                            ],
                          ),
                          Text(state.filteredPagesList[index].title),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

Widget staticticTile({
  required Color color,
  required double width,
  required int staticticTileCount,
  required String staticticTileText,
}) {
  return Container(
    margin: const EdgeInsets.all(10.0),
    width: width,
    color: color,
    child: Column(
      children: [
        Text(
          '$staticticTileCount',
          style: const TextStyle(fontSize: 40.0),
        ),
        Text('$staticticTileText'),
      ],
    ),
  );
}
