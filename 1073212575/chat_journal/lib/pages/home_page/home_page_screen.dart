import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jiffy/jiffy.dart';

import '../../database.dart';
import '../../repository/messages_repository.dart';
import '../../repository/pages_repository.dart';
import '../../theme/themes.dart';
import '../add_page/add_page_cubit.dart';
import '../add_page/add_page_screen.dart';
import '../event_page/event_page_cubit.dart';
import '../event_page/event_page_screen.dart';
import '../settings/settings_cubit.dart';
import '../settings/settings_screen.dart';
import '../settings/settings_state.dart';
import 'home_page_cubit.dart';
import 'home_page_state.dart';

Widget startApp() {
  final db = DBProvider();
  return MultiRepositoryProvider(
    providers: [
      RepositoryProvider<PagesRepository>(
        create: (context) => PagesRepository(db),
      ),
      RepositoryProvider<MessagesRepository>(
        create: (context) => MessagesRepository(db),
      ),
    ],
    child: MultiBlocProvider(
      providers: [
        BlocProvider<SettingsCubit>(
          create: (context) => SettingsCubit(),
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
          ),
        ),
        BlocProvider<AddPageCubit>(
          create: (context) => AddPageCubit(
            RepositoryProvider.of<PagesRepository>(context),
          ),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    BlocProvider.of<SettingsCubit>(context).setSettings();
    return BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, settingsState) {
      return MaterialApp(
        theme: settingsState.theme,
        title: 'Flutter Demo',
        home: HomePage(),
      );
    });
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
    BlocProvider.of<HomePageCubit>(context).showPages();
  }

  Future<void> authentication() async {
    if (await BlocProvider.of<SettingsCubit>(context).useBiometrics()) {
      BlocProvider.of<HomePageCubit>(context).authentication();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomePageCubit, HomePageState>(
      builder: (context, state) {
        final _homePageCubit = BlocProvider.of<HomePageCubit>(context);
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Theme.of(context).colorScheme.secondary,
                Theme.of(context).colorScheme.onSecondary,
                Theme.of(context).colorScheme.secondaryVariant,
              ],
            ),
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: state.isSelected
                ? _editingAppBar(state, _homePageCubit)
                : _defaultAppBar(),
            floatingActionButton: floatingActionButton(_homePageCubit),
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
                    child: _eventsList(state, _homePageCubit),
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

  Widget floatingActionButton(HomePageCubit _homePageCubit) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const AddPage(
              needsEditing: false,
              selectedPageIndex: -1,
            ),
          ),
        ).then(_homePageCubit.onGoBack);
      },
      backgroundColor: Theme.of(context).colorScheme.primary,
      child: Icon(
        Icons.add,
        color: Theme.of(context).colorScheme.secondaryVariant,
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
          MaterialPageRoute(
            builder: (context) => SettingsPage(),
          ),
        ),
        icon: const Icon(
          Icons.settings,
        ),
      ),
      title: const Text('Home'),
    );
  }

  PreferredSizeWidget _editingAppBar(state, _homePageCubit) {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.primary,
      shape: const RoundedRectangleBorder(
        borderRadius:
            BorderRadius.vertical(bottom: Radius.circular(radiusValue)),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_rounded),
        onPressed: _homePageCubit.unselect,
      ),
      title: const Text(''),
      actions: [
        IconButton(
          icon: const Icon(Icons.delete_rounded),
          onPressed: _homePageCubit.delete,
        ),
        IconButton(
          icon: const Icon(Icons.book_rounded),
          onPressed: () => _homePageCubit.fix(),
        ),
        IconButton(
            icon: const Icon(Icons.edit_rounded),
            onPressed: () {
              _homePageCubit.edit();
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
          onPressed: () => simpleDialog(context, state, _homePageCubit),
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
        //backgroundColor: Theme.of(context).colorScheme.onPrimary,
        unselectedItemColor: Theme.of(context).colorScheme.onBackground,
        selectedItemColor: Theme.of(context).colorScheme.background,
        iconSize: 27,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            title: Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment_rounded),
            title: Text('Daily'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment_turned_in_rounded),
            title: Text('Timeline'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore_rounded),
            title: Text('Explore'),
          ),
        ],
      ),
    );
  }

  Widget _eventsList(state, _homePageCubit) {
    return ListView.builder(
      itemCount: state.eventPages.length,
      itemBuilder: (context, i) => _event(i, state, _homePageCubit),
    );
  }

  Widget _event(int i, state, _homePageCubit) {
    return GestureDetector(
      onLongPress: () => _homePageCubit.select(i),
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

  Future simpleDialog(
      BuildContext context, dynamic state, dynamic _homePageCubit) {
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
                    _homePageCubit.latestEventDate(),
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('Ok'),
                  onPressed: () {
                    _homePageCubit.unselect();
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
