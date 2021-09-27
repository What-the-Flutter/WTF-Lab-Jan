import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubit/events/event_cubit.dart';
import '../../cubit/home_screen/home_cubit.dart';
import '../../cubit/settings/settings_cubit.dart';
import '../../cubit/themes/theme_cubit.dart';
import '../../main.dart';
import '../../models/note_model.dart';
import '../../utils/utils.dart';
import 'labeled_radio_tile.dart';

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
  late final TextEditingController _searchController;

  NoteInfo({Key? key}) : super(key: key) {
    _scrollController = ScrollController();
    _textController = TextEditingController();
    _searchController = TextEditingController();
  }

  late var textState;

  @override
  Widget build(BuildContext context) {
    final page = ModalRoute.of(context)!.settings.arguments as PageCategoryInfo;
    context.read<EventCubit>().init(page);
    textState =
        BlocProvider.of<SettingsCubit>(context).state.textSize.toDouble();
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
                  Column(
                    children: [
                      state.isAddingHashTag
                          ? Align(
                              alignment: Alignment.center,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Theme.of(context).backgroundColor,
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                ),
                                padding: const EdgeInsets.all(10),
                                margin: const EdgeInsets.all(4),
                                child: Text(
                                  'Adding Tag: ${state.textInput}',
                                  style: TextStyle(
                                    fontSize: textState,
                                  ),
                                ),
                              ),
                            )
                          : Container(),
                      state.selectedPhoto != ''
                          ? Align(
                              alignment: Alignment.topLeft,
                              child: GestureDetector(
                                onTap: () =>
                                    BlocProvider.of<EventCubit>(context)
                                        .deleteSelectedPhoto(),
                                child: Container(
                                  margin: const EdgeInsets.all(6),
                                  child: Stack(
                                    children: [
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                5,
                                        height:
                                            MediaQuery.of(context).size.height /
                                                10,
                                        // color: Theme.of(context).accentColor.withAlpha(80),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          child: Image.file(
                                            File(state.selectedPhoto!),
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      ),
                                      CircleAvatar(
                                        backgroundColor:
                                            Theme.of(context).buttonColor,
                                        radius: 15,
                                        child:
                                            const Icon(Icons.close, size: 20),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          : Container(),
                      state.isChangingCategory
                          ? buildCategories(context, state)
                          : Container(),
                    ],
                  ),
                  buildBottomContainer(context, state),
                ],
              ),
              context.read<SettingsCubit>().state.isDateTimeModification
                  ? Align(
                      alignment: Alignment.topLeft,
                      child: GestureDetector(
                        onTap: () => showTime(context),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          margin: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Theme.of(context).accentColor.withAlpha(70),
                          ),
                          child: Flex(
                            direction: Axis.horizontal,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.calendar_today_outlined,
                                size: 15,
                              ),
                              Container(
                                padding: const EdgeInsets.only(left: 5),
                                child: Text(state.selectedDate != null
                                    ? getFullDate(state.selectedDate!)
                                    : 'Today'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  : Container(),
            ],
          ),
        );
      },
    );
  }

  void showTime(BuildContext context) {
    {
      showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2001),
        lastDate: DateTime(2200),
      ).then((date) {
        if (date != null) {
          showTimePicker(
            context: context,
            initialTime: const TimeOfDay(hour: 0, minute: 0),
          ).then((time) {
            if (time != null) {
              var newDate =
                  date.add(Duration(hours: time.hour, minutes: time.minute));
              BlocProvider.of<EventCubit>(context).setPickedDate(newDate);
            }
          });
        }
      });
    }
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
      title: state.isEditMode
          ? Container()
          : state.isSearchState
              ? TextField(
                  controller: _searchController,
                  autofocus: true,
                  keyboardType: TextInputType.text,
                  maxLines: 1,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.secondary,
                        width: 0.0,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.secondary,
                        width: 0.0,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.secondary,
                        width: 0.0,
                      ),
                    ),
                    hintText: 'Input your text',
                    hintStyle: TextStyle(fontSize: textState - 1),
                    labelStyle: TextStyle(
                        fontSize: textState - 5,
                        color: Theme.of(context).colorScheme.secondary),
                    helperStyle: const TextStyle(color: Colors.blue),
                    labelText: 'Search',
                    contentPadding: const EdgeInsets.all(10),
                  ),
                  onChanged: (text) =>
                      BlocProvider.of<EventCubit>(context).setSearchText(text),
                )
              : Text(
                  state.title,
                  style: TextStyle(
                    fontSize: textState + 5,
                  ),
                ),
      actions: [
        !state.isEditMode
            ? IconButton(
                icon: state.isSearchState
                    ? const Icon(Icons.search_off_outlined)
                    : const Icon(Icons.search),
                onPressed: () =>
                    BlocProvider.of<EventCubit>(context).setSearchState(),
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
                        title: Text(
                          'Move to:',
                          style: TextStyle(
                            fontSize: textState,
                          ),
                        ),
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
                            child: Text(
                              'Cancel',
                              style: TextStyle(
                                fontSize: textState,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              context.read<EventCubit>().replyEvents();
                              Navigator.pop(context, 'Ok');
                            },
                            child: Text(
                              'Ok',
                              style: TextStyle(
                                fontSize: textState,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
              )
            : Container(),
        !state.isEditMode && !state.isSearchState
            ? IconButton(
                icon: state.isBookmarkedNoteMode
                    ? Icon(
                        Icons.bookmark_added,
                        color: Theme.of(context).colorScheme.secondary,
                      )
                    : const Icon(Icons.bookmark),
                onPressed: () {
                  BlocProvider.of<EventCubit>(context).setBookmarkedOnly();
                },
              )
            : Container(),
        state.isEditMode
            ? IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () async {
                  _deleteEvent(context);
                },
              )
            : Container(),
        state.isEditMode
            ? IconButton(
                icon: const Icon(Icons.bookmark_add),
                onPressed: () => BlocProvider.of<EventCubit>(context).addSelectedToBookmarks(),
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
                    child: Text(
                      listOfEventsNames[index],
                      style: TextStyle(
                        fontSize: textState - 3,
                      ),
                    ),
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
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: textState + 2,
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
              style: TextStyle(
                fontSize: textState - 2,
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
      child: Stack(
        children: [
          BlocProvider.of<SettingsCubit>(context).state.imagePath != null
              ? Image.file(
                  File(
                    BlocProvider.of<SettingsCubit>(context).state.imagePath!,
                  ),
                  // height: double.infinity,
                  // width: double.infinity,
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  alignment: Alignment.center,
                  fit: BoxFit.cover,
                )
              : Container(),
          ListView.builder(
            controller: _scrollController,
            reverse: true,
            itemCount: state.allNotes.length,
            itemBuilder: (context, index) {
              if (state.isBookmarkedNoteMode) {
                if (state.allNotes[index].isBookmarked) {
                  return eventTile(state, index, context);
                } else {
                  return Container();
                }
              } else if (state.isSearchState) {
                if (state.allNotes[index].description != null) {
                  if (state.allNotes[index].description!.toLowerCase()
                      .contains(state.searchInput!)) {
                    return eventTile(state, index, context);
                  } else {
                    return Container();
                  }
                }
                return Container();
              } else {
                if (index == 0 && checkDays(state.allNotes[index].time,
                    state.allNotes[index + 1].time)) {
                  return Column(
                    children: [
                      dateTile(context, state, index - 1),
                      eventTile(state, index, context),
                    ],
                  );
                } else if (index == state.allNotes.length - 1) {
                  return Column(
                    children: [
                      dateTile(context, state, index - 1),
                      eventTile(state, index, context),
                    ],
                  );
                } else if (index > 0 &&
                    checkDays(state.allNotes[index].time,
                        state.allNotes[index + 1].time)) {
                  return Column(
                    children: [
                      dateTile(context, state, index - 1),
                      eventTile(state, index, context),
                    ],
                  );
                } else {
                  return eventTile(state, index, context);
                }
              }
            },
          ),
        ],
      ),
    );
  }

  Widget eventTile(EventState state, int index, BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (state.activeNotes.isNotEmpty) {
          context.read<EventCubit>().selectEvent(index);
        } else {
          context.read<EventCubit>().addToBookmarks(index);
        }
      },
      onLongPress: () {
        context.read<EventCubit>()
          ..setEditMode()
          ..selectEvent(index);
      },
      child: noteTile(index, context),
    );
  }

  bool checkDays(DateTime day1, DateTime day2) {
    if (day1.day != day2.day) return true;
    return false;
  }

  String formattedTime(DateTime date) {
    var formattedDate = '${date.day}'
        ' ${getMonthNameByDate(date)}'
        ', ${date.hour}'
        ':${date.minute}'
        ', ${date.year}';
    return formattedDate;
  }

  Widget dateTile(BuildContext context, EventState state, int index) {
    return Container(
      color: Theme.of(context).primaryColor.withAlpha(40),
      child: Align(
        alignment: BlocProvider.of<SettingsCubit>(context)
                .state
                .isCenterDateBubble
            ? Alignment.center
            : BlocProvider.of<SettingsCubit>(context).state.isBubbleAlignment
                ? Alignment.centerLeft
                : Alignment.centerRight,
        child: Container(
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.all(7),
          decoration: BoxDecoration(
            color: Theme.of(context).backgroundColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            formattedTime(state.allNotes[index + 1].time),
            style: TextStyle(
              fontSize: textState,
            ),
          ),
        ),
      ),
    );
  }

  Widget noteTile(int index, BuildContext context) {
    context..read<EventCubit>();
    final state = context.read<EventCubit>().state;
    return Stack(
      children: [
        Container(
          color: state.activeNotes.contains(index)
              ? Colors.green[100]
              : Colors.transparent,
          child: Container(
            color: Theme.of(context).primaryColor.withAlpha(40),
            child: ListTile(
              leading: state.allNotes[index].category != 0
                  ? !BlocProvider.of<SettingsCubit>(context)
                          .state
                          .isBubbleAlignment
                      ? null
                      : Icon(listOfEventsIcons[state.allNotes[index].category])
                  : null,
              title: Column(
                crossAxisAlignment: BlocProvider.of<SettingsCubit>(context)
                        .state
                        .isBubbleAlignment
                    ? CrossAxisAlignment.start
                    : CrossAxisAlignment.end,
                children: [
                  state.allNotes[index].description != null
                      ? Container(
                          padding: const EdgeInsets.only(bottom: 5),
                          child: Text(
                            state.allNotes[index].description!,
                            style:
                                state.allNotes[index].description!.contains('#')
                                    ? TextStyle(
                                        fontSize: textState,
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context).accentColor,
                                      )
                                    : TextStyle(
                                        fontSize: textState,
                                      ),
                          ),
                        )
                      : Container(),
                  state.allNotes[index].image != null &&
                          state.allNotes[index].image != ''
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
                alignment: BlocProvider.of<SettingsCubit>(context)
                        .state
                        .isBubbleAlignment
                    ? Alignment.topLeft
                    : Alignment.topRight,
                child: Container(
                  padding: const EdgeInsets.only(top: 5),
                  // child: Text(state.allNotes[index].formattedTime),
                  child: Text(
                    getFullDate(state.allNotes[index].time),
                    style: TextStyle(
                      fontSize: textState - 3,
                    ),
                  ),
                ),
              ),
              trailing: state.allNotes[index].category != 0
                  ? BlocProvider.of<SettingsCubit>(context)
                          .state
                          .isBubbleAlignment
                      ? null
                      : Icon(listOfEventsIcons[state.allNotes[index].category])
                  : null,
            ),
          ),
        ),
        Align(
          alignment:
              BlocProvider.of<SettingsCubit>(context).state.isBubbleAlignment
                  ? Alignment.topRight
                  : Alignment.topLeft,
          child: state.allNotes[index].isBookmarked
              ? const Icon(
                  Icons.bookmark,
                  size: 30,
                  color: Colors.yellowAccent,
                )
              : Container(),
        ),
      ],
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
                  style: TextStyle(fontSize: textState),
                  decoration: InputDecoration(
                    // border: InputBorder.none,
                    border:
                        const OutlineInputBorder(borderSide: BorderSide.none),
                    hintText: state.selectedDate != null
                        ? 'Entry @ ${getShortDate(state.selectedDate!)}'
                        : 'Enter Event',
                    contentPadding: const EdgeInsets.only(left: 10),
                  ),
                  keyboardType: TextInputType.text,
                  onChanged: (text) {
                    BlocProvider.of<EventCubit>(context).setInputText(text);
                    BlocProvider.of<EventCubit>(context).checkInput();
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
                      onPressed: () async =>
                          context.read<EventCubit>().addImageFromGallery(),
                    ),
                  )
                : GestureDetector(
                    onLongPress: () =>
                        context.read<EventCubit>().setIsPickingPhoto(),
                    child: IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: () async => _sendMessage(context),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  void _sendMessage(BuildContext context) async {
    context.read<EventCubit>().setIsPickingPhoto();
    await context.read<EventCubit>()
      ..addMessageEvent();
    FocusScope.of(context).unfocus();
    _textController.clear();
  }

  void _deleteEvent(BuildContext context) async {
    await context.read<EventCubit>()
      ..deleteEvent();
  }

  void _moveToLastMessage() {
    _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
  }
}
