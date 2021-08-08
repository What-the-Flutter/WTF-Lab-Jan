import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../models/category.dart';
import '../models/note.dart';
import '../utils/constants.dart';
import '../widgets/badge.dart';
import '../widgets/note_item.dart';
import 'starred_notes.dart';

class CategoryNotesArguments {
  final NoteCategory category;
  final List<BaseNote> notes;

  CategoryNotesArguments({required this.category, required this.notes});
}

class CategoryNotesPage extends StatefulWidget {
  final NoteCategory category;
  final List<BaseNote> notes;

  static const routeName = '/categoryNotes';

  const CategoryNotesPage({Key? key, required this.category, required this.notes})
      : super(key: key);

  @override
  _CategoryNotesPageState createState() => _CategoryNotesPageState();
}

class _CategoryNotesPageState extends State<CategoryNotesPage> {
  late final List<BaseNote> _notes = widget.notes;
  final List<BaseNote> _selectedNotes = [];
  final List<BaseNote> _starredNotes = [];
  bool _isEditingMode = false;
  bool _startedUpdating = false;
  PickedFile? _image;
  final FocusNode _inputFieldFocusNode = FocusNode();

  final _textController = TextEditingController();
  final _scrollController = ScrollController();

  void _switchStar() {
    setState(() {
      for (final note in _selectedNotes) {
        if (_starredNotes.contains(note)) {
          _starredNotes.remove(note);
        } else {
          _starredNotes.add(note);
        }
      }
    });
  }

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
        _textController.clear();
      }
    });
  }

  void _sendNote(AlignDirection direction) {
    var text = _textController.text.trim();
    setState(() {
      var image = _image;
      if (image != null) {
        _notes.insert(0, ImageNote(image.path, direction));
        _image = null;
      }
      if (text.isNotEmpty) {
        _notes.insert(0, TextNote(text, direction));
        _textController.clear();
      }
    });
    FocusScope.of(context).requestFocus(_inputFieldFocusNode);
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
      _textController.text = updatedNote.text;
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
        updatedNote.updateText(_textController.text);
        _notes[_notes.indexOf(_selectedNotes.first)] = updatedNote;
        _textController.clear();
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
      backgroundColor:
          _isEditingMode ? Theme.of(context).accentColor : Theme.of(context).primaryColor,
      centerTitle: !_isEditingMode,
      iconTheme: IconThemeData(
        color: _isEditingMode
            ? Theme.of(context).accentIconTheme.color
            : Theme.of(context).accentColor,
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
        _isEditingMode ? _selectedNotes.length.toString() : widget.category.name ?? '',
        style: TextStyle(
          color: _isEditingMode
              ? Theme.of(context).accentIconTheme.color
              : Theme.of(context).accentColor,
        ),
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
                onPressed: _switchStar,
                icon: const Icon(Icons.star_outline, color: Colors.white),
              ),
              IconButton(
                onPressed: _showDeleteDialog,
                icon: const Icon(Icons.delete_outlined, color: Colors.white),
              ),
            ]
          : [
              const IconButton(onPressed: null, icon: Icon(Icons.search)),
              IconButton(onPressed: _navigateToStarredNotes, icon: const Icon(Icons.star)),
            ],
    );
  }

  void _deleteStarredNote(BaseNote note) {
    setState(() => _starredNotes.remove(note));
  }

  void _navigateToStarredNotes() {
    Navigator.of(context).pushNamed(
      StarredNotesPage.routeName,
      arguments: StarredNotesArguments(notes: _starredNotes, deleteNote: _deleteStarredNote),
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
                    style: Theme.of(context).textTheme.bodyText1),
              ),
              Text(
                  'Add your first event to the page by entering some text in the text box '
                  'below and hitting the send button. Long tap the send button to align the '
                  'event in the opposite direction. Tap on the bookmark icon on the top right '
                  'corner to show the bookmarked events only.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyText2),
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
                autofocus: false,
                textInputAction: TextInputAction.send,
                maxLines: 3,
                minLines: 1,
                focusNode: _inputFieldFocusNode,
                onSubmitted: (_) => _sendNote(AlignDirection.left),
                style: Theme.of(context).textTheme.bodyText2?.copyWith(fontSize: FontSize.big),
                decoration: InputDecoration(
                  hintText: 'Start typing...',
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Theme.of(context).accentColor),
                  ),
                ),
                controller: _textController,
              ),
            ),
            _startedUpdating
                ? IconButton(onPressed: _updateNote, icon: const Icon(Icons.done))
                : GestureDetector(
                    child: IconButton(
                      onPressed: () => _sendNote(AlignDirection.left),
                      icon: const Icon(Icons.send),
                    ),
                    onLongPress: () {
                      _sendNote(AlignDirection.right);
                      HapticFeedback.mediumImpact();
                    },
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
                      .map(
                        (note) => NoteItem(
                          note: note,
                          isEditingMode: _isEditingMode,
                          isStarred: _starredNotes.contains(note),
                          isSelected: _selectedNotes.contains(note),
                          onTap: _switchNoteSelection,
                          onLongPress: (_) {
                            _switchEditingMode();
                            HapticFeedback.mediumImpact();
                          },
                        ),
                      )
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
    _textController.dispose();
    _scrollController.dispose();
    _inputFieldFocusNode.dispose();
    super.dispose();
  }
}
