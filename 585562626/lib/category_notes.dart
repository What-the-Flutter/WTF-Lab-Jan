import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'constants.dart';
import 'models/category.dart';
import 'models/note.dart';
import 'widgets/note_item.dart';

class CategoryNotes extends StatefulWidget {
  final NoteCategory category;
  final List<Note> notes;

  const CategoryNotes({Key? key, required this.category, required this.notes}) : super(key: key);

  @override
  _CategoryNotesState createState() => _CategoryNotesState();
}

class _CategoryNotesState extends State<CategoryNotes> {
  late final List<Note> _notes = widget.notes;
  final List<Note> _selectedNotes = [];
  bool _isEditingMode = false;
  bool _startedUpdating = false;
  final _controller = TextEditingController();
  final _scrollController = ScrollController();

  void _switchEditingMode() {
    setState(() {
      var wasActive = _isEditingMode;
      _isEditingMode = !wasActive;
      if (wasActive) {
        _selectedNotes.clear();
        _startedUpdating = false;
        _controller.clear();
      }
    });
  }

  void _sendNote(AlignDirection direction) {
    var text = _controller.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        _notes.insert(0, Note(text, direction));
        _controller.clear();
      });
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          0.0,
          duration: const Duration(milliseconds: 500),
          curve: Curves.fastOutSlowIn,
        );
      }
    }
  }

  void _switchNoteSelection(Note note) {
    setState(() {
      if (_selectedNotes.contains(note)) {
        _selectedNotes.remove(note);
      } else {
        _selectedNotes.add(note);
      }
    });
  }

  void _deleteSelectedNotes() {
    setState(() {
      _notes.removeWhere(_selectedNotes.contains);
      _selectedNotes.clear();
      _isEditingMode = !_isEditingMode;
      _startedUpdating = false;
    });
  }

  void _startEditing() {
    _controller.text = _selectedNotes.first.text;
    setState(() => _startedUpdating = true);
  }

  void _updateNote() {
    setState(() {
      var updatedNote = _selectedNotes.first;
      updatedNote.updateText(_controller.text);
      _notes[_notes.indexOf(_selectedNotes.first)] = updatedNote;
      _controller.clear();
      _startedUpdating = false;
      _isEditingMode = false;
    });
  }

  void _copyToClipboard() {
    Clipboard.setData(ClipboardData(text: _selectedNotes.first.text));
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Text copied to clipboard')));
  }

  AppBar _appBar() {
    return AppBar(
      backgroundColor: _isEditingMode ? Theme.of(context).accentColor : Colors.white,
      centerTitle: !_isEditingMode,
      iconTheme: IconThemeData(
        color: _isEditingMode ? Colors.white : Theme.of(context).accentColor,
      ),
      leading: _isEditingMode
          ? IconButton(onPressed: _switchEditingMode, icon: const Icon(Icons.close))
          : IconButton(
              onPressed: () => Navigator.pop(context),
              icon: !kIsWeb && (Platform.isMacOS || Platform.isIOS)
                  ? const Icon(Icons.arrow_back_ios)
                  : const Icon(Icons.arrow_back),
            ),
      title: Text(
        _isEditingMode ? _selectedNotes.length.toString() : widget.category.name,
        style: TextStyle(color: _isEditingMode ? Colors.white : Theme.of(context).accentColor),
      ),
      actions: _isEditingMode
          ? [
              if (_selectedNotes.length == 1) ...[
                IconButton(
                  onPressed: _startEditing,
                  icon: const Icon(
                    Icons.mode_edit_outline,
                    color: Colors.white,
                  ),
                ),
                IconButton(
                  onPressed: _copyToClipboard,
                  icon: const Icon(
                    Icons.copy_outlined,
                    color: Colors.white,
                  ),
                ),
              ],
              IconButton(
                  onPressed: _deleteSelectedNotes,
                  icon: const Icon(
                    Icons.delete_outlined,
                    color: Colors.white,
                  )),
            ]
          : [
              IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
              const IconButton(onPressed: null, icon: Icon(Icons.bookmark_outline)),
            ],
    );
  }

  Widget _emptyNotesMessage() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(CornerRadius.card),
        color: Theme.of(context).accentColor.withAlpha(Alpha.alpha50),
      ),
      padding: const EdgeInsets.all(Insets.large),
      margin: const EdgeInsets.all(Insets.medium),
      child: Wrap(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: Insets.small),
                child: Text(
                  'This is the page where you can note everything about '
                  '${widget.category.name}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: FontSize.normal,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Text(
                'Add your first event to the page by entering some text in the text box '
                'below and hitting the send button. Long tap the send button to align the '
                'event in the opposite direction. Tap on the bookmark icon on the top right '
                'corner to show the bookmarked events only.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _bottomContainer() {
    return Container(
      color: Theme.of(context).primaryColor,
      child: SizedBox(
        height: 60,
        child: Row(
          children: [
            const IconButton(
              onPressed: null,
              icon: Icon(Icons.attach_file),
            ),
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Start typing...',
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Theme.of(context).accentColor),
                  ),
                ),
                controller: _controller,
              ),
            ),
            _startedUpdating
                ? IconButton(onPressed: _updateNote, icon: const Icon(Icons.done))
                : GestureDetector(
                    child: IconButton(
                      onPressed: () => _sendNote(AlignDirection.left),
                      icon: const Icon(Icons.send),
                    ),
                    onLongPress: () => _sendNote(AlignDirection.right),
                  ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              reverse: _notes.isNotEmpty,
              physics: const ClampingScrollPhysics(),
              controller: _scrollController,
              children: _notes.isEmpty
                  ? [_emptyNotesMessage()]
                  : _notes
                      .map((note) => NoteItem(
                            note: note,
                            isEditingMode: _isEditingMode,
                            isSelected: _selectedNotes.contains(note),
                            changeSelection: _switchNoteSelection,
                            activateEditingMode: _switchEditingMode,
                          ))
                      .toList(),
            ),
          ),
          _bottomContainer()
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
