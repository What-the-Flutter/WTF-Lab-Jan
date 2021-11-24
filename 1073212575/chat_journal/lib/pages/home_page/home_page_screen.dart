import 'dart:async';

import 'package:animations/animations.dart';
import 'package:chat_journal/pages/statistics/add_label/add_label_cubit.dart';
import 'package:chat_journal/pages/statistics/charts_statistics/charts_statistics_cubit.dart';
import 'package:chat_journal/pages/statistics/labels_statistics/labels_statistics_cubit.dart';
import 'package:chat_journal/pages/statistics/statistics_filters/statistics_filters_cubit.dart';
import 'package:chat_journal/pages/statistics/statistics_main/statistics_cubit.dart';
import 'package:chat_journal/pages/statistics/statistics_main/statistics_screen.dart';
import 'package:chat_journal/pages/statistics/summary_statistics/summary_statistics_cubit.dart';
import 'package:chat_journal/repository/labels_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:jiffy/jiffy.dart';
import 'package:rive_splash_screen/rive_splash_screen.dart';

import 'package:chat_journal/database.dart';
import 'package:chat_journal/repository/messages_repository.dart';
import 'package:chat_journal/repository/pages_repository.dart';
import 'package:chat_journal/repository/settings_repository.dart';
import 'package:chat_journal/shared_preferences.dart';
import 'package:chat_journal/theme/themes.dart';
import 'package:chat_journal/pages/Timeline/timeline_cubit.dart';
import '../Timeline/timeline_screen.dart';
import '../add_page/add_page_cubit.dart';
import '../add_page/add_page_screen.dart';
import '../background_image/background_image_cubit.dart';
import '../event_page/event_page_cubit.dart';
import '../event_page/event_page_screen.dart';
import '../filters/filters_cubit.dart';
import '../settings/settings_cubit.dart';
import '../settings/settings_screen.dart';
import '../settings/settings_state.dart';
import 'home_page_cubit.dart';
import 'home_page_state.dart';

