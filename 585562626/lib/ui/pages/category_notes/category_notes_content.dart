import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:hashtagable/hashtagable.dart';

import '../../../models/note.dart';
import '../../../utils/constants.dart';
import '../../../widgets/badge.dart';
import '../../../widgets/category_item.dart';
import '../../../widgets/note_item.dart';
import '../category_notes/bloc/bloc.dart';
import '../starred_notes/starred_notes_page.dart';
import 'search/bloc/bloc.dart';
import 'search/note_search.dart';

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

  void _showCategoryPicker(CategoryNotesState state) async {
    await showModalBottomSheet(
      context: context,
      builder: (_) {
        if (state.existingCategories == null) {
          return Center(child: CircularProgressIndicator(color: Theme.of(context).accentColor));
        }
        final selectedCategory = state.tempCategory ?? state.category;
        return Wrap(children: [
          Center(
            child: GridView.count(
              padding: const EdgeInsets.all(Insets.medium),
              shrinkWrap: true,
              crossAxisCount: 3,
              mainAxisSpacing: Insets.xsmall,
              crossAxisSpacing: Insets.xsmall,
              childAspectRatio: 1.0,
              children: state.existingCategories!
                  .map(
                    (category) => Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(CornerRadius.card),
                        border: Border.all(
                          width: 2,
                          color: selectedCategory.id == category.id
                              ? Theme.of(context).accentColor
                              : Theme.of(context).scaffoldBackgroundColor,
                        ),
                        color: selectedCategory.id == category.id
                            ? Theme.of(context).accentColor.withAlpha(Alpha.alpha50)
                            : null,
                      ),
                      child: CategoryItem(
                        category: category,
                        onTap: (category) {
                          _bloc.add(CategorySelectedEvent(category));
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ]);
      },
    );
    _bloc.add(const CategoryPickerClosedEvent());
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
          actions: [
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
              icon:
                  Platform.isIOS ? const Icon(Icons.arrow_back_ios) : const Icon(Icons.arrow_back),
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
              IconButton(
                onPressed: () => _bloc.add(const OpenSearchEvent()),
                icon: const Icon(Icons.search),
              ),
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
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ),
              Text(
                'Add your first event to the page by entering some text in the text box '
                'below and hitting the send button. Long tap the send button to align the '
                'event in the opposite direction. Tap on the bookmark icon on the top right '
                'corner to show the bookmarked events only.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyText2,
              ),
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
            IconButton(
              padding: const EdgeInsets.only(right: Insets.small),
              constraints: const BoxConstraints(maxWidth: 32),
              onPressed: !state.isEditingMode || state.startedUpdating
                  ? () => _bloc.add(const ShowCategoriesEvent())
                  : null,
              disabledColor: Colors.red,
              icon: Icon(
                Icons.auto_awesome,
                color: !state.isEditingMode || state.startedUpdating
                    ? (state.tempCategory != null && state.tempCategory != state.category
                        ? Colors.amberAccent
                        : Theme.of(context).iconTheme.color)
                    : Colors.grey,
              ),
            ),
            Expanded(
              child: HashTagTextField(
                autofocus: false,
                textInputAction: TextInputAction.send,
                maxLines: 3,
                minLines: 1,
                focusNode: _inputFieldFocusNode,
                onSubmitted: (_) => _sendNote(AlignDirection.left),
                basicStyle: Theme.of(context).textTheme.bodyText2!.copyWith(
                      fontSize: Theme.of(context).textTheme.bodyText2!.fontSize! + 2,
                    ),
                decoratedStyle: Theme.of(context).textTheme.bodyText2!.copyWith(
                      fontSize: Theme.of(context).textTheme.bodyText2!.fontSize! + 2,
                      color: Theme.of(context).accentColor,
                    ),
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

  void _showTimePicker(Note note) async {
    final accentColor = Theme.of(context).accentColor;
    final pickerThemeData = Theme.of(context).copyWith(
      colorScheme: Theme.of(context).colorScheme.copyWith(
            primary: accentColor,
            onPrimary: Theme.of(context).primaryColor,
            onSurface: Theme.of(context).textTheme.bodyText2!.color!,
          ),
    );
    final dateResult = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now(),
      builder: (_, child) => Theme(data: pickerThemeData, child: child!),
    );
    if (dateResult != null) {
      final timeResult = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
        builder: (_, child) => Theme(data: pickerThemeData, child: child!),
      );
      if (timeResult != null) {
        _bloc.add(
          UpdateNoteDateEvent(
            note: note,
            dateTime: DateTime(
              dateResult.year,
              dateResult.month,
              dateResult.day,
              timeResult.hour,
              timeResult.minute,
            ),
          ),
        );
      }
    }
  }

  void _showSearch(CategoryNotesState state) async {
    await showSearch(
      context: context,
      delegate: NoteSearch(context, context.read<SearchBloc>(), state.notes, state.tags),
    );
    _bloc.add(const OpenSearchClosedEvent());
  }

  Widget _content(CategoryNotesState state) {
    return Expanded(
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
                    originDirection: !state.isRightAlignmentEnabled,
                    isEditingMode: state.isEditingMode,
                    isStarred: note.hasStar,
                    isSelected: state.selectedNotes.contains(note),
                    onTap: _switchNoteSelection,
                    onLongPress: (_) {
                      _switchEditingMode();
                      HapticFeedback.mediumImpact();
                    },
                    onTimeTap: state.isDateTimeModificationEnabled ? _showTimePicker : null,
                  ),
                )
                .toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CategoryNotesBloc, CategoryNotesState>(
      listener: (_, state) {
        if (state.showImagePicker) {
          _showPicker();
        }
        if (state.text != _textController.text) {
          _textController.text = state.text ?? _textController.text;
          _textController.selection = TextSelection.fromPosition(
            TextPosition(offset: _textController.text.length),
          );
        }
        if (state.showCategoryPicker) {
          _showCategoryPicker(state);
        }
        if (state.showSearch) {
          _showSearch(state);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: _appBar(state),
          body: Column(
            children: [_content(state), _bottomContainer(state)],
          ),
        );
      },
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
