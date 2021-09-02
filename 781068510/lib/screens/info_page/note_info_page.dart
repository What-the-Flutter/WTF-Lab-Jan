import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:notes/screens/info_page/dismissible_widget.dart';
import 'package:notes/screens/info_page/labeled_radio_tile.dart';

import '../../Themes/theme_change.dart';
import '../../data/journal_cubit.dart';
import '../../main.dart';
import '../../models/note_model.dart';
import 'note_info_tile.dart';
import 'note_search_delegate.dart';

class NoteInfo extends StatefulWidget {
  final Journal journal;
  final int index;

  NoteInfo({
    required this.journal,
    required this.index,
    Key? key,
  }) : super(key: key);

  @override
  _NoteInfo createState() => _NoteInfo();
}

class _NoteInfo extends State<NoteInfo> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _textController = TextEditingController();

  List<Note> activeNotes = [];

  bool isEditMode = false;
  bool isMultiSelection = false;
  bool isTextEditMode = false;
  bool isBookmarkedNoteMode = false;
  bool isChangingCategory = false;

  String inputText = '';
  IconData? _selectedIcon;
  bool isTextTyped = false;

  int _checked = -1;
  Journal? _checkedElement;

  late List<String> _words;
  late NoteSearchDelegate _delegate;
  late List<Note> _elements;

  List<Note> items = [];

  void initText() {
    _textController.addListener(() {
      setState(() {
        inputText = _textController.text;
        inputText.isEmpty ? isTextTyped = false : isTextTyped = true;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    initText();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<JournalCubit, List<Journal>>(
      builder: (context, journals) {
        var events = journals[widget.index];
        items = List.of(events.note);
        return Scaffold(
          appBar: PreferredSize(
              preferredSize: const Size.fromHeight(60),
              child: buildAppBar(widget.journal.title, events)),
          body: events.note.isEmpty ? noListView() : withListView(events),
        );
      },
    );
  }

  Widget buildAppBar(String title, Journal events) {
    final label = !isEditMode ? title : '';
    BlocProvider.of<JournalCubit>(context);
    return AppBar(
      elevation: 0.0,
      centerTitle: true,
      leading: isEditMode
          ? IconButton(
              icon: const Icon(Icons.cancel),
              onPressed: cancelEditMode,
            )
          : IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
      title: Text(label),
      actions: [
        !isEditMode
            ? IconButton(
                icon: const Icon(Icons.search),
                onPressed: () async {
                  _words = BlocProvider.of<JournalCubit>(context)
                      .getJournalsDescriptions(widget.index);
                  _elements = BlocProvider.of<JournalCubit>(context)
                      .getJournalsNotes(widget.index);
                  _delegate =
                      NoteSearchDelegate(widget.index, _words, _elements);
                  final selected = await showSearch<String>(
                      context: context, delegate: _delegate);
                  if (selected != null) {
                    //TODO _scrollController jump to the element in ListView}
                  }
                },
              )
            : Container(),
        isEditMode
            ? IconButton(
                icon: const Icon(Icons.reply),
                onPressed: () {
                  var journals = BlocProvider.of<JournalCubit>(context).state;
                  isEditMode = !isEditMode;
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
                                itemCount: journals.length,
                                itemBuilder: (context, index) {
                                  return LabeledRadio(
                                      label: journals[index].title,
                                      padding: const EdgeInsets.all(10),
                                      groupValue: _checked,
                                      value: index,
                                      onChanged: (value) {
                                        setState(
                                          () {
                                            _checked = value;
                                            _checkedElement = journals[index];
                                          },
                                        );
                                      });
                                },
                              ),
                            );
                          },
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              _checkedElement = null;
                              _checked = -1;
                              Navigator.pop(context);
                            },
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              for (var el in activeNotes) {
                                _checkedElement?.note.add(el);
                                deleteMessages(events);
                              }
                              _checkedElement = null;
                              _checked = -1;
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
        !isEditMode
            ? IconButton(
                icon: const Icon(Icons.bookmark_added),
                onPressed: () {
                  isBookmarkedNoteMode ? false : true;
                },
              )
            : Container(),
        isEditMode
            ? IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  deleteMessages(events);
                  cancelEditMode();
                },
              )
            : Container(),
        isEditMode
            ? IconButton(
                icon: const Icon(Icons.bookmark_add),
                onPressed: () {},
              )
            : Container(),
        isEditMode
            ? IconButton(
                icon: const Icon(Icons.copy),
                onPressed: () {
                  var value = '';
                  for (var element in activeNotes) {
                    value += element.description;
                  }
                  addToClipboard(value);
                  cancelEditMode();
                },
              )
            : Container(),
        isEditMode && !isMultiSelection
            ? IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  isTextEditMode = true;
                  _textController.text = activeNotes[0].description;
                },
              )
            : Container(),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget noListView() {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            buildNote(),
            buildBottomContainer(null),
          ],
        ),
      ),
    );
  }

  Widget withListView(Journal events) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            buildListView(events),
            isChangingCategory ? buildCategories() : Container(),
            buildBottomContainer(events),
          ],
        ),
      ),
    );
  }

  Widget buildCategories() {
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
                  _selectedIcon = null;
                  isChangingCategory = !isChangingCategory;
                } else {
                  _selectedIcon = listOfEventsIcons[index];
                  isChangingCategory = !isChangingCategory;
                }
                setState(() {});
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

  Widget buildNote() {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxHeight: 250,
      ),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.yellowAccent,
          borderRadius: BorderRadius.all(Radius.circular(7)),
        ),
        margin: const EdgeInsets.all(15),
        padding: const EdgeInsets.all(15),
        child: Column(
          children: <Widget>[
            Text(
              'This is the page where you can track everything about ${widget.journal.title}!',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 17,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            Container(
              height: 20,
            ),
            Text(
              'Add your first event to "${widget.journal.title}" '
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
          ],
        ),
      ),
    );
  }

  Expanded buildListView(Journal events) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(10),
        child: ListView.builder(
          controller: _scrollController,
          reverse: false,
          itemCount: events.note.length,
          itemBuilder: (context, index) {
            return DismissibleWidget(
              onDismissed: (direction) => dismissItem(context, index, direction),
              item: events.note[index],
              child: NoteTile(
                onSelectedNote: selectedNotes,
                onSelected: (value) {
                  setState(() {
                    activeNotes.contains(value)
                        ? activeNotes.add(value)
                        : activeNotes.remove(value);
                  });
                  print(activeNotes);
                },
                onChangedMultiSelection: (value) {
                  setState(() {
                    isMultiSelection = value;
                  });
                },
                onChangedEditMode: (value) {
                  setState(() {
                    isEditMode = value;
                  });
                },
                note: events.note[index],
                isSelected: itContains(index, events),
                isEditMode: isEditMode,
              ),
            );
          },
        ),
      ),
    );
  }

  void dismissItem(
      BuildContext context,
      int index,
      DismissDirection direction,
      ) {
    setState(() {
      items.removeAt(index);
    });

    switch (direction) {
      case DismissDirection.endToStart:
        print('1');
        break;
      case DismissDirection.startToEnd:
        print('2');
        break;
      default:
        break;
    }
  }

  Align buildBottomContainer(Journal? events) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxHeight: 60,
        ),
        child: Row(
          children: <Widget>[
            IconButton(
              icon: _selectedIcon != null
                  ? Icon(_selectedIcon)
                  : const Icon(Icons.event),
              onPressed: () {
                isChangingCategory = !isChangingCategory;
                setState(() {});
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
            !isTextTyped
                ? IconButton(
                    icon: const Icon(Icons.camera_alt),
                    onPressed: () {},
                  )
                : IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: () => addMessageToList(),
                  ),
          ],
        ),
      ),
    );
  }

  int indexOfSelected(Journal data, Note element) => data.note.indexOf(element);

  void editEvent(int? index) {
    if (!isTextEditMode) {
      addMessageToList();
      setState(() {});
    } else {
      if (index == null) {
        var events = BlocProvider.of<JournalCubit>(context).state.toList();
        index = events[widget.index].note.indexOf(activeNotes[0]);
      }
      setState(() {
        JournalCubit()
          ..changeEvent(
            _textController.text,
            widget.index,
            index!,
          );
      });
      _textController.text = '';
      isTextEditMode = false;
      cancelEditMode();
    }
  }

  void addMessageToList() {
    var now = DateTime.now();
    var date = DateFormat('yyyy-MM-dd – kk:mm').format(now);
    JournalCubit()
      ..addEvent(
          Note(
            isBookmarked: false,
            time: date,
            description: inputText,
            icon: _selectedIcon,
          ),
          widget.index);
    moveToLastMessage();
    _selectedIcon = null;
    _textController.text = '';
    setState(() {});
  }

  void moveToLastMessage() {
    _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
  }

  void deleteMessages(Journal events) {
    for (var element in activeNotes) {
      BlocProvider.of<JournalCubit>(context)
        ..deleteEvent(widget.index, indexOfSelected(events, element));
    }
    activeNotes = [];
    setState(() {});
  }

  void cancelEditMode() {
    isEditMode = false;
    isMultiSelection = false;
    activeNotes.clear();
    setState(() {});
  }

  void addToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
  }

  void selectedNotes(Note note) {
    final isSelected = activeNotes.contains(note);
    isSelected ? activeNotes.remove(note) : activeNotes.add(note);
    isEditMode = activeNotes.isEmpty ? false : true;
    isMultiSelection = activeNotes.length > 1 ? true : false;
    setState(() {});
  }

  bool itContains(int index, Journal events) {
    return activeNotes.contains(events.note.elementAt(index)) ? true : false;
  }
}
