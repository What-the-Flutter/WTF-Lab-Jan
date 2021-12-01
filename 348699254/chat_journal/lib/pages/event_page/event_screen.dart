import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

import '../../data/models/activity_page.dart';
import 'event_cubit.dart';
import 'event_state.dart';

class EventScreen extends StatefulWidget {
  final ActivityPage activityPage;
  final List pageList;

  const EventScreen({
    Key? key,
    required this.activityPage,
    required this.pageList,
  }) : super(key: key);

  @override
  _EventScreenState createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  final _eventInputController = TextEditingController();
  final timeFormat = DateFormat('h:m a');
  final Map<String, IconData> _categoriesMap = {
    'Cancel': Icons.cancel,
    'Workout': Icons.sports_tennis_rounded,
    'Movie': Icons.local_movies,
    'FastFood': Icons.fastfood,
    'Running': Icons.directions_run_outlined,
    'Sports': Icons.sports_baseball_rounded,
    'Laundry': Icons.local_laundry_service,
  };

  @override
  void initState() {
    super.initState();
    BlocProvider.of<EventCubit>(context).init(widget.activityPage.id);
    print(widget.activityPage.id);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EventCubit, EventState>(
      builder: (context, state) {
        return Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: state.isSelected
              ? _appBarForSelectedEvents(state)
              : _usualAppBar(state),
          body: state.isSearching && _eventInputController.text.isEmpty
              ? _startSearchContainer(state)
              : _bodyStructure(context, state),
          bottomNavigationBar: state.isSearching
              ? null
              : Padding(
            child: _eventBottomAppBar(context, state),
            padding: EdgeInsets.only(
                bottom: MediaQuery
                    .of(context)
                    .viewInsets
                    .bottom),
          ),
        );
      },
    );
  }

  Widget _startSearchContainer(EventState state) {
    return Align(
      alignment: AlignmentDirectional.topCenter,
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
        margin: const EdgeInsets.fromLTRB(25, 50, 25, 0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.search,
              size: 50,
              color: Colors.black38,
            ),
            const Text(
              'Please enter a search query to begin searching',
              style: TextStyle(
                color: Colors.black38,
                fontSize: 18,
              ),
            ),
          ],
        ),
        decoration: BoxDecoration(
          color: Colors.greenAccent,
          borderRadius: BorderRadius.circular(5),
        ),
      ),
    );
  }

  AppBar _usualAppBar(EventState state) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          if (state.isSearching) {
            BlocProvider.of<EventCubit>(context).setFinishSearching();
            BlocProvider.of<EventCubit>(context).showAllEvents();
            _eventInputController.clear();
          } else {
            Navigator.pop(context);
          }
        },
      ),
      title: Align(
        child: state.isSearching
            ? _textFormFieldForSearching(state)
            : Text(widget.activityPage.name),
        alignment: Alignment.center,
      ),
      actions: state.isSearching
          ? <Widget>[
        if (_eventInputController.text.isNotEmpty)
          IconButton(
            icon: const Icon(Icons.cancel_outlined),
            onPressed: _eventInputController.clear,
          ),
      ]
          : <Widget>[
        _usualAppBarButtons(state),
      ],
    );
  }

  Widget _usualAppBarButtons(EventState state) {
    return Row(
      children: <Widget>[
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () =>
              BlocProvider.of<EventCubit>(context).setIsSearching(),
        ),
        IconButton(
          icon: const Icon(Icons.bookmark_border_outlined),
          color: Colors.amber,
          onPressed: () =>
              BlocProvider.of<EventCubit>(context)
                  .showMarkedEvents(!state.isAllMarked),
        ),
      ],
    );
  }

  Widget _textFormFieldForSearching(EventState state) {
    return TextFormField(
      decoration: InputDecoration(
        border: InputBorder.none,
        contentPadding: const EdgeInsets.all(15),
        isDense: true,
        hintText: 'Search in ${widget.activityPage.name}',
        fillColor: Colors.teal,
        filled: true,
        hintStyle: const TextStyle(
          color: Colors.grey,
        ),
      ),
      keyboardType: TextInputType.text,
      controller: _eventInputController,
      onChanged: (text) {
        BlocProvider.of<EventCubit>(context).searchEvent(text);
      },
      onFieldSubmitted: (text) {
        BlocProvider.of<EventCubit>(context)
            .showSearchedEvents(state.searchData);
      },
    );
  }

  AppBar _appBarForSelectedEvents(EventState state) {
    return AppBar(
      leading: _appBarCrossButton(state),
      actions: <Widget>[
        _appBarButtonsForSelectedEvents(state),
      ],
    );
  }

  Widget _appBarCrossButton(EventState state) {
    return IconButton(
      icon: const Icon(Icons.clear),
      onPressed: () => BlocProvider.of<EventCubit>(context).unselectEvent(),
    );
  }

  Widget _appBarButtonsForSelectedEvents(EventState state) {
    final selectedList =
    state.eventList.where((element) => element.isSelected).toList();
    return Row(
      children: <Widget>[
        IconButton(
          icon: const Icon(Icons.reply),
          onPressed: () {
            _showReplyDialog(state);
          },
        ),
        if (selectedList.length == 1)
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () =>
            _eventInputController.text =
                BlocProvider.of<EventCubit>(context)
                    .edit(state.selectedEventIndex),
          ),
        IconButton(
          icon: const Icon(Icons.copy),
          onPressed: _copyClipBoard,
        ),
        IconButton(
          icon: const Icon(Icons.bookmark_border_outlined),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () => _alertDeleteDialog(context, state),
        ),
      ],
    );
  }

  void _showReplyDialog(EventState state) {
    var dialog = AlertDialog(
      insetPadding: const EdgeInsets.all(50),
      title: const Text(
        'Select the page you want to migrate the selected event(s) to!',
        style: TextStyle(fontSize: 22, color: Colors.black45),
      ),
      content: Container(
        height: 300,
        width: 300,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.all(5),
                itemCount: widget.pageList.length,
                itemBuilder: (_, index) => _replyRadioListTile(state, index),
              ),
            ),
          ],
        ),
      ),
      actions: [
        _cancelButtonForReplyEvents(),
        _okButtonForReplyEvents(state),
      ],
    );
    showDialog(
      context: context,
      builder: (context) {
        return dialog;
      },
    );
  }

  ElevatedButton _cancelButtonForReplyEvents() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: Colors.indigoAccent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(3.0),
        ),
      ),
      child: const Text(
        'Cancel',
        style: TextStyle(
          color: Colors.black26,
        ),
      ),
      onPressed: () {
        Navigator.of(context).pop(false); // Return true
      },
    );
  }

  ElevatedButton _okButtonForReplyEvents(EventState state) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: Colors.indigoAccent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(3.0),
        ),
      ),
      child: const Text(
        'Ok',
        style: TextStyle(
          color: Colors.black26,
        ),
      ),
      onPressed: () {
        BlocProvider.of<EventCubit>(context)
            .replyEvents(widget.pageList[state.selectedPage].id);
        Navigator.of(context).pop();
      },
    );
  }

  Widget _replyRadioListTile(EventState state, int index) {
    return RadioListTile(
      title: Text(
        widget.pageList[index].name,
      ),
      value: index,
      groupValue: state.selectedPage,
      onChanged: (value) =>
          BlocProvider.of<EventCubit>(context)
              .setIndexOfSelectedPage(value as int),
    );
  }

  Future<void> _copyClipBoard() async {
    BlocProvider.of<EventCubit>(context).copy();
    BlocProvider.of<EventCubit>(context).unselectEvent();
    await _actionsToast('Copied to a clipboard');
  }

  void _alertDeleteDialog(BuildContext context, EventState state) {
    final selectedList =
    state.eventList.where((element) => element.isSelected).toList();
    var dialog = AlertDialog(
      title: const Text('Delete Entry(s)?'),
      content: const FittedBox(
        child: Text('Are you sure you want to delete the 1 selected events?'),
      ),
      actions: [
        Row(children: [
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () {
              print('deleteIndex = ${state.selectedEventIndex}');
              BlocProvider.of<EventCubit>(context).delete(selectedList);
              Navigator.of(context).pop(true); // Return true
            },
          ),
          const Text('Delete'),
        ]),
        Row(children: [
          IconButton(
            icon: const Icon(Icons.cancel, color: Colors.blue),
            onPressed: () {
              Navigator.of(context).pop(false); // Return true
            },
          ),
          const Text('Cancel'),
        ]),
      ],
    );
    var futureValue = showDialog(
        context: context,
        builder: (context) {
          return dialog;
        });
    futureValue.then((value) async {
      await _actionsToast('Delete selected event');
      BlocProvider.of<EventCubit>(context).unselectEvent();
      //print('Return value: $value'); // true/false
    });
  }

  Future<bool?> _actionsToast(String text) {
    return Fluttertoast.showToast(
      msg: text,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black54,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  Widget _appBarNoteButton() {
    return IconButton(
      icon: const Icon(Icons.bookmark_border_outlined),
      onPressed: () {},
    );
  }

  Widget _bodyStructure(BuildContext context, EventState state) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Expanded(
          child: _eventsList(state),
        ),
        if (state.isCategoryListOpened)
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                height: 70,
                child: _categoryList(),
              ),
            ),
          ),
      ],
    );
  }

  Widget _eventsList(EventState state) {
    return ListView.builder(
      padding: const EdgeInsets.all(5),
      reverse: true,
      itemCount: state.eventList.length,
      itemBuilder: (_, index) {
        return Dismissible(
          key: UniqueKey(),
          background: Container(
            alignment: AlignmentDirectional.centerEnd,
            child: const Padding(
              padding: EdgeInsets.fromLTRB(0.0, 0.0, 20.0, 0.0),
              child: Icon(
                Icons.delete,
                color: Colors.blueGrey,
              ),
            ),
          ),
          onDismissed: (direction) {
            if (direction == DismissDirection.startToEnd) {
              _eventInputController.text = state.eventList[index].eventData;
              BlocProvider.of<EventCubit>(context).edit(index);
            } else if (direction == DismissDirection.endToStart) {
              BlocProvider.of<EventCubit>(context)
                  .deleteEvent(state.eventList[index]);
            }
          },
          child: _eventItem(index, state),
        );
      },
    );
  }

  Widget _eventItem(int index, EventState state) {
    final timeFormat = DateFormat('h:m a');
    final timeInString = timeFormat.format(state.eventList[index].creationDate);
    if (state.isSearching) {
      BlocProvider.of<EventCubit>(context).showSearchedEvents(state.searchData);
    }
    return Align(
      alignment: Alignment.centerLeft,
      child: Flex(
        direction: Axis.horizontal,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(top: 5),
            constraints: BoxConstraints(
              maxWidth: MediaQuery
                  .of(context)
                  .size
                  .width * 0.87,
            ),
            decoration: const BoxDecoration(
              color: Colors.greenAccent,
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
            ),
            child: _eventTile(
              state,
              state.eventList[index].imagePath,
              state.eventList[index].eventData,
              timeInString,
              index,
            ),
          ),
        ],
      ),
    );
  }

  Widget _categoryContainer(IconData? categoryIcon, String? categoryName) {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Icon(
            categoryIcon,
            size: 35,
            color: Colors.black54,
          ),
          Text(
            '     ${categoryName!}',
            style: const TextStyle(
              fontSize: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _eventTile(EventState state, String imagePath, String title,
      String subtitle, int index) {
    return ListTile(
      title: imagePath.isNotEmpty
          ? Image.file(File(imagePath))
          : Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (state.eventList[index].categoryIcon != null)
            _categoryContainer(
              state.eventList[index].categoryIcon,
              state.eventList[index].categoryName,
            ),
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w300,
              fontSize: 16,
            ),
          ),
        ],
      ),
      subtitle: Row(
        children: <Widget>[
          state.eventList[index].isSelected
              ? _listTileWithIconRow(subtitle)
              : _listTileRow(subtitle),
        ],
      ),
      trailing: state.eventList[index].isMarked
          ? const Icon(Icons.bookmark, color: Colors.amber)
          : null,
      selected: state.eventList[index].isSelected,
      onTap: () => BlocProvider.of<EventCubit>(context).markEvent(index),
      onLongPress: () =>
          BlocProvider.of<EventCubit>(context).selectEvent(index),
    );
  }

  Widget _listTileWithIconRow(String subtitle) {
    return Row(
      children: <Widget>[
        const Icon(
          Icons.check_circle,
          color: Colors.black54,
          size: 13,
        ),
        Text(
          subtitle,
          style: const TextStyle(
            color: Colors.black26,
          ),
        ),
      ],
    );
  }

  Widget _listTileRow(String subtitle) {
    return Row(
      children: <Widget>[
        Text(
          subtitle,
          style: const TextStyle(
            color: Colors.black26,
          ),
        ),
      ],
    );
  }

  Widget _listTileWithMarkIcon(String subtitle) {
    return Row(
      children: <Widget>[
        const Icon(
          Icons.bookmark,
          color: Colors.amber,
          size: 13,
        ),
        Text(
          subtitle,
          style: const TextStyle(
            color: Colors.black26,
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _eventInputController.dispose();
    super.dispose();
  }

  Widget _eventBottomAppBar(BuildContext context, EventState state) {
    var entries = _categoriesMap.entries.toList();
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          IconButton(
            icon: state.selectedCategoryIndex > 0
                ? Icon(entries
                .elementAt(state.selectedCategoryIndex)
                .value)
                : const Icon(Icons.workspaces_filled),
            color: Colors.teal,
            onPressed: () {
              BlocProvider.of<EventCubit>(context).openCategoryList();
            },
          ),
          Expanded(
            child: _eventTextFormField(state),
          ),
          IconButton(
            icon: const Icon(Icons.add_a_photo),
            color: Colors.teal,
            onPressed: () {
              BlocProvider.of<EventCubit>(context).addImageEvent().then(
                    (value) =>
                    BlocProvider.of<EventCubit>(context)
                        .addEvent(state.selectedImage),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _categoryList() {
    return ListView.builder(
      padding: const EdgeInsets.all(5),
      scrollDirection: Axis.horizontal,
      itemCount: _categoriesMap.length,
      itemBuilder: (_, index) =>
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              _categoryItem(index, _categoriesMap),
            ],
          ),
    );
  }

  Widget _categoryItem(int index, Map<String, IconData> categoriesMap) {
    var entries = categoriesMap.entries.toList();
    return GestureDetector(
      child: SizedBox(
        width: 100,
        child: ListTile(
          title: CircleAvatar(
            backgroundColor: index == 0 ? Colors.transparent : Colors.grey,
            radius: 50,
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Icon(
                    entries
                        .elementAt(index)
                        .value,
                    color: index == 0 ? Colors.red : Colors.white,
                    size: 30,
                  ),
                ),
              ],
            ),
          ),
          subtitle: Align(
            alignment: Alignment.topCenter,
            child: Text(entries
                .elementAt(index)
                .key),
          ),
          onTap: () {
            if (index == 0) {
              BlocProvider.of<EventCubit>(context).closeCategoryList();
            } else {
              BlocProvider.of<EventCubit>(context).setCategoryIndex(index);
            }
          },
        ),
      ),
    );
  }

  Widget _eventTextFormField(EventState state) {
    return TextFormField(
      decoration: const InputDecoration(
        border: InputBorder.none,
        contentPadding: EdgeInsets.all(15),
        isDense: true,
        hintText: 'Enter Event',
        fillColor: Colors.lightBlueAccent,
        filled: true,
        hintStyle: TextStyle(
          color: Colors.grey,
        ),
      ),
      keyboardType: TextInputType.text,
      controller: _eventInputController,
      onFieldSubmitted: (text) {
        if (state.selectedImage.isNotEmpty) {
          BlocProvider.of<EventCubit>(context).setSelectedImage('');
        }
        if (_eventInputController.text.isNotEmpty) {
          if (state.isEditing) {
            BlocProvider.of<EventCubit>(context).addEditedEvent(text);
          } else {
            _addEvent(state, text);
          }
          BlocProvider.of<EventCubit>(context).closeCategoryList();
        }
        _eventInputController.clear();
      },
    );
  }

  void _addEvent(EventState state, String text) {
    var entries = _categoriesMap.entries.toList();
    if (state.selectedCategoryIndex > 0) {
      BlocProvider.of<EventCubit>(context).addEvent(
        text,
        entries
            .elementAt(state.selectedCategoryIndex)
            .value,
        entries
            .elementAt(state.selectedCategoryIndex)
            .key,
      );
      BlocProvider.of<EventCubit>(context).setCategoryInitialIndex();
    } else {
      BlocProvider.of<EventCubit>(context).addEvent(text);
    }
  }
}
