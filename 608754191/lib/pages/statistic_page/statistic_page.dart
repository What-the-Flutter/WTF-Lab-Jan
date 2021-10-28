import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:task_wtf/pages/statistic_page/statistic_page_state.dart';

import '../../entity/statistic.dart';
import '../settings/settings_page/settings_cubit.dart';
import 'statistic_page_cubit.dart';

class StatisticPage extends StatefulWidget {
  @override
  _StatisticPageState createState() => _StatisticPageState();
}

class _StatisticPageState extends State<StatisticPage> {
  int _selectedIndex = 0;

  @override
  void initState() {
    BlocProvider.of<StatisticPageCubit>(context).init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StatisticPageCubit, StatisticPageState>(
      builder: (context, statisticState) {
        return Scaffold(
          appBar: _selectedIndex == 0 ? _defaultAppBar() : _statisticsAppBar(statisticState),
          body: _selectedIndex == 0 ? _defaultBody() : _statisticsBody(statisticState),
          bottomNavigationBar: _statBottomNavigationBar(),
          backgroundColor: Theme.of(context).backgroundColor,
        );
      },
    );
  }

  AppBar _defaultAppBar() {
    return AppBar(
      backgroundColor: Colors.yellow,
      title: const Center(
        child: Text(
          'Statistics',
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
          ),
        ),
      ),
      leading: const BackButton(
        color: Colors.black,
      ),
      actions: [
        IconButton(
          onPressed: () => context.read<SettingsCubit>().changeTheme(),
          icon: const Icon(
            Icons.invert_colors,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  Widget _defaultBody() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(
            right: 220,
            top: 20,
          ),
          child: TextButton(
            child: const Text(
              'click from info',
              style: TextStyle(
                fontSize: 20,
                color: Colors.black,
              ),
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (blocContext) => _alertDialog(),
              );
            },
          ),
        ),
        Center(
          child: Lottie.network(
            'https://assets1.lottiefiles.com/private_files/lf30_lZDkKW.json',
          ),
        ),
      ],
    );
  }

  AppBar _statisticsAppBar(StatisticPageState state) {
    return AppBar(
      backgroundColor: Colors.yellow,
      title: const Center(
        child: Text(
          'Message statistics',
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
          ),
        ),
      ),
      leading: const BackButton(
        color: Colors.black,
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: DropdownButton<String>(
            style: const TextStyle(
              color: Colors.black,
            ),
            hint: const Text(
              'Select period',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            value: state.selectedPeriod,
            icon: const Icon(
              Icons.timeline,
              size: 25,
              color: Colors.black,
            ),
            underline: Container(
              height: 2,
            ),
            onChanged: (value) =>
                BlocProvider.of<StatisticPageCubit>(context).setSelectedPeriod(value!),
            items: <String>['last week', 'last month', 'last year'].map<DropdownMenuItem<String>>(
              (value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                  ),
                );
              },
            ).toList(),
          ),
        ),
      ],
    );
  }

  Widget _messageStatistic(StatisticPageState state) {
    return Padding(
      padding: const EdgeInsets.all(50),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(
          55.0,
        ),
        child: Container(
          height: 80,
          color: Colors.yellow,
          child: Center(
            child: Column(
              children: [
                const SizedBox(
                  height: 15,
                ),
                Text(
                  '${state.countOfMessagesInThePeriod ?? '-'}',
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 28,
                  ),
                ),
                const Text(
                  'Total',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _bookmarkedMessageStatistic(StatisticPageState state) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 50,
        right: 50,
        bottom: 20,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(
          55.0,
        ),
        child: Container(
          height: 80,
          width: MediaQuery.of(context).size.width,
          color: Colors.yellow,
          child: Column(
            children: [
              const SizedBox(
                height: 15,
              ),
              Center(
                child: Text(
                  '${state.countOfBookmarkedMessagesInThePeriod ?? '-'}',
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 28,
                  ),
                ),
              ),
              const Text(
                'Bookmarks',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Column _statisticsBody(StatisticPageState state) {
    return Column(
      children: <Widget>[
        _messageStatistic(state),
        _bookmarkedMessageStatistic(state),
        Expanded(
          child: charts.BarChart(
            BlocProvider.of<StatisticPageCubit>(context).state.selectedPeriod == 'last week'
                ? createWeekStatistics()
                : BlocProvider.of<StatisticPageCubit>(context).state.selectedPeriod == 'last month'
                    ? createMonthStatistics()
                    : createYearStatistics(),
            barGroupingType: charts.BarGroupingType.stacked,
            animate: true,
            domainAxis: const charts.OrdinalAxisSpec(
              renderSpec: charts.SmallTickRendererSpec(
                labelRotation: 60,
              ),
            ),
          ),
        ),
      ],
    );
  }

  List<charts.Series<Statistics, String>> _chartsSeries(
    Function(int) countMessages,
    int value,
    int limit,
    int period,
  ) {
    return [
      charts.Series<Statistics, String>(
        id: 'listMessages',
        measureFn: (sales, _) => sales.value,
        data: _generateList(countMessages, value, <Statistics>[], limit, period),
        colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
        domainFn: (sales, _) => sales.text,
      ),
    ];
  }

  List<charts.Series<Statistics, String>> createYearStatistics() {
    int _countYearEvents(int monthDifference) {
      return BlocProvider.of<StatisticPageCubit>(context)
          .state
          .listMessages!
          .where(
            (element) =>
                DateFormat().add_yMd().add_jm().parse(element.time).isAfter(
                      DateTime(
                        DateTime.now().year,
                        DateTime.now().month - monthDifference,
                      ),
                    ) &&
                DateFormat().add_yMd().add_jm().parse(element.time).isBefore(
                      DateTime(
                        DateTime.now().year,
                        DateTime.now().month - monthDifference + 1,
                      ),
                    ),
          )
          .length;
    }

    return _chartsSeries(_countYearEvents, 10, -1, 1);
  }

  List<charts.Series<Statistics, String>> createMonthStatistics() {
    int _countMonthEvents(int dayDifference) {
      return BlocProvider.of<StatisticPageCubit>(context)
          .state
          .listMessages!
          .where(
            (element) =>
                DateFormat().add_yMd().add_jm().parse(element.time).isAfter(
                      DateTime(
                        DateTime.now().year,
                        DateTime.now().month,
                        DateTime.now().day - dayDifference,
                      ),
                    ) &&
                DateFormat().add_yMd().add_jm().parse(element.time).isBefore(
                      DateTime(
                        DateTime.now().year,
                        DateTime.now().month,
                        DateTime.now().day - dayDifference + 2,
                      ),
                    ),
          )
          .length;
    }

    return _chartsSeries(_countMonthEvents, 29, 0, 30);
  }

  List<charts.Series<Statistics, String>> createWeekStatistics() {
    int _countWeekEvents(int dayDifference) {
      return BlocProvider.of<StatisticPageCubit>(context)
          .state
          .listMessages!
          .where(
            (element) =>
                DateFormat().add_yMd().add_jm().parse(element.time).isAfter(
                      DateTime(
                        DateTime.now().year,
                        DateTime.now().month,
                        DateTime.now().day - dayDifference,
                      ),
                    ) &&
                DateFormat().add_yMd().add_jm().parse(element.time).isBefore(
                      DateTime(
                        DateTime.now().year,
                        DateTime.now().month,
                        DateTime.now().day - dayDifference + 2,
                      ),
                    ),
          )
          .length;
    }

    return _chartsSeries(_countWeekEvents, 7, 0, 7);
  }

  List<Statistics> _generateList(
    Function(int) function,
    int difference,
    List<Statistics> list,
    int limit,
    int period,
  ) {
    switch (period) {
      case 30:
        list.add(
          Statistics(
            '${DateFormat.d().format(
              DateTime(
                DateTime.now().year,
                DateTime.now().month,
                DateTime.now().day - difference,
              ),
            )}',
            function(
              difference + 1,
            ),
          ),
        );
        break;
      case 7:
        list.add(
          Statistics(
            '${DateFormat.MMMd().format(
              DateTime(
                DateTime.now().year,
                DateTime.now().month,
                DateTime.now().day - difference,
              ),
            )}',
            function(
              difference + 1,
            ),
          ),
        );
        break;
      case 1:
        list.add(
          Statistics(
            '${DateFormat.MMM().format(
              DateTime(
                DateTime.now().year,
                DateTime.now().month - 1 - difference,
                DateTime.now().day,
              ),
            )}',
            function(
              difference + 1,
            ),
          ),
        );
        break;
    }

    if (difference != limit) {
      return _generateList(
        function,
        difference - 1,
        list,
        limit,
        period,
      );
    }
    return list;
  }

  Widget _statBottomNavigationBar() {
    return BottomNavigationBar(
      backgroundColor: Colors.yellow,
      items: [
        const BottomNavigationBarItem(
          icon: Icon(
            Icons.home_outlined,
          ),
          label: 'Statistic Page',
          backgroundColor: Colors.black,
        ),
        const BottomNavigationBarItem(
          icon: Icon(
            Icons.article_outlined,
          ),
          label: 'Message Statistic',
          backgroundColor: Colors.black,
        ),
      ],
      showUnselectedLabels: true,
      onTap: _onItemTapped,
      selectedItemColor: Colors.black,
      currentIndex: _selectedIndex,
    );
  }

  void _onItemTapped(int index) => setState(
        () => _selectedIndex = index,
      );

  AlertDialog _alertDialog() {
    return AlertDialog(
      backgroundColor: Colors.yellow,
      title: Column(
        children: [
          const Text(
            'This is statistic of application',
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          const Text(
            'you may see  all statistic here',
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          const Text(
            'at the moment, only the statistics of messages is available, '
            'including their total number and the number of bookmarked messages',
            style: TextStyle(
              fontSize: 12,
            ),
          ),
        ],
      ),
      elevation: 6,
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.pop(
              context,
              'Ok',
            );
          },
          child: const Text(
            'Ok',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}
