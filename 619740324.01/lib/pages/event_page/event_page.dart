import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../event.dart';

import '../../icons.dart';
import '../../note.dart';
import 'cubit_event_page.dart';
import 'states_event_page.dart';

class EventPage extends StatefulWidget {
  final String title;
  final Note note;
  final List<Note> noteList;

  const EventPage({
    Key? key,
    required this.title,
    required this.note,
    required this.noteList,
  }) : super(key: key);

  @override
  _EventPageState createState() => _EventPageState(note, noteList);
}

class _EventPageState extends State<EventPage> {
  final Note _note;
  final List<Note> _noteList;
  final TextEditingController textController = TextEditingController();
  final TextEditingController textSearchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final FocusNode _searchFocusNode = FocusNode();

  _EventPageState(this._note, this._noteList);

  @override
  void initState() {
    super.initState();
    BlocProvider.of<CubitEventPage>(context).init(_note, _noteList);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CubitEventPage, StatesEventPage>(
      builder: (context, state) {
        return Scaffold(
          appBar: state.isEventPressed
              ? _editingAppBar(state)
              : state.isTextSearch
                  ? searchAppBar(state)
                  : _appBar,
          body: _eventPageBody(state),
        );
      },
    );
  }

  AppBar searchAppBar(StatesEventPage state) {
    return AppBar(
      title: _textFieldSearch(state),
      actions: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              textSearchController.clear();
              BlocProvider.of<CubitEventPage>(context).setTextSearch(false);
            },
          ),
        ),
      ],
    );
  }

  TextField _textFieldSearch(StatesEventPage state) {
    return TextField(
      controller: textSearchController,
      focusNode: _searchFocusNode,
      decoration: const InputDecoration(
        hintText: 'Enter text',
        border: InputBorder.none,
        filled: true,
      ),
      onChanged: (value) =>
          BlocProvider.of<CubitEventPage>(context).setNote(state.note),
    );
  }

  AppBar _editingAppBar(StatesEventPage state) {
    return AppBar(
      automaticallyImplyLeading: false,
      leading: IconButton(
        onPressed: () {
          BlocProvider.of<CubitEventPage>(context).setEventPressed(false);
          textController.clear();
        },
        icon: const Icon(
          Icons.cancel_outlined,
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {
            _showDialogWithRadioList();
            BlocProvider.of<CubitEventPage>(context).setEventPressed(false);
          },
          icon: const Icon(
            Icons.reply,
          ),
        ),
        IconButton(
          onPressed: () {
            BlocProvider.of<CubitEventPage>(context).setEventEditing(true);
            textController.text =
                state.note!.eventList[state.selectedEventIndex].text;
            textController.selection = TextSelection(
              baseOffset: textController.text.length,
              extentOffset: textController.text.length,
            );
            BlocProvider.of<CubitEventPage>(context).setSelectedCircleAvatar(
                state.note!.eventList[state.selectedEventIndex]
                    .indexOfCircleAvatar);
            _focusNode.requestFocus();
            BlocProvider.of<CubitEventPage>(context).setEventPressed(false);
          },
          icon: const Icon(
            Icons.edit,
          ),
        ),
        IconButton(
          onPressed: () {
            _copyEvent(state);
            BlocProvider.of<CubitEventPage>(context).setEventPressed(false);
          },
          icon: const Icon(
            Icons.copy,
          ),
        ),
        IconButton(
          onPressed: () {
            BlocProvider.of<CubitEventPage>(context)
                .deleteEvent(state.selectedEventIndex);
            BlocProvider.of<CubitEventPage>(context).setEventPressed(false);
          },
          icon: const Icon(
            Icons.delete,
          ),
        ),
      ],
    );
  }

  AppBar get _appBar {
    return AppBar(
      centerTitle: true,
      title: Text(
        widget.title,
      ),
      actions: [
        IconButton(
          onPressed: () {
            BlocProvider.of<CubitEventPage>(context).setTextSearch(true);
            _searchFocusNode.requestFocus();
          },
          icon: const Icon(
            Icons.search,
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.bookmark_border,
          ),
        ),
      ],
    );
  }

  void _showDialogWithRadioList() {
    showDialog(
      context: context,
      builder: (context) {
        return BlocBuilder<CubitEventPage, StatesEventPage>(
          builder: (context, state) {
            return AlertDialog(
              title: const Text('Choose the page'),
              content: _containerWithRadioListTiles(state),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel')),
                IconButton(
                  icon: const Icon(Icons.check),
                  onPressed: () {
                    _noteList[state.selectedNoteIndex]
                        .eventList
                        .add(state.note!.eventList[state.selectedEventIndex]);
                    BlocProvider.of<CubitEventPage>(context)
                        .deleteEvent(state.selectedEventIndex);
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  Container _containerWithRadioListTiles(StatesEventPage state) {
    return Container(
      height: 250,
      width: 50,
      padding: const EdgeInsets.all(10),
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: state.noteList.length,
        itemBuilder: (context, index) {
          return RadioListTile<int>(
            key: ValueKey(index),
            title: Text(state.noteList[index].eventName),
            value: index,
            groupValue: state.selectedNoteIndex,
            onChanged: (value) =>
              BlocProvider.of<CubitEventPage>(context)
                  .setSelectedNoteIndex(value!),
          );
        },
      ),
    );
  }

  Widget _eventPageBody(StatesEventPage state) {
    return Column(
      children: [
        Expanded(
          child: _listViewWithEvents(state),
        ),
        state.isChoosingCircleAvatar
            ? Container(
                height: 70,
                padding: const EdgeInsets.only(bottom: 5),
                child: _rowWithIconButtons(),
              )
            : Container(
                height: 10,
              ),
        Container(
          child: _textFieldArea(state),
        )
      ],
    );
  }

  Row _textFieldArea(StatesEventPage state) {
    return Row(
      children: [
        Container(
          height: 70,
          child: IconButton(
            icon: state.selectedCircleAvatar == -1
                ? const Icon(
                    Icons.category,
                    size: 40,
                  )
                : Icon(
                    iconsList[state.selectedCircleAvatar].icon,
                    size: 40,
                  ),
            onPressed: () => BlocProvider.of<CubitEventPage>(context)
                .setChoosingCircleAvatar(true),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 5.0, bottom: 5.0),
            child: TextField(
              controller: textController,
              focusNode: _focusNode,
              onChanged: (value) {
                value.isNotEmpty
                    ? BlocProvider.of<CubitEventPage>(context).setWriting(true)
                    : BlocProvider.of<CubitEventPage>(context)
                        .setWriting(false);
              },
              decoration: const InputDecoration(
                hintText: 'Enter event',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                filled: false,
              ),
            ),
          ),
        ),
        Container(
          height: 70,
          padding: const EdgeInsets.only(right: 5.0),
          child: state.isWriting
              ? IconButton(
                  icon: const Icon(
                    Icons.send,
                    size: 40,
                  ),
                  onPressed: () {
                    if (state.isEventEditing) {
                      BlocProvider.of<CubitEventPage>(context).editText(
                          state.selectedEventIndex, textController.text);
                      BlocProvider.of<CubitEventPage>(context)
                          .removeSelectedCircleAvatar();
                      textController.clear();
                    } else {
                      BlocProvider.of<CubitEventPage>(context)
                          .sendEvent(textController.text);
                      BlocProvider.of<CubitEventPage>(context)
                          .removeSelectedCircleAvatar();
                      textController.clear();
                    }
                  },
                )
              : IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.photo,
                    size: 40,
                  ),
                ),
        ),
      ],
    );
  }

  Row _rowWithIconButtons() {
    return Row(
      children: [
        IconButton(
          icon: const CircleAvatar(
            child: Icon(Icons.clear),
            backgroundColor: Colors.red,
          ),
          onPressed: () {
            BlocProvider.of<CubitEventPage>(context)
                .removeSelectedCircleAvatar();
            BlocProvider.of<CubitEventPage>(context)
                .setChoosingCircleAvatar(false);
          },
        ),
        Expanded(
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: iconsList.length,
            itemBuilder: (context, index) {
              return IconButton(
                icon: CircleAvatar(
                  child: iconsList[index],
                ),
                onPressed: () {
                  BlocProvider.of<CubitEventPage>(context)
                      .setSelectedCircleAvatar(index);
                  BlocProvider.of<CubitEventPage>(context)
                      .setChoosingCircleAvatar(false);
                },
              );
            },
          ),
        ),
      ],
    );
  }

  ListView _listViewWithEvents(StatesEventPage state) {
    final newEventList = state.isTextSearch
        ? state.note!.eventList
            .where(
                (element) => element.text.contains(textSearchController.text))
            .toList()
        : state.note!.eventList;
    return ListView.builder(
      itemCount: newEventList.length,
      reverse: true,
      scrollDirection: Axis.vertical,
      itemBuilder: (context, index) =>
          _eventList(newEventList[index], index, state),
    );
  }

  Widget _eventList(Event event, int index, StatesEventPage state) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 20.0),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Align(
              alignment: Alignment.topLeft,
              child: Container(
                width: 300,
                child: Card(
                  elevation: 5,
                  color: Colors.blueGrey,
                  child: ListTile(
                    leading: event.indexOfCircleAvatar == -1
                        ? null
                        : CircleAvatar(
                            child: iconsList[event.indexOfCircleAvatar],
                          ),
                    title: Text(event.text),
                    subtitle: Align(
                      alignment: Alignment.bottomRight,
                      child: Text(event.time),
                    ),
                    trailing: event.isBookmark
                        ? const Icon(
                            Icons.bookmark,
                            size: 30,
                          )
                        : null,
                    onTap: () {
                      event.isBookmark = !event.isBookmark;
                      BlocProvider.of<CubitEventPage>(context)
                          .setNote(state.note);
                    },
                    onLongPress: () {
                      BlocProvider.of<CubitEventPage>(context)
                          .setSelectedEventIndex(index);
                      BlocProvider.of<CubitEventPage>(context)
                          .setEventPressed(true);
                    },
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  void _copyEvent(StatesEventPage state) {
    Clipboard.setData(
      ClipboardData(
        text: state.note?.eventList[state.selectedEventIndex].text,
      ),
    );
  }
}
