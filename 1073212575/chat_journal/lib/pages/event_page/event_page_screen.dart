import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/events.dart';
import '../../theme/themes.dart';
import 'event_page_cubit.dart';
import 'event_page_state.dart';

class EventPage extends StatefulWidget {
  final int eventPageIndex;

  const EventPage({Key? key, required this.eventPageIndex}) : super(key: key);

  @override
  _EventPageState createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  final _controller = TextEditingController();
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    BlocProvider.of<EventPageCubit>(context)
        .showMessages(widget.eventPageIndex);
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
                ? _searchAppBar(_eventPageCubit)
                : state.isSelected
                    ? _editingAppBar(_eventPageCubit)
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

  PreferredSizeWidget _editingAppBar(_eventPageCubit) {
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
          onPressed: () => _choosePage(_eventPageCubit),
        ),
        IconButton(
          icon: const Icon(Icons.delete_rounded),
          onPressed: () => _eventPageCubit.delete(widget.eventPageIndex),
        ),
        IconButton(
          icon: const Icon(Icons.copy_rounded),
          onPressed: () => _eventPageCubit.copy(widget.eventPageIndex),
        ),
        IconButton(
          icon: const Icon(Icons.edit_rounded),
          onPressed: () =>
              _eventPageCubit.edit(widget.eventPageIndex, _controller),
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
          icon: state.onlyMarked
              ? const Icon(Icons.bookmark_border_rounded)
              : const Icon(Icons.bookmark_rounded),
          onPressed: () => _eventPageCubit.showMarked(widget.eventPageIndex),
        ),
        IconButton(
          icon: const Icon(Icons.search_rounded),
          onPressed: () => _eventPageCubit.startSearching(),
        ),
      ],
    );
  }

  PreferredSizeWidget _searchAppBar(_homePageCubit) {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.primary,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(radiusValue),
        ),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_rounded),
        onPressed: () => _homePageCubit.endSearching(
            widget.eventPageIndex, _searchController),
      ),
      title: const Text(''),
      actions: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.only(left: 40),
            child: TextField(
              controller: _searchController,
              onChanged: _homePageCubit.searchMessages(
                  widget.eventPageIndex, _searchController.text),
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
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.stars_rounded),
                  color: Theme.of(context).colorScheme.background,
                  onPressed: () => _eventPageCubit.openCategoryPanel(),
                ),
                IconButton(
                  icon: const Icon(Icons.add_a_photo_rounded),
                  color: Theme.of(context).colorScheme.background,
                  onPressed: () =>
                      _eventPageCubit.addImage(widget.eventPageIndex),
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
                IconButton(
                  icon: const Icon(Icons.send_rounded),
                  color: Theme.of(context).colorScheme.background,
                  onPressed: () => _eventPageCubit.addMessage(
                      context, widget.eventPageIndex, _controller),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _eventMessagesList(state, _eventPageCubit) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 20, 60, 70),
      child: ListView.builder(
        itemCount: state.messages.length,
        itemBuilder: (context, i) => _message(i, state, _eventPageCubit),
      ),
    );
  }

  Widget _message(int i, state, _eventPageCubit) {
    return Dismissible(
      confirmDismiss: (direction) async {
        if (!state.isSelected) {
          if (direction == DismissDirection.startToEnd) {
            _eventPageCubit.edit(widget.eventPageIndex, _controller, i);
            return false;
          } else if (direction == DismissDirection.endToStart) {
            _eventPageCubit.delete(widget.eventPageIndex, i);
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
        onTap: () => _eventPageCubit.mark(i, widget.eventPageIndex),
        onLongPress: () => _eventPageCubit.select(i),
        child: Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: state.messages[i].isMarked == true
                ? Theme.of(context).colorScheme.surface
                : Theme.of(context).colorScheme.onPrimary,
            borderRadius: const BorderRadius.all(
              Radius.circular(radiusValue),
            ),
          ),
          child: _messageContent(state, i),
        ),
      ),
    );
  }

  Widget _messageContent(state, i) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 5),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.only(right: 5),
                child: Icon(
                  state.messages[i].icon,
                  size: 16,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              Text(
                state.messages[i].date,
                style: TextStyle(
                    fontSize: 10,
                    color: Theme.of(context).colorScheme.onSurface),
              ),
            ],
          ),
        ),
        state.messages[i].content.toString() == "Instance of 'XFile'"
            ? Image.file(
                File((state.messages[i].content).path),
                height: 300,
              )
            : Container(
                padding: const EdgeInsets.only(left: 25),
                child: Text(
                  state.messages[i].content.toString(),
                  style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.background),
                ),
              ),
      ],
    );
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
                onTap: i == 0
                    ? () => _eventPageCubit.closeCategoryPanel()
                    : () => _eventPageCubit.setCategory(_icons[i]),
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

  Future _choosePage(_eventPageCubit) {
    var _chosenPageIndex;
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text(
                'Select the page you want to migrate the selected event(s) to'),
            content: StatefulBuilder(builder: (context, setState) {
              return Container(
                height: 300, // Change as per your requirement
                width: 300, // Change as per your requirement
                child: ListView.builder(
                  itemCount: eventPages.length,
                  itemBuilder: (context, i) {
                    return RadioListTile(
                      title: Text(eventPages[i].name),
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
                onPressed: () => _eventPageCubit.moveMessage(
                    _chosenPageIndex, widget.eventPageIndex, context),
              ),
            ],
          );
        });
  }
}
