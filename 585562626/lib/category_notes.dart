import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import 'constants.dart';
import 'models/category.dart';
import 'models/note.dart';
import 'widgets/badge.dart';
import 'widgets/note_item.dart';

class CategoryNotes extends StatefulWidget {
  final NoteCategory category;
  final List<BaseNote> notes;

  const CategoryNotes({Key? key, required this.category, required this.notes}) : super(key: key);

  @override
  _CategoryNotesState createState() => _CategoryNotesState();
}

class _CategoryNotesState extends State<CategoryNotes> {
  late final List<BaseNote> _notes = widget.notes;
  final List<BaseNote> _selectedNotes = [];
  bool _isEditingMode = false;
  bool _startedUpdating = false;
  PickedFile? _image;

  final _controller = TextEditingController();
  final _scrollController = ScrollController();

  void _takePhoto() async {
    if (await Permission.camera.request().isGranted) {
      var image = await ImagePicker().getImage(source: ImageSource.camera, imageQuality: 50);
      setState(() => _image = image);
    }
  }

  void _pickFromGallery() async {
    if (await Permission.photos.request().isGranted) {
      var image = await ImagePicker().getImage(source: ImageSource.gallery, imageQuality: 50);
      setState(() => _image = image);
    }
  }

  void _showPicker() {
    showModalBottomSheet(
        context: context,
        builder: (_) {
          return Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library_outlined),
                title: const Text('Photo Library'),
                onTap: () {
                  _pickFromGallery();
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera_outlined),
                title: const Text('Camera'),
                onTap: () {
                  _takePhoto();
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

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
    setState(() {
      var image = _image;
      if (image != null) {
        _notes.insert(0, ImageNote(image.path, direction));
        _image = null;
      }
      if (text.isNotEmpty) {
        _notes.insert(0, TextNote(text, direction));
        _controller.clear();
      }
    });
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0.0,
        duration: const Duration(milliseconds: 500),
        curve: Curves.fastOutSlowIn,
      );
    }
  }

  void _switchNoteSelection(BaseNote note) {
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
    var updatedNote = _selectedNotes.first;
    if (updatedNote is TextNote) {
      _controller.text = updatedNote.text;
    }
    if (updatedNote is ImageNote) {
      _showPicker();
    }
    setState(() => _startedUpdating = true);
  }

  void _updateNote() {
    setState(() {
      var updatedNote = _selectedNotes.first;
      if (updatedNote is TextNote) {
        updatedNote.updateText(_controller.text);
        _notes[_notes.indexOf(_selectedNotes.first)] = updatedNote;
        _controller.clear();
        _startedUpdating = false;
      }
      if (updatedNote is ImageNote) {
        var image = _image;
        if (image != null) {
          updatedNote.image = image.path;
          _notes[_notes.indexOf(_selectedNotes.first)] = updatedNote;
          _image = null;
        }
      }
      _isEditingMode = false;
      _selectedNotes.clear();
    });
  }

  void _copyToClipboard() {
    var selectedNote = _selectedNotes.first;
    if (selectedNote is TextNote) {
      Clipboard.setData(ClipboardData(text: selectedNote.text));
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Text copied to clipboard')));
    }
  }

  void _showDeleteDialog() {
    showDialog<String>(
      context: context,
      builder: (context) {
        var count = _selectedNotes.length;
        return AlertDialog(
          title: count > 1 ? Text('Delete $count notes') : const Text('Delete note'),
          content: Text('Are you sure you want to delete '
              ' ${count > 1 ? 'these notes' : 'this note'}?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'Cancel'),
              child: Text(
                'Cancel'.toUpperCase(),
                style: TextStyle(color: Theme.of(context).accentColor),
              ),
            ),
            TextButton(
              onPressed: () {
                _deleteSelectedNotes();
                Navigator.pop(context, 'Delete');
              },
              child: Text(
                'Delete'.toUpperCase(),
                style: const TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
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
                  icon: const Icon(Icons.mode_edit_outline, color: Colors.white),
                ),
                IconButton(
                  onPressed: _copyToClipboard,
                  icon: const Icon(Icons.copy_outlined, color: Colors.white),
                ),
              ],
              IconButton(
                onPressed: _showDeleteDialog,
                icon: const Icon(Icons.delete_outlined, color: Colors.white),
              ),
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
            Badge(
              visible: _image != null,
              top: 6,
              right: 12,
              child: IconButton(
                onPressed: _showPicker,
                icon: const Icon(Icons.attach_file),
              ),
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
