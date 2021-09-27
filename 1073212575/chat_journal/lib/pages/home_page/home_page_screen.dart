import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/events.dart';
import '../../theme/custom_theme.dart';
import '../../theme/themes.dart';
import '../add_page/add_page_screen.dart';
import '../event_page/event_page_screen.dart';
import 'home_page_cubit.dart';
import 'home_page_state.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: CustomTheme.of(context),
      title: 'Flutter Demo',
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // var _isSelected = false;
  // var _selectedPageIndex;

  //List _unsortedPages = eventPages;

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
            floatingActionButton: floatingActionButton(),
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

  Widget floatingActionButton() {
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
        );
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
      leading: const Icon(Icons.menu_rounded),
      title: const Text('Home'),
      actions: [
        IconButton(
          icon: const Icon(Icons.wb_sunny_rounded),
          onPressed: CustomTheme.instanceOf(context).changeTheme,
        )
      ],
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
          onPressed: _homePageCubit.fix,
        ),
        IconButton(
          icon: const Icon(Icons.edit_rounded),
          onPressed: _homePageCubit.edit,
        ),
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
      itemCount: eventPages.length,
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
                builder: (context) => EventPage(eventPageIndex: i),
              ),
            );
          },
          child: _eventContent(i),
        ),
      ),
    );
  }

  Widget _eventContent(int i) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Icon(
            eventPages[i].icon,
            color: Theme.of(context).colorScheme.primaryVariant,
            size: 40,
          ),
        ),
        Text(
          eventPages[i].name,
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
              color: eventPages[i].isFixed
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
                  Icon(eventPages[state.selectedPageIndex].icon),
                  Text(eventPages[state.selectedPageIndex].name),
                ],
              ),
              content: Column(
                children: [
                  const Text('Created'),
                  Text(eventPages[state.selectedPageIndex].date),
                  const Text('Latest Event'),
                  Text(
                    eventPages[state.selectedPageIndex].eventMessages.isEmpty
                        ? 'no messages'
                        : eventPages[state.selectedPageIndex]
                            .eventMessages
                            .last
                            .date,
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
