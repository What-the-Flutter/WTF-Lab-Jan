import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jiffy/jiffy.dart';

import '../../models/events_model.dart';
import '../../theme/themes.dart';
import '../settings/settings_cubit.dart';
import '../settings/settings_state.dart';
import 'event_page_cubit.dart';
import 'event_page_state.dart';

class EventPage extends StatefulWidget {
  final EventPages eventPage;

  const EventPage({
    Key? key,
    required this.eventPage,
  }) : super(key: key);

  @override
  _EventPageState createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  final _controller = TextEditingController();
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    BlocProvider.of<EventPageCubit>(context).setPageId(widget.eventPage.id);
    BlocProvider.of<EventPageCubit>(context).showMessages();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EventPageCubit, EventPageState>(
      builder: (blocContext, state) {
        final _eventPageCubit = BlocProvider.of<EventPageCubit>(context);
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
            appBar: state.isSearchGoing
                ? _searchAppBar(state, _eventPageCubit)
                : state.isSelected
                    ? _editingAppBar(state, _eventPageCubit)
                    : _defaultAppBar(state, _eventPageCubit),
            body: Stack(
              children: <Widget>[
                _eventMessagesList(state, _eventPageCubit),
                _categories(state, _eventPageCubit),
                _messageBottomBar(state, _eventPageCubit),
              ],
            ),
          ),
        );
      },
    );
  }

  PreferredSizeWidget _editingAppBar(state, _eventPageCubit) {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.primary,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(radiusValue),
        ),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_rounded),
        onPressed: () => _eventPageCubit.unselect(),
      ),
      title: const Text(''),
      actions: [
        IconButton(
          icon: const Icon(Icons.reply_rounded),
          onPressed: () => _choosePage(state, _eventPageCubit),
        ),
        IconButton(
          icon: const Icon(Icons.delete_rounded),
          onPressed: () => _eventPageCubit.delete(),
        ),
        IconButton(
          icon: const Icon(Icons.copy_rounded),
          onPressed: () => _eventPageCubit.copy(),
        ),
        IconButton(
          icon: const Icon(Icons.edit_rounded),
          onPressed: () => _controller.text = _eventPageCubit.edit(),
        ),
      ],
    );
  }

  PreferredSizeWidget _defaultAppBar(state, _eventPageCubit) {
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
      title: const Text(''),
      actions: [
        IconButton(
          icon: !state.onlyMarked
              ? const Icon(Icons.bookmark_border_rounded)
              : const Icon(Icons.bookmark_rounded),
          onPressed: () => _eventPageCubit.showMarked(),
        ),
        IconButton(
          icon: const Icon(Icons.search_rounded),
          onPressed: () => _eventPageCubit.startSearching(),
        ),
      ],
    );
  }

  PreferredSizeWidget _searchAppBar(state, _homePageCubit) {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.primary,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(radiusValue),
        ),
      ),
      leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () {
            _homePageCubit.endSearching();
            _searchController.clear();
          }),
      title: const Text(''),
      actions: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.only(left: 40),
            child: TextField(
              controller: _searchController,
              onChanged: _homePageCubit.searchMessages(_searchController.text),
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.all(10),
                border: InputBorder.none,
                hintText: 'Search',
              ),
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: _searchController.clear,
        ),
      ],
    );
  }

  Widget _messageBottomBar(state, _eventPageCubit) {
    return Visibility(
      visible: !state.isSearchGoing,
      child: Align(
        alignment: Alignment.bottomLeft,
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(radiusValue),
          ),
          child: Container(
            height: 50,
            color: Theme.of(context).colorScheme.onPrimary,
            child: BlocBuilder<SettingsCubit, SettingsState>(
              builder: (blocContext, settingsState) {
                return Row(
                  children: [
                    Visibility(
                        visible: settingsState.isCategoryPanelVisible,
                        child: IconButton(
                            icon: const Icon(Icons.stars_rounded),
                            color: Theme.of(context).colorScheme.background,
                            onPressed: () {
                              _eventPageCubit.openCategoryPanel();
                            })),
                    IconButton(
                      icon: const Icon(Icons.add_a_photo_rounded),
                      color: Theme.of(context).colorScheme.background,
                      onPressed: () => _eventPageCubit.addImage(),
                    ),
                    Visibility(
                      visible: settingsState.isCustomDateUsed,
                      child: IconButton(
                        icon: const Icon(Icons.date_range_rounded),
                        color: Theme.of(context).colorScheme.background,
                        onPressed: () {
                          _selectTime();
                          _selectDate(context);
                        },
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Visibility(
                            visible: state.isDateTimeSelected,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                child: Text(
                                  Jiffy(_eventPageCubit.selectedDateTime())
                                      .format('d/M/y h:mm a'),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: TextField(
                              controller: _controller,
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.all(10),
                                border: InputBorder.none,
                                hintText: 'Enter event',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                        icon: const Icon(Icons.send_rounded),
                        color: Theme.of(context).colorScheme.background,
                        onPressed: () {
                          _eventPageCubit.addMessage(_controller.text);
                          _controller.clear();
                        }),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _eventMessagesList(state, _eventPageCubit) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 20, 20, 70),
      child: ListView.separated(
        itemCount: state.messages.length + 1,
        separatorBuilder: (context, i) => _message(i, state, _eventPageCubit),
        itemBuilder: (context, i) {
          if (i < state.messages.length) {
            return _day(i, state, _eventPageCubit);
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _day(i, state, _eventPageCubit) {
    return Visibility(
      visible: _eventPageCubit.isSeparatorVisible(i),
      child: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (blocContext, settingsState) {
          return Align(
            alignment: settingsState.dateAlignment,
            child: Container(
              width: 100,
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: const BorderRadius.all(
                  Radius.circular(radiusValue),
                ),
              ),
              child: Text(
                Jiffy(state.messages[i].date).format('d/M/y'),
                style: TextStyle(
                    fontSize: 10,
                    color: Theme.of(context).colorScheme.onSurface),
                textAlign: TextAlign.center,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _message(int i, eventState, _eventPageCubit) {
    return Dismissible(
      confirmDismiss: (direction) async {
        if (!eventState.isSelected) {
          if (direction == DismissDirection.startToEnd) {
            _controller.text = _eventPageCubit.edit(i);
            return false;
          } else if (direction == DismissDirection.endToStart) {
            _eventPageCubit.delete(widget.eventPage.id, i);
            return false;
          }
        }
      },
      background: const Align(
        alignment: Alignment.centerLeft,
        child: Icon(Icons.edit_rounded),
      ),
      secondaryBackground: const Align(
        alignment: Alignment.centerRight,
        child: Icon(Icons.delete_rounded),
      ),
      key: Key(i.toString()),
      child: GestureDetector(
        onTap: () => _eventPageCubit.mark(i),
        onLongPress: () => _eventPageCubit.select(i),
        child: BlocBuilder<SettingsCubit, SettingsState>(
          builder: (blocContext, settingsState) {
            return Align(
              alignment: settingsState.messageAlignment,
              child: Container(
                width: 250,
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: i == eventState.selectedMessageIndex &&
                          eventState.isSelected
                      ? Theme.of(context).colorScheme.surface
                      : Theme.of(context).colorScheme.onPrimary,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(radiusValue),
                  ),
                ),
                child: _messageContent(eventState, i, _eventPageCubit),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _messageContent(state, i, _eventPageCubit) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
        padding: const EdgeInsets.only(bottom: 5),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.only(right: 5),
              child: BlocBuilder<SettingsCubit, SettingsState>(
                  builder: (blocContext, state) {
                return Icon(
                  _eventPageCubit.categoryIcon(
                    state.isCategoryPanelVisible,
                    i,
                  ),
                  size: 16,
                  color: Theme.of(context).colorScheme.onSurface,
                );
              }),
            ),
            Text(
              Jiffy(state.messages[i].date).format('h:mm a'),
              style: TextStyle(
                  fontSize: 10, color: Theme.of(context).colorScheme.onSurface),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: Icon(
                  Icons.book_rounded,
                  color: state.messages[i].isMarked
                      ? Theme.of(context).colorScheme.primaryVariant
                      : Colors.transparent,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
      Column(
        children: [
          Visibility(
            visible: state.messages[i].imagePath != '',
            child: Image.file(
              File(state.messages[i].imagePath),
              height: 300,
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(left: 25),
            child: Text(
              state.messages[i].text,
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).colorScheme.background,
              ),
            ),
          )
        ],
      )
    ]);
  }

  Widget _categories(state, _eventPageCubit) {
    var _icons = [
      Icons.highlight_remove_rounded,
      Icons.airplanemode_active_rounded,
      Icons.shopping_cart_rounded,
      Icons.local_movies_rounded,
    ];
    var _names = ['Close', 'Travel', 'Shopping', 'Movies'];
    return Visibility(
      visible: state.isCategoryPanelOpened,
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Container(
          height: 140,
          color: Theme.of(context).colorScheme.onPrimary,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _icons.length,
            itemBuilder: (context, i) {
              return GestureDetector(
                onTap: () => _eventPageCubit.chooseCategory(i, _icons[i]),
                child: Container(
                  margin: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      ClipOval(
                        child: Container(
                          height: 50,
                          width: 50,
                          color: _icons[i] == state.categoryIcon
                              ? Theme.of(context).colorScheme.surface
                              : Colors.transparent,
                          child: Icon(_icons[i]),
                        ),
                      ),
                      Text(_names[i]),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Future _choosePage(state, _eventPageCubit) {
    var _chosenPageIndex;
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
              'Select the page you want to migrate the selected event(s) to'),
          content: StatefulBuilder(builder: (context, setState) {
            return Container(
              height: 300,
              width: 300,
              child: ListView.builder(
                itemCount: state.eventPages.length,
                itemBuilder: (context, i) {
                  return RadioListTile(
                    title: Text(state.eventPages[i].name),
                    value: i,
                    groupValue: _chosenPageIndex,
                    onChanged: (index) =>
                        setState(() => _chosenPageIndex = index),
                  );
                },
              ),
            );
          }),
          actions: <Widget>[
            TextButton(
                child: const Text('Ok'),
                onPressed: () {
                  _eventPageCubit.moveMessage(
                    state.eventPages[_chosenPageIndex].id,
                  );
                  Navigator.of(context).pop();
                }),
          ],
        );
      },
    );
  }

  void _selectTime() async {
    final newTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    BlocProvider.of<EventPageCubit>(context).setTime(newTime);
  }

  void _selectDate(BuildContext context) async {
    final newDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2010),
      lastDate: DateTime(2025),
    );
    BlocProvider.of<EventPageCubit>(context).setDate(newDate);
  }
}