Widget startApp() {
  final db = DBProvider();
  final prefs = SharedPreferencesProvider();
  return MultiRepositoryProvider(
    providers: [
      RepositoryProvider<PagesRepository>(
        create: (context) => PagesRepository(db),
      ),
      RepositoryProvider<MessagesRepository>(
        create: (context) => MessagesRepository(db),
      ),
      RepositoryProvider<SettingsRepository>(
        create: (context) => SettingsRepository(prefs),
      ),
      RepositoryProvider<LabelsRepository>(
        create: (context) => LabelsRepository(db),
      ),
    ],
    child: MultiBlocProvider(
      providers: [
        BlocProvider<SettingsCubit>(
          create: (context) => SettingsCubit(
            RepositoryProvider.of<SettingsRepository>(context),
          ),
        ),
        BlocProvider<BackgroundImageCubit>(
          create: (context) => BackgroundImageCubit(),
        ),
        BlocProvider<HomePageCubit>(
          create: (context) => HomePageCubit(
            RepositoryProvider.of<PagesRepository>(context),
          ),
        ),
        BlocProvider<EventPageCubit>(
          create: (context) => EventPageCubit(
            RepositoryProvider.of<MessagesRepository>(context),
            RepositoryProvider.of<PagesRepository>(context),
            RepositoryProvider.of<LabelsRepository>(context),
          ),
        ),
        BlocProvider<AddPageCubit>(
          create: (context) => AddPageCubit(
            RepositoryProvider.of<PagesRepository>(context),
          ),
        ),
        BlocProvider<TimelinePageCubit>(
          create: (context) => TimelinePageCubit(
            RepositoryProvider.of<MessagesRepository>(context),
            RepositoryProvider.of<PagesRepository>(context),
          ),
        ),
        BlocProvider<FiltersPageCubit>(
          create: (context) => FiltersPageCubit(
            RepositoryProvider.of<PagesRepository>(context),
            RepositoryProvider.of<MessagesRepository>(context),
          ),
        ),
        BlocProvider<StatisticsPageCubit>(
          create: (context) => StatisticsPageCubit(),
        ),
        BlocProvider<StatisticsFiltersPageCubit>(
          create: (context) => StatisticsFiltersPageCubit(
            RepositoryProvider.of<PagesRepository>(context),
          ),
        ),
        BlocProvider<LabelsStatisticsPageCubit>(
          create: (context) => LabelsStatisticsPageCubit(
            RepositoryProvider.of<LabelsRepository>(context),
            RepositoryProvider.of<MessagesRepository>(context),
          ),
        ),
        BlocProvider<ChartsStatisticsPageCubit>(
          create: (context) => ChartsStatisticsPageCubit(
            RepositoryProvider.of<LabelsRepository>(context),
            RepositoryProvider.of<MessagesRepository>(context),
          ),
        ),
        BlocProvider<SummaryStatisticsPageCubit>(
          create: (context) => SummaryStatisticsPageCubit(
            RepositoryProvider.of<LabelsRepository>(context),
            RepositoryProvider.of<MessagesRepository>(context),
          ),
        ),
        BlocProvider<AddLabelPageCubit>(
          create: (context) => AddLabelPageCubit(
            RepositoryProvider.of<PagesRepository>(context),
            RepositoryProvider.of<LabelsRepository>(context),
          ),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    BlocProvider.of<SettingsCubit>(context).setSettings();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, settingsState) {
        return MaterialApp(
          theme: settingsState.theme.copyWith(
            textTheme: TextTheme(
              bodyText2: TextStyle(
                fontSize: settingsState.fontSize.toDouble(),
              ),
            ),
          ),
          title: 'Flutter Demo',
          home: SplashScreen.navigate(
            name: 'splash_screen.riv',
            next: (context) => HomePage(),
            fit: BoxFit.fill,
            until: () => Future.delayed(const Duration(seconds: 0)),
            startAnimation: 'Animation 1',
          ),
        );
      },
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return HomePage();
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    authentication();
    BlocProvider.of<HomePageCubit>(context).gradientAnimation();
    BlocProvider.of<HomePageCubit>(context).showPages();
  }

  Future<void> authentication() async {
    if (await BlocProvider.of<SettingsCubit>(context).useBiometrics()) {
      BlocProvider.of<HomePageCubit>(context).authentication();
    }
  }

  @override
  Widget build(BuildContext context) {
    final first = Theme.of(context).colorScheme.secondary;
    final second = Theme.of(context).colorScheme.onSecondary;
    final third = Theme.of(context).colorScheme.secondaryVariant;
    return BlocBuilder<HomePageCubit, HomePageState>(
      builder: (context, state) {
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
            appBar: state.isSelected ? _editingAppBar(state) : _defaultAppBar(),
            floatingActionButton: _floatingActionButton(),
            body: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  SizedBox(
                    width: double.infinity,
                    child: _elevatedButton(),
                  ),
                  Expanded(
                    child: _eventsList(state),
                  ),
                ],
              ),
            ),
            bottomNavigationBar: _bottomNavigationBar(),
          ),
        );
      },
    );
  }

  Widget _floatingActionButton() {
    return OpenContainer(
      onClosed: BlocProvider.of<HomePageCubit>(context).onGoBack,
      transitionDuration: const Duration(seconds: 1),
      openBuilder: (context, _) => const AddPage(
        needsEditing: false,
        selectedPageIndex: -1,
      ),
      closedShape: const CircleBorder(),
      closedColor: Theme.of(context).colorScheme.primary,
      closedBuilder: (context, openContainer) => Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Theme.of(context).colorScheme.primary,
        ),
        width: 50,
        height: 50,
        child: Icon(
          Icons.add,
          color: Theme.of(context).colorScheme.secondaryVariant,
        ),
      ),
    );
  }

  Widget _elevatedButton() {
    return ElevatedButton(
      onPressed: () {},
      child: Text(
        'Questionnaire Bot',
        style: TextStyle(color: Theme.of(context).colorScheme.background),
      ),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(
            Theme.of(context).colorScheme.surface),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(radiusValue),
            ),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _defaultAppBar() {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.primary,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(radiusValue),
        ),
      ),
      leading: IconButton(
        onPressed: () => Navigator.push(
          context,
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 1000),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) =>
                    SharedAxisTransition(
              animation: animation,
              secondaryAnimation: secondaryAnimation,
              transitionType: SharedAxisTransitionType.horizontal,
              child: child,
            ),
            pageBuilder: (context, animation, secondaryAnimation) =>
                SettingsPage(),
          ),
        ),
        icon: const Icon(
          Icons.settings,
        ),
      ),
      title: const Text('Home'),
    );
  }

  PreferredSizeWidget _editingAppBar(state) {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.primary,
      shape: const RoundedRectangleBorder(
        borderRadius:
            BorderRadius.vertical(bottom: Radius.circular(radiusValue)),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_rounded),
        onPressed: BlocProvider.of<HomePageCubit>(context).unselect,
      ),
      title: const Text(''),
      actions: [
        IconButton(
          icon: const Icon(Icons.delete_rounded),
          onPressed: BlocProvider.of<HomePageCubit>(context).delete,
        ),
        IconButton(
          icon: const Icon(Icons.book_rounded),
          onPressed: () => BlocProvider.of<HomePageCubit>(context).fix(),
        ),
        IconButton(
            icon: const Icon(Icons.edit_rounded),
            onPressed: () {
              BlocProvider.of<HomePageCubit>(context).edit();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddPage(
                    needsEditing: true,
                    selectedPageIndex: state.selectedPageIndex,
                  ),
                ),
              );
            }),
        IconButton(
          icon: const Icon(Icons.info_rounded),
          onPressed: () => simpleDialog(context, state),
        ),
      ],
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
        selectedItemColor: Theme.of(context).colorScheme.background,
        iconSize: 27,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.auto_graph_rounded),
            label: 'Daily',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment_turned_in_rounded),
            label: 'Timeline',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore_rounded),
            label: 'Explore',
          ),
        ],
      ),
    );
  }

  void _onItemTapped(int index) {
    final pages = [
      HomePage(),
      StatisticsPage(),
      TimelinePage(),
      HomePage(),
    ];
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 700),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            SharedAxisTransition(
          animation: animation,
          secondaryAnimation: secondaryAnimation,
          transitionType: SharedAxisTransitionType.horizontal,
          child: child,
        ),
        pageBuilder: (context, animation, secondaryAnimation) => pages[index],
      ),
    );
  }

  Widget _eventsList(state) {
    return AnimationLimiter(
      child: ListView.builder(
        itemCount: state.eventPages.length,
        itemBuilder: (context, i) => AnimationConfiguration.staggeredList(
          position: i,
          duration: const Duration(milliseconds: 500),
          child: SlideAnimation(
            verticalOffset: 20.0,
            child: FadeInAnimation(
              child: _event(i, state),
            ),
          ),
        ),
      ),
    );
  }

  Widget _event(int i, state) {
    return GestureDetector(
      onLongPress: () => BlocProvider.of<HomePageCubit>(context).select(i),
      child: Container(
        margin: const EdgeInsets.only(top: 5),
        height: 70,
        child: ElevatedButton(
          style: ButtonStyle(
            shadowColor: MaterialStateProperty.all<Color>(Colors.transparent),
            backgroundColor: MaterialStateProperty.all<Color>(
                i == state.selectedPageIndex && state.isSelected
                    ? Theme.of(context).colorScheme.surface
                    : Theme.of(context).colorScheme.onPrimary),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(radiusValue),
                ),
              ),
            ),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EventPage(
                  eventPage: state.eventPages[i],
                ),
              ),
            );
          },
          child: _eventContent(i, state),
        ),
      ),
    );
  }

  Widget _eventContent(int i, state) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Icon(
            state.eventPages[i].icon,
            color: Theme.of(context).colorScheme.primaryVariant,
            size: 40,
          ),
        ),
        Text(
          state.eventPages[i].name,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.background,
            fontSize: 15,
          ),
        ),
        Expanded(
          child: Align(
            alignment: Alignment.centerRight,
            child: Icon(
              Icons.book_rounded,
              // color: Theme.of(context).buttonColor,
              color: state.eventPages[i].isFixed
                  ? Theme.of(context).colorScheme.primaryVariant
                  : Colors.transparent,
              size: 20,
            ),
          ),
        ),
      ],
    );
  }

  Future simpleDialog(BuildContext context, dynamic state) {
    return showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: Container(
            height: 300,
            child: AlertDialog(
              title: Row(
                children: [
                  Icon(state.eventPages[state.selectedPageIndex].icon),
                  Text(state.eventPages[state.selectedPageIndex].name),
                ],
              ),
              content: Column(
                children: [
                  const Text('Created'),
                  Text(
                    Jiffy(state.eventPages[state.selectedPageIndex]._date)
                        .format('d/M/y h:mm a'),
                  ),
                  const Text('Latest Event'),
                  Text(
                    BlocProvider.of<HomePageCubit>(context).latestEventDate(),
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('Ok'),
                  onPressed: () {
                    BlocProvider.of<HomePageCubit>(context).unselect();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
