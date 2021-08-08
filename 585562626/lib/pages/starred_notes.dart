import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/note.dart';
import '../utils/constants.dart';
import '../widgets/note_item.dart';

class StarredNotesArguments {
  final List<BaseNote> notes;
  final Function(BaseNote)? deleteNote;

  StarredNotesArguments({required this.notes, this.deleteNote});
}

class StarredNotesPage extends StatefulWidget {
  final List<BaseNote> notes;
  final Function(BaseNote)? deleteNote;

  static const routeName = '/starred_notes';

  const StarredNotesPage({Key? key, required this.notes, this.deleteNote}) : super(key: key);

  @override
  _StarredNotesPageState createState() => _StarredNotesPageState();
}

class _StarredNotesPageState extends State<StarredNotesPage> {
  late final List<BaseNote> _notes = widget.notes;

  AppBar _appBar() {
    return AppBar(
      title: Text(
        'Starred notes',
        style: Theme.of(context).appBarTheme.titleTextStyle,
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, BaseNote note) {
    showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete note'),
          content: const Text('Are you sure you want to delete this note?'),
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
                print((note as TextNote).text);
                setState(() => _notes.remove(note));
                widget.deleteNote?.call(note);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: _notes.isEmpty
          ? const Center(
              child: Text(
                'Nothing starred yet.',
                style: TextStyle(fontSize: FontSize.big, fontWeight: FontWeight.bold),
              ),
            )
          : ListView(
              physics: const ClampingScrollPhysics(),
              children: _notes
                  .map((note) => NoteItem(
                        note: note,
                        isStarred: true,
                        onLongPress: (note) {
                          _showDeleteDialog(context, note);
                          HapticFeedback.mediumImpact();
                        },
                      ))
                  .toList(),
            ),
    );
  }
}
