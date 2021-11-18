import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../theme/themes.dart';
import '../charts_statistics/charts_statistics_screen.dart';
import '../labels_statistics/labels_statistics_screen.dart';
import '../summary_statistics/summary_statistics_screen.dart';
import 'statistics_cubit.dart';
import 'statistics_state.dart';

class StatisticsPage extends StatefulWidget {
  @override
  _StatisticsPageState createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  final _controller = TextEditingController();

  @override
  void initState() {
    BlocProvider.of<StatisticsPageCubit>(context).gradientAnimation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final first = Theme.of(context).colorScheme.secondary;
    final second = Theme.of(context).colorScheme.onSecondary;
    final third = Theme.of(context).colorScheme.secondaryVariant;
    return BlocBuilder<StatisticsPageCubit, StatisticsPageState>(
      builder: (blocContext, state) {
        return AnimatedContainer(
          duration: const Duration(seconds: 1),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                first,
                state.isColorChanged ? second : first,
                state.isColorChanged ? third : first,
              ],
            ),
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: _appBar(),
            body: state.statisticsType,
            bottomNavigationBar: _bottomNavigationBar(),
          ),
        );
      },
    );
  }

  PreferredSizeWidget _appBar() {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.primary,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(radiusValue),
        ),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_rounded),
        onPressed: () => Navigator.pop(context),
      ),
      title: const Text('Filters'),
    );
  }

  Widget _bottomNavigationBar() {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(
        top: Radius.circular(radiusValue),
      ),
      child: BottomNavigationBar(
        onTap: _onItemTapped,
        unselectedItemColor: Theme.of(context).colorScheme.onBackground,
        selectedItemColor: Theme.of(context).colorScheme.onBackground,
        iconSize: 27,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.offline_bolt_rounded),
            label: 'Label',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.auto_graph_rounded),
            label: 'Daily',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_tree_rounded),
            label: 'Charts',
          ),
        ],
      ),
    );
  }

  void _onItemTapped(int index) {
    final statisticsTypes = <Widget>[
      LabelsStatisticsPage(),
      SummaryStatisticsPage(),
      ChartsStatisticsPage(),
    ];
    BlocProvider.of<StatisticsPageCubit>(context)
        .changeStatisticsType(statisticsTypes[index]);
  }
}
