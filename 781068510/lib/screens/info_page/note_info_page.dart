import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../../main.dart';
import '../../models/note_model.dart';
import 'info_note_tile.dart';

class NoteInfo extends StatefulWidget {
  final String title;
  final List<Note> listView;
  final bool isEditMode;
  final bool isMultiSelection;

  NoteInfo({
    required this.title,
    required this.listView,
    required this.isEditMode,
    required this.isMultiSelection,
    required Key key,
  }) : super(key: key);

  @override
  _NoteInfo createState() => _NoteInfo();
}

class _NoteInfo extends State<NoteInfo> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _textController = TextEditingController();

  List<Note> activeNotes = [];
  List<Note> allNotes = [];

  bool isEditMode = false;
  bool isMultiSelection = false;

  bool isTextEditMode = false;

  bool isBookmarkedNoteMode = false;

  String inputText = '';
  bool isTextTyped = false;

  void moveToLastMessage() {
    _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
  }

  void deleteMessages() {
    for (var element in activeNotes) {
      allNotes.remove(element);
    }
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

  void selectNotes(Note note) {
    final isSelected = activeNotes.contains(note);
    isSelected ? activeNotes.remove(note) : activeNotes.add(note);
    isEditMode = activeNotes.isEmpty ? false : true;
    isMultiSelection = activeNotes.length > 1 ? true : false;
    setState(() {});
  }

  bool itContains(int index) {
    return activeNotes.contains(allNotes.elementAt(index)) ? true : false;
  }

  void initText() {
    _textController.addListener(() {
      print('value: ${_textController.text}');
      setState(() {
        inputText = _textController.text;
        if (inputText.isEmpty) {
          isTextTyped = false;
        } else {
          isTextTyped = true;
        }
      });
    });
  }

  @override
  void initState() {
    allNotes = widget.listView;
    initText();
    print(allNotes);
    super.initState();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60), child: buildAppBar()),
      body: buildParam(),
    );
  }

  Widget buildAppBar() {
    final label = !isEditMode ? widget.title : '';
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
                onPressed: () {},
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
                  deleteMessages();
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

  Widget buildParam() {
    if (allNotes.isEmpty) {
      return noListView();
    } else {
      return withListView();
    }
  }

  Widget noListView() {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            buildNote(),
            buildBottomContainer(),
          ],
        ),
      ),
    );
  }

  Widget withListView() {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            buildListView(),
            buildBottomContainer(),
          ],
        ),
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
              'This is the page where you can track everything about ${widget.title}!',
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
              'Add your first event to "${widget.title}" '
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

  Expanded buildListView() {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(10),
        child: ListView.builder(
            controller: _scrollController,
            reverse: false,
            itemCount: allNotes.length,
            itemBuilder: (context, index) {
              return NoteTile(
                onSelectedNote: selectNotes,
                onSelected: (value) {
                  setState(
                    () {
                      activeNotes.contains(value)
                          ? activeNotes.add(value)
                          : activeNotes.remove(value);
                    },
                  );
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
                note: allNotes[index],
                isSelected: itContains(index),
                isEditMode: isEditMode,
              );
            }),
      ),
    );
  }

  Align buildBottomContainer() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxHeight: 60,
        ),
        child: Row(
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.event),
              onPressed: () {},
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
                    onPressed: () {
                      if (!isTextEditMode) {
                        addMessageToList();
                        moveToLastMessage();
                        setState(() {});
                      } else {
                        var index = allNotes.indexOf(activeNotes[0]);
                        setState(() {
                          allNotes[index].description = _textController.text;
                        });
                        _textController.text = '';
                        isTextEditMode = false;
                        cancelEditMode();
                      }
                    },
                  ),
          ],
        ),
      ),
    );
  }

  void addMessageToList() {
    var now = DateTime.now();
    var date = DateFormat('yyyy-MM-dd – kk:mm').format(now);
    notes[0]
        .note
        ?.add(Note(isBookmarked: false, time: date, description: inputText));
    _textController.text = '';
  }
}
