import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:task_wtf/pages/statistic_page/statistic_page_state.dart';
import 'statistic_page_cubit.dart';

class TestingStatisticPage extends StatefulWidget {
  @override
  _StatisticPageState createState() => _StatisticPageState();
}

class _StatisticPageState extends State<TestingStatisticPage> {
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
      leading: BackButton(
        color: Colors.black,
      ),
    );
  }

  Widget _defaultBody() {
    return Column(
      children: [
        SizedBox(
          height: 50,
        ),
        const Center(
          child: Text(
            'statistic',
            style: TextStyle(
              fontSize: 30,
            ),
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
          'Statistics',
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
          ),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
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
      padding: const EdgeInsets.all(30),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(
          20.0,
        ),
        child: Container(
          height: 120,
          color: Colors.yellow,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(
                top: 35.0,
              ),
              child: Column(
                children: [
                  Text(
                    '${state.countOfMessagesInThePeriod ?? '-'}',
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  const Text(
                    'Messages',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Padding _bookmarkedMessageStatistic(StatisticPageState state) {
    return Padding(
      padding: const EdgeInsets.all(30),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(
          20.0,
        ),
        child: Container(
          height: 120,
          width: MediaQuery.of(context).size.width,
          color: Colors.orangeAccent,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(
                top: 35.0,
              ),
              child: Column(
                children: [
                  Text(
                    '${state.countOfBookmarkedMessagesInThePeriod ?? '-'}',
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  const Text(
                    'Bookmarked messages',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
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
      ],
    );
  }

  Widget _statBottomNavigationBar() {
    return BottomNavigationBar(
      backgroundColor: Colors.grey[400],
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
}
