import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'constants.dart';
import 'models/category.dart';
import 'models/note.dart';
import 'widgets/note_item.dart';

class CategoryNotes extends StatefulWidget {
  final Category category;
  final List<Note> notes;

  const CategoryNotes({Key? key, required this.category, required this.notes}) : super(key: key);

  @override
  _CategoryNotesState createState() => _CategoryNotesState();
}

class _CategoryNotesState extends State<CategoryNotes> {
  late final List<Note> _notes = widget.notes;
  final _controller = TextEditingController();
  final _scrollController = ScrollController();

  void _sendNote(AlignDirection direction) async {
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
                  hintText: 'Start typing..',
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Theme.of(context).accentColor),
                  ),
                ),
                controller: _controller,
              ),
            ),
            GestureDetector(
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
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        iconTheme: IconThemeData(color: Theme.of(context).accentColor),
        title: Text(
          widget.category.name,
          style: TextStyle(color: Theme.of(context).accentColor),
        ),
        actions: [
          const IconButton(onPressed: null, icon: Icon(Icons.search)),
          const IconButton(onPressed: null, icon: Icon(Icons.bookmark_outline)),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              reverse: _notes.isNotEmpty,
              physics: const ClampingScrollPhysics(),
              controller: _scrollController,
              children: _notes.isEmpty
                  ? [_emptyNotesMessage()]
                  : _notes.map((note) => NoteItem(note: note)).toList(),
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
