import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../Themes/theme_change.dart';
import '../../cubit/events/event_cubit.dart';
import '../../main.dart';
import '../../models/note_model.dart';
import 'note_search_delegate.dart';

class NoteInfo extends StatelessWidget {
  late final ScrollController _scrollController;
  late final TextEditingController _textController;

  NoteInfo({Key? key}) : super(key: key) {
    _scrollController = ScrollController();
    _textController = TextEditingController();
  }

  // late List<String> _words;
  // late NoteSearchDelegate _delegate;
  // late List<Note> _elements;
  //
  // List<Note> items = [];

  @override
  Widget build(BuildContext context) {
    final page = ModalRoute.of(context)!.settings.arguments as PageCategoryInfo;
    context.read<EventCubit>().init(page);
    return BlocBuilder<EventCubit, EventState>(
      builder: (context, state) {
        return Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(60),
            child: buildAppBar(context, state),
          ),
          body: Column(
            children: [
              state.pageNote!.note.isEmpty
                  ? buildNote(state)
                  : buildListView(context),
              state.isChangingCategory
                  ? buildCategories(context, state)
                  : Container(),
              buildBottomContainer(context, state),
            ],
          ),
        );
      },
    );
  }

  Widget buildAppBar(BuildContext context, EventState state) {
    return AppBar(
      elevation: 0.0,
      centerTitle: true,
      leading: state.isEditMode
          ? IconButton(
              icon: const Icon(Icons.cancel),
              onPressed: () {
                context.read<EventCubit>().setEditMode(true);
              },
            )
          : IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
      title: !state.isEditMode ? Text(state.pageNote!.title) : const Text(''),
      actions: [
        !state.isEditMode
            ? IconButton(
                icon: const Icon(Icons.search),
                onPressed: () async {
                  // _words = BlocProvider.of<PageCubit>(context)
                  //     .getJournalsDescriptions(widget.index);
                  // _elements = BlocProvider.of<PageCubit>(context)
                  //     .getJournalsNotes(widget.index);
                  // _delegate =
                  //     NoteSearchDelegate(widget.index, _words, _elements);
                  // final selected = await showSearch<String>(
                  //     context: context, delegate: _delegate);
                  // if (selected != null) {
                  //   //TODO _scrollController jump to the element in ListView}
                  // }
                },
              )
            : Container(),
        state.isEditMode
            ? IconButton(
                icon: const Icon(Icons.reply),
                onPressed: () {
                  // var journals = BlocProvider.of<PageCubit>(context).state;
                  // showDialog<void>(
                  //   context: context,
                  //   builder: (context) {
                  //     return AlertDialog(
                  //       title: const Text('Move to:'),
                  //       content: StatefulBuilder(
                  //         builder: (context, setState) {
                  //           return Container(
                  //             height: 250,
                  //             width: 100,
                  //             child: ListView.builder(
                  //               itemCount: journals.pages.length,
                  //               itemBuilder: (context, index) {
                  //                 return LabeledRadio(
                  //                     label: journals.pages[index].title,
                  //                     padding: const EdgeInsets.all(10),
                  //                     groupValue: _checked,
                  //                     value: index,
                  //                     onChanged: (value) {
                  //                       setState(
                  //                         () {
                  //                           _checked = value;
                  //                           _checkedElement =
                  //                               journals.pages[index];
                  //                         },
                  //                       );
                  //                     });
                  //               },
                  //             ),
                  //           );
                  //         },
                  //       ),
                  //       actions: [
                  //         TextButton(
                  //           onPressed: () {
                  //             _checkedElement = null;
                  //             _checked = -1;
                  //             Navigator.pop(context);
                  //           },
                  //           child: const Text('Cancel'),
                  //         ),
                  //         TextButton(
                  //           onPressed: () {
                  //             for (var el in activeNotes) {
                  //               _checkedElement?.note.add(el);
                  //               deleteMessages(events);
                  //             }
                  //             _checkedElement = null;
                  //             _checked = -1;
                  //             Navigator.pop(context, 'Ok');
                  //           },
                  //           child: const Text('Ok'),
                  //         ),
                  //       ],
                  //     );
                  //   },
                  // );
                },
              )
            : Container(),
        !state.isEditMode
            ? IconButton(
                icon: const Icon(Icons.bookmark_added),
                onPressed: () {
                  state.isBookmarkedNoteMode ? false : true;
                },
              )
            : Container(),
        state.isEditMode
            ? IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  _deleteEvent(context);
                },
              )
            : Container(),
        state.isEditMode
            ? IconButton(
                icon: const Icon(Icons.bookmark_add),
                onPressed: () {
                  //TODO bookmark events
                },
              )
            : Container(),
        state.isEditMode
            ? IconButton(
                icon: const Icon(Icons.copy),
                onPressed: () {
                  context.read<EventCubit>().copyDataFromEvents();
                },
              )
            : Container(),
        state.isEditMode && !state.isMultiSelection
            ? IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  context.read<EventCubit>().setMessageEditMode(true);
                  _textController.text =
                      state.pageNote!.note[state.activeNotes[0]].description!;
                },
              )
            : Container(),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget buildCategories(BuildContext context, EventState state) {
    var iconThemeColor =
        ThemeSelector.instanceOf(context).theme.iconTheme.color;
    return Container(
      height: 110,
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: listOfEventsIcons.length,
        itemBuilder: (context, index) {
          return Container(
            padding: const EdgeInsets.all(10),
            child: GestureDetector(
              onTap: () {
                if (index == 0) {
                  context.read<EventCubit>().setDefaultCategory();
                  context.read<EventCubit>().setIsChangingCategory();
                } else {
                  context.read<EventCubit>().setCategory(EventCategory(
                      title: _textController.text,
                      icon: state.selectedCategory.icon));
                  context.read<EventCubit>().setIsChangingCategory();
                }
              },
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 30,
                    child: Icon(
                      listOfEventsIcons[index],
                      color: index == 0 ? Colors.red : iconThemeColor,
                    ),
                  ),
                  Container(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(listOfEventsNames[index])),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildNote(EventState state) {
    return Expanded(
      child: Column(
        children: <Widget>[
          Container(
            color: Colors.yellow,
            padding: const EdgeInsets.all(15),
            margin: const EdgeInsets.only(
              left: 25,
              top: 25,
              right: 25,
            ),
            child: Text(
              'This is the page where you can track everything about ${state.pageNote!.title}!',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 17,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(
              left: 25,
              right: 25,
            ),
            color: Colors.yellow,
            height: 20,
          ),
          Container(
            color: Colors.yellow,
            padding: const EdgeInsets.all(15),
            margin: const EdgeInsets.only(
              left: 25,
              bottom: 25,
              right: 25,
            ),
            child: Text(
              'Add your first event to "${state.pageNote!.title}" '
              'page by entering some text in the text box'
              'below and hitting the send button. Long tap'
              'the send button to align the event in the '
              'opposite direction. Tap on the bookmark icon'
              'on the top right corner to show the bookmarked '
              'events only',
              style: const TextStyle(
                fontSize: 15,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Expanded buildListView(BuildContext context) {
    final state = context.read<EventCubit>().state;
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(10),
        child: ListView.builder(
          controller: _scrollController,
          reverse: true,
          itemCount: state.pageNote!.note.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () => context.read<EventCubit>().selectEvent(index),
              onLongPress: () {
                context.read<EventCubit>()
                  ..setEditMode(true)
                  ..selectEvent(index);
              },
              child: noteTile(index, context),
            );
          },
        ),
      ),
    );
  }

  Widget noteTile(int index, BuildContext context) {
    final state = context.read<EventCubit>().state;
    return Container(
      color: state.activeNotes.contains(index)
          ? Colors.green[100]
          : Colors.transparent, // TODO
      child: ListTile(
        leading: state.pageNote!.note[index].category.icon != null
            ? Icon(state.pageNote!.note[index].category.icon)
            : null,
        title: Text(state.pageNote!.note[index].description!),
        subtitle: Text(state.pageNote!.note[index].formattedTime),
        trailing: state.activeNotes.contains(index)
            ? const Icon(
                Icons.check,
                color: Colors.green,
              )
            : null,
      ),
    );
  }

  Align buildBottomContainer(BuildContext context, EventState state) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 60),
        child: Row(
          children: <Widget>[
            IconButton(
              icon: state.selectedCategory.icon != null
                  ? Icon(state.selectedCategory.icon)
                  : const Icon(Icons.event),
              onPressed: () {
                context.read<EventCubit>().setIsChangingCategory();
              },
            ),
            Flexible(
              child: Container(
                margin: const EdgeInsets.all(5),
                decoration: const BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: TextFormField(
                  controller: _textController,
                  style: const TextStyle(fontSize: 16),
                  decoration: const InputDecoration(
                    // border: InputBorder.none,
                    border: OutlineInputBorder(borderSide: BorderSide.none),
                    hintText: 'Enter event',
                    contentPadding: EdgeInsets.only(left: 10),
                  ),
                  keyboardType: TextInputType.text,
                  onChanged: (text) {
                    if (text != '') {}
                  },
                ),
              ),
            ),

            // _textController.text.isEmpty
            //     ? IconButton(
            //         icon: const Icon(Icons.camera_alt),
            //         onPressed: () {},
            //       )
            //     :

            IconButton(
              icon: const Icon(Icons.send),
              onPressed: () {
                context
                    .read<EventCubit>()
                    .addMessageEvent(_textController.text);
                _textController.text = '';
                print(state.pageNote!.note.isEmpty);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _deleteEvent(BuildContext context) {
    context.read<EventCubit>().deleteEvent();
  }

  void moveToLastMessage() {
    _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
  }
}
