import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../cubit/events/event_cubit.dart';
import '../../cubit/home_screen/home_cubit.dart';
import '../../cubit/settings/settings_cubit.dart';
import '../../cubit/themes/theme_cubit.dart';
import '../../main.dart';
import '../../models/note_model.dart';
import 'labeled_radio_tile.dart';
import 'note_search_delegate.dart';

final List<String> listOfEventsNames = [
  'Cancel',
  'Movie',
  'Workout',
  'Sports',
  'Laundry',
  'FastFood',
  'Running',
];

class NoteInfo extends StatelessWidget {
  late final ScrollController _scrollController;
  late final TextEditingController _textController;

  NoteInfo({Key? key}) : super(key: key) {
    _scrollController = ScrollController();
    _textController = TextEditingController();
  }

  late List<String> _words;
  late NoteSearchDelegate _delegate;
  late List<Note> _elements;

  List<Note> items = [];

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
          body: Stack(
            children: [
              Column(
                children: [
                  state.allNotes.isEmpty
                      ? buildNote(state)
                      : buildListView(context),
                  state.isChangingCategory
                      ? buildCategories(context, state)
                      : Container(),
                  buildBottomContainer(context, state),
                ],
              ),
              GestureDetector(
                onTap: () {
                  Picke;
                },
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Theme.of(context).accentColor,
                    ),
                    child: Text('Какая-то рандомная дата'),
                  ),
                ),
              )
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
                context.read<EventCubit>().setEditMode();
                context.read<EventCubit>().unselectEvents();
              },
            )
          : IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
      title: !state.isEditMode ? Text(state.title) : const Text(''),
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
                  var journals = BlocProvider.of<HomeCubit>(context).state;
                  showDialog<void>(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Move to:'),
                        content: StatefulBuilder(
                          builder: (context, setState) {
                            return Container(
                              height: 250,
                              width: 100,
                              child: ListView.builder(
                                itemCount: journals.pages.length,
                                itemBuilder: (context, index) {
                                  return LabeledRadio(
                                    label: journals.pages[index].title,
                                    padding: const EdgeInsets.all(10),
                                    groupValue: state.checked,
                                    value: index,
                                    onChanged: (value) {
                                      context
                                          .read<EventCubit>()
                                          .setChecked(value);
                                      context
                                          .read<EventCubit>()
                                          .setReplyPage(context, value);
                                      print(state.pageReplyIndex);
                                    },
                                  );
                                },
                              ),
                            );
                          },
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              context.read<EventCubit>().replyEvents();
                              Navigator.pop(context, 'Ok');
                            },
                            child: const Text('Ok'),
                          ),
                        ],
                      );
                    },
                  );
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
                      state.allNotes[state.activeNotes[0]].description!;
                },
              )
            : Container(),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget buildCategories(BuildContext context, EventState state) {
    var iconThemeColor =
        context.read<ThemeCubit>().state.themeData!.iconTheme.color;
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
                } else {
                  context.read<EventCubit>().setCategory(index);
                }
                context.read<EventCubit>().setIsChangingCategory();
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
                    child: Text(listOfEventsNames[index]),
                  ),
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
              'This is the page where you can track everything about ${state.title}!',
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
              'Add your first event to "${state.title}" '
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

  Widget buildListView(BuildContext context) {
    final state = context.read<EventCubit>().state;
    return Expanded(
      child: ListView.builder(
        controller: _scrollController,
        reverse: true,
        itemCount: state.allNotes.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => context.read<EventCubit>().selectEvent(index),
            onLongPress: () {
              context.read<EventCubit>()
                ..setEditMode()
                ..selectEvent(index);
            },
            child: noteTile(index, context),
          );
        },
      ),
    );
  }

  bool checkDays(DateTime day1, DateTime day2) {
    if (day1.day != day2.day) return true;
    return false;
  }

  Widget noteTile(int index, BuildContext context) {
    context..read<EventCubit>();
    final themeColor = context.read<ThemeCubit>().state.themeData!.accentColor;
    final state = context.read<EventCubit>().state;
    if (index > 0 &&
        checkDays(state.allNotes[index].time, state.allNotes[index - 1].time)) {
      return Align(
        alignment: BlocProvider.of<SettingsCubit>(context)
                .state
                .isCenterDateBubble
            ? Alignment.center
            : BlocProvider.of<SettingsCubit>(context).state.isBubbleAlignment
                ? Alignment.centerLeft
                : Alignment.centerRight,
        child: Container(
          color: themeColor,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(state.allNotes[index].time.month.toString()),
        ),
      );
    } else {
      return Container(
        color: state.activeNotes.contains(index)
            ? Colors.green[100]
            : Colors.transparent,
        child: ListTile(
          leading: state.allNotes[index].category != 0
              ? !BlocProvider.of<SettingsCubit>(context).state.isBubbleAlignment
                  ? null
                  : Icon(listOfEventsIcons[state.allNotes[index].category])
              : null,
          title: Column(
            crossAxisAlignment:
                BlocProvider.of<SettingsCubit>(context).state.isBubbleAlignment
                    ? CrossAxisAlignment.start
                    : CrossAxisAlignment.end,
            children: [
              state.allNotes[index].description != null
                  ? Container(
                      padding: const EdgeInsets.only(bottom: 5),
                      child: Text(state.allNotes[index].description!),
                    )
                  : Container(),
              state.allNotes[index].image != null
                  ? ClipRRect(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(8),
                      ),
                      child: Image.file(
                        File(state.allNotes[index].image!),
                      ),
                    )
                  : Container(),
            ],
          ),
          subtitle: Align(
            alignment:
                BlocProvider.of<SettingsCubit>(context).state.isBubbleAlignment
                    ? Alignment.topLeft
                    : Alignment.topRight,
            child: Container(
              padding: const EdgeInsets.only(top: 5),
              child: Text(state.allNotes[index].formattedTime),
            ),
          ),
          trailing: state.allNotes[index].category != 0
              ? BlocProvider.of<SettingsCubit>(context).state.isBubbleAlignment
                  ? null
                  : Icon(listOfEventsIcons[state.allNotes[index].category])
              : null,
        ),
      );
    }
  }

  Align buildBottomContainer(BuildContext context, EventState state) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 60),
        child: Row(
          children: <Widget>[
            IconButton(
              icon: state.selectedCategory != 0
                  ? Icon(listOfEventsIcons[state.selectedCategory])
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
            state.isPickingPhoto
                ? GestureDetector(
                    onLongPress: () {
                      context.read<EventCubit>().setIsPickingPhoto();
                    },
                    child: IconButton(
                      icon: const Icon(Icons.camera_alt),
                      onPressed: () {
                        context.read<EventCubit>().setIsPickingPhoto;
                        pickImage(context, state);
                      },
                    ),
                  )
                : GestureDetector(
                    onLongPress: () {
                      context.read<EventCubit>().setIsPickingPhoto();
                    },
                    child: IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: () => _sendMessage(context, null),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Future pickImage(BuildContext context, EventState state) async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      // context.read<EventCubit>().setSelectedPhoto(await pickImage(context, state));
      context.read<EventCubit>().setIsPickingPhoto();
      final imageTemporary = File(await image.path);
      _sendMessage(context, imageTemporary.path);
      return imageTemporary.path;
    } on PlatformException catch (e) {
      print(e);
    }
  }

  void _sendMessage(BuildContext context, String? image) async {
    context.read<EventCubit>().setIsPickingPhoto();

    context.read<EventCubit>().addMessageEvent(_textController.text, image);
    FocusScope.of(context).unfocus();
    _textController.clear();
  }

  void _deleteEvent(BuildContext context) {
    context.read<EventCubit>().deleteEvent();
  }

  void moveToLastMessage() {
    _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
  }
}
