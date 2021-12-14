import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../event.dart';

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
  _EventPageState createState() => _EventPageState(note);
}

class _EventPageState extends State<EventPage> {
  final Note _note;
  final TextEditingController textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  _EventPageState(this._note);

  @override
  void initState() {
    super.initState();
    BlocProvider.of<CubitEventPage>(context).init(_note);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CubitEventPage, StatesEventPage>(
      builder: (context, state) {
        return Scaffold(
          appBar: state.isEditing ? _editingAppBar(state) : _appBar,
          body: _eventPageBody(state),
        );
      },
    );
  }

  AppBar _editingAppBar(StatesEventPage state) {
    return AppBar(
      automaticallyImplyLeading: false,
      leading: IconButton(
        onPressed: () {
          BlocProvider.of<CubitEventPage>(context).setTextEditing(false);
          textController.clear();
        },
        icon: const Icon(
          Icons.cancel_outlined,
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {
            textController.text =
                state.note!.eventList[state.selectedEventIndex].text;
            textController.selection = TextSelection(
              baseOffset: textController.text.length,
              extentOffset: textController.text.length,
            );
            _focusNode.requestFocus();
          },
          icon: const Icon(
            Icons.edit,
          ),
        ),
        IconButton(
          onPressed: () {
            _copyEvent(state);
            BlocProvider.of<CubitEventPage>(context).setTextEditing(false);
          },
          icon: const Icon(
            Icons.copy,
          ),
        ),
        IconButton(
          onPressed: () {
            BlocProvider.of<CubitEventPage>(context)
                .deleteEvent(state.selectedEventIndex);
            BlocProvider.of<CubitEventPage>(context).setTextEditing(false);
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
          onPressed: () {},
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

  Widget _eventPageBody(StatesEventPage state) {
    return Column(
      children: [
        Expanded(
          child: _listView(state),
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
            icon: const Icon(
              Icons.category,
              size: 40,
            ),
            onPressed: () {},
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
                    if (state.isEditing) {
                      BlocProvider.of<CubitEventPage>(context).editText(
                          state.selectedEventIndex, textController.text);
                      textController.clear();
                    } else {
                      BlocProvider.of<CubitEventPage>(context)
                          .sendEvent(textController.text);
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

  ListView _listView(StatesEventPage state) {
    return ListView.builder(
      itemCount: state.note?.eventList.length,
      reverse: true,
      scrollDirection: Axis.vertical,
      itemBuilder: (context, index) =>
          _eventList(state.note!.eventList[index], index, state),
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
                    onTap: () => BlocProvider.of<CubitEventPage>(context)
                        .updateBookmark(event),
                    onLongPress: () {
                      BlocProvider.of<CubitEventPage>(context)
                          .setSelectedEventIndex(index);
                      BlocProvider.of<CubitEventPage>(context)
                          .setTextEditing(true);
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
