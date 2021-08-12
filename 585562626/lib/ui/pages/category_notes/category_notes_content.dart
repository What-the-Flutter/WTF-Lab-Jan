import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../models/note.dart';
import '../../../utils/constants.dart';
import '../../../widgets/badge.dart';
import '../../../widgets/note_item.dart';
import '../category_notes/bloc/bloc.dart';
import '../starred_notes/starred_notes_page.dart';

class CategoryNotesContent extends StatefulWidget {
  static const routeName = '/categoryNotes';

  const CategoryNotesContent({Key? key}) : super(key: key);

  @override
  _CategoryNotesContentState createState() => _CategoryNotesContentState();
}

class _CategoryNotesContentState extends State<CategoryNotesContent> {
  late final CategoryNotesBloc _bloc;
  final FocusNode _inputFieldFocusNode = FocusNode();

  final _textController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _bloc = context.read();
  }

  void _switchStar() {
    _bloc.add(const SwitchStarEvent());
  }

  void _takePhoto() async {
    if (await Permission.camera.request().isGranted) {
      final image = await ImagePicker().getImage(source: ImageSource.camera, imageQuality: 50);
      if (image != null) _bloc.add(ImageSelectedEvent(image));
    }
  }

  void _pickFromGallery() async {
    if (await Permission.photos.request().isGranted) {
      final image = await ImagePicker().getImage(source: ImageSource.gallery, imageQuality: 50);
      if (image != null) _bloc.add(ImageSelectedEvent(image));
    }
  }

  void _showPicker() async {
    await showModalBottomSheet(
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
      },
    );
    _bloc.add(const ImagePickerClosedEvent());
  }

  void _switchEditingMode() {
    _bloc.add(const SwitchEditingModeEvent());
  }

  void _sendNote(AlignDirection direction) {
    _bloc.add(AddNoteEvent(direction: direction));
    FocusScope.of(context).requestFocus(_inputFieldFocusNode);
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0.0,
        duration: const Duration(milliseconds: 500),
        curve: Curves.fastOutSlowIn,
      );
    }
  }

  void _switchNoteSelection(Note note) {
    _bloc.add(SwitchNoteSelectionEvent(note));
  }

  void _deleteSelectedNotes() {
    _bloc.add(const DeleteSelectedNotesEvent());
  }

  void _startEditing() {
    _bloc.add(const StartEditingEvent());
  }

  void _updateNote() {
    _bloc.add(const UpdateNoteEvent());
  }

  void _copyToClipboard(CategoryNotesState state) {
    final selectedNote = state.selectedNotes.first;
    Clipboard.setData(ClipboardData(text: selectedNote.text));
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Text copied to clipboard')));
  }

  void _showDeleteDialog(CategoryNotesState state) {
    showDialog<String>(
      context: context,
      builder: (context) {
        final count = state.selectedNotes.length;
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

  AppBar _appBar(CategoryNotesState state) {
    return AppBar(
      backgroundColor:
          state.isEditingMode ? Theme.of(context).accentColor : Theme.of(context).primaryColor,
      centerTitle: !state.isEditingMode,
      iconTheme: IconThemeData(
        color: state.isEditingMode
            ? Theme.of(context).accentIconTheme.color
            : Theme.of(context).accentColor,
      ),
      leading: state.isEditingMode
          ? IconButton(onPressed: _switchEditingMode, icon: const Icon(Icons.close))
          : IconButton(
              onPressed: () => Navigator.pop(context),
              icon: !kIsWeb && (Platform.isMacOS || Platform.isIOS)
                  ? const Icon(Icons.arrow_back_ios)
                  : const Icon(Icons.arrow_back),
            ),
      title: Text(
        state.isEditingMode ? state.selectedNotes.length.toString() : state.category.name ?? '',
        style: TextStyle(
          color: state.isEditingMode
              ? Theme.of(context).accentIconTheme.color
              : Theme.of(context).accentColor,
        ),
      ),
      actions: state.isEditingMode
          ? [
              if (state.selectedNotes.length == 1) ...[
                IconButton(
                  onPressed: _startEditing,
                  icon: const Icon(Icons.mode_edit_outline, color: Colors.white),
                ),
                IconButton(
                  onPressed: () => _copyToClipboard(state),
                  icon: const Icon(Icons.copy_outlined, color: Colors.white),
                ),
              ],
              IconButton(
                onPressed: _switchStar,
                icon: const Icon(Icons.star_outline, color: Colors.white),
              ),
              IconButton(
                onPressed: () => _showDeleteDialog(state),
                icon: const Icon(Icons.delete_outlined, color: Colors.white),
              ),
            ]
          : [
              const IconButton(onPressed: null, icon: Icon(Icons.search)),
              IconButton(
                onPressed: () => _navigateToStarredNotes(state),
                icon: const Icon(Icons.star),
              ),
            ],
    );
  }

  void _navigateToStarredNotes(CategoryNotesState state) async {
    final result = await Navigator.of(context).pushNamed(
      StarredNotesPage.routeName,
      arguments: StarredNotesArguments(category: state.category),
    );
    if (result != null && result is bool && result) {
      _bloc.add(const FetchNotesEvent());
    }
  }

  Widget _emptyNotesMessage(CategoryNotesState state) {
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
                    '${state.category.name}',
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

  Widget _bottomContainer(CategoryNotesState state) {
    return Container(
      color: Theme.of(context).primaryColor,
      child: SizedBox(
        height: 60,
        child: Row(
          children: [
            Badge(
              visible: state.image != null,
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
                onChanged: (text) => _bloc.add(TextChangedEvent(text)),
              ),
            ),
            state.startedUpdating
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
    return BlocListener<CategoryNotesBloc, CategoryNotesState>(
      listener: (context, state) {
        if (state.showImagePicker) {
          _showPicker();
        }
        if (state.text != _textController.text) {
          _textController.text = state.text ?? _textController.text;
          _textController.selection = TextSelection.fromPosition(
            TextPosition(offset: _textController.text.length),
          );
        }
      },
      child: BlocBuilder<CategoryNotesBloc, CategoryNotesState>(
        builder: (context, state) {
          return Scaffold(
            appBar: _appBar(state),
            body: Column(
              children: [
                Expanded(
                  child: ListView(
                    reverse: state.notes.isNotEmpty,
                    physics: const ClampingScrollPhysics(),
                    controller: _scrollController,
                    children: state.notes.isEmpty
                        ? [_emptyNotesMessage(state)]
                        : state.notes
                            .map(
                              (note) => NoteItem(
                                note: note,
                                isEditingMode: state.isEditingMode,
                                isStarred: note.hasStar,
                                isSelected: state.selectedNotes.contains(note),
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
                _bottomContainer(state)
              ],
            ),
          );
        },
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
