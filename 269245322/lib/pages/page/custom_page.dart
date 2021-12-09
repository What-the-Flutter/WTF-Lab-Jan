import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../objects/note_object.dart';
import '../../objects/page_object.dart';
import 'note_input.dart';

class CustomPage extends StatefulWidget {
  late final PageObject page;
  CustomPage({Key? key}) : super(key: key);

  static const routeName = '/customPage';

  @override
  _CustomPageState createState() => _CustomPageState();
}

class _CustomPageState extends State<CustomPage> {
  bool idkHowToDoAnotherWay = false;
  late String _nodeInput;
  bool _editIconClicked = false;
  final List<NoteObject> _selcetedNotes = [];

  final TextEditingController _controller = TextEditingController();

  void addNoteToList() {
    late String nodeInput;
    widget.page.numOfNotes++;
    nodeInput = _controller.text;
    var note =
        NoteObject(heading: widget.page.numOfNotes.toString(), data: nodeInput);
    setState(() {
      _editIconClicked
          ? _selcetedNotes.first.data = _controller.text
          : widget.page.notesList.add(note);
    });
    widget.page.lastModifedDate = DateTime.now();
    _editIconClicked = false;
    _controller.text = '';
    makeAllNotesSelected(false);
  }

  void editNote() {
    _controller.text = _selcetedNotes.first.data;
    _editIconClicked = true;
  }

  void deleteFromNoteList() {
    setState(() {
      for (var currentNote in _selcetedNotes) {
        widget.page.notesList.remove(currentNote);
      }
    });
    makeAllNotesSelected(false);
  }

  void addNoteToFavorite() {
    for (var currentNote in _selcetedNotes) {
      setState(() {
        currentNote.isFavorite == false
            ? currentNote.isFavorite = true
            : currentNote.isFavorite = false;
      });
    }
    makeAllNotesSelected(false);
  }

  void makeAllNotesSelected(bool selectAll) {
    for (var currentNote in widget.page.notesList) {
      _selcetedNotes.add(currentNote);
      setState(() {
        if (selectAll) {
          currentNote.isChecked = true;
        } else {
          currentNote.isChecked = false;
        }
      });
    }
    if (!selectAll) _selcetedNotes.clear();
  }

  void copyDataToBuffer() {
    var bufferData = '';
    for (var currentNote in _selcetedNotes) {
      bufferData += '${currentNote.data} ';
    }
    Clipboard.setData(ClipboardData(text: bufferData));
    makeAllNotesSelected(false);
  }

  @override
  Widget build(BuildContext context) {
    if (idkHowToDoAnotherWay != true) {
      widget.page = ModalRoute.of(context)!.settings.arguments as PageObject;
      idkHowToDoAnotherWay = true;
    }
    return Scaffold(
      appBar: AppBar(
          title: Center(child: Text(widget.page.title)),
          actions: _selcetedNotes.isNotEmpty
              ? <Widget>[
                  IconButton(
                    icon: const Icon(Icons.select_all),
                    onPressed: () => makeAllNotesSelected(true),
                  ),
                  IconButton(
                    icon: const Icon(Icons.star),
                    onPressed: addNoteToFavorite,
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: deleteFromNoteList,
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: _selcetedNotes.length == 1 ? editNote : null,
                  ),
                  IconButton(
                    icon: const Icon(Icons.copy),
                    onPressed: copyDataToBuffer,
                  ),
                ]
              : <Widget>[]),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: widget.page.notesList.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 1.0, horizontal: 4.0),
                  child: Card(
                    child: ListTile(
                      key: ValueKey(widget.page.notesList[index].heading),
                      leading: Icon(
                        widget.page.icon,
                      ),
                      title: Text(
                        'Node ${widget.page.notesList[index].heading}',
                        style: TextStyle(
                            color: widget.page.notesList[index].isFavorite
                                ? Colors.green
                                : Colors.black),
                      ),
                      subtitle: Text(widget.page.notesList[index].data),
                      isThreeLine: widget.page.notesList[index].data.length > 30
                          ? true
                          : false,
                      trailing: Checkbox(
                        key: UniqueKey(),
                        checkColor: Colors.white,
                        value: widget.page.notesList[index].isChecked,
                        onChanged: (value) {
                          setState(() {
                            widget.page.notesList[index].isChecked = value!;
                          });
                          if (value == true) {
                            _selcetedNotes.add(widget.page.notesList[index]);
                          } else {
                            _selcetedNotes.remove(widget.page.notesList[index]);
                          }
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          NoteInput(
            selectHandler: addNoteToList,
            controller: _controller,
          ),
        ],
      ),
    );
  }
}
