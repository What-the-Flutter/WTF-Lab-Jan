import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/note.dart';
import '../../utils/constants.dart';
import '../../widgets/note_item.dart';
import 'bloc/bloc.dart';
import 'bloc/starred_notes_bloc.dart';

class StarredNotesContent extends StatefulWidget {
  const StarredNotesContent({Key? key}) : super(key: key);

  @override
  _StarredNotesContentState createState() => _StarredNotesContentState();
}

class _StarredNotesContentState extends State<StarredNotesContent> {
  AppBar _appBar(FetchedStarredNotesState state) {
    return AppBar(
      leading: IconButton(
        onPressed: () => Navigator.pop(context, state.switchedStar),
        icon: !kIsWeb && (Platform.isMacOS || Platform.isIOS)
            ? const Icon(Icons.arrow_back_ios)
            : const Icon(Icons.arrow_back),
      ),
      title: Text(
        'Starred notes',
        style: Theme.of(context).appBarTheme.titleTextStyle,
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, Note note, FetchedStarredNotesState state) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text('Delete note'),
          content: const Text('Are you sure you want to delete this note?'),
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
                context.read<StarredNotesBloc>().add(DeleteFromStarredNotesEvent(note));
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
    return BlocBuilder<StarredNotesBloc, StarredNotesState>(
      builder: (context, state) {
        if (state is FetchingStarredNotesState) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        final currentState = state as FetchedStarredNotesState;
        return Scaffold(
          appBar: _appBar(currentState),
          body: currentState.notes.isEmpty
              ? const Center(
                  child: Text(
                    'Nothing starred yet.',
                    style: TextStyle(fontSize: FontSize.big, fontWeight: FontWeight.bold),
                  ),
                )
              : ListView(
                  physics: const ClampingScrollPhysics(),
                  children: currentState.notes
                      .map((note) => NoteItem(
                            note: note,
                            isStarred: true,
                            onLongPress: (note) {
                              _showDeleteDialog(context, note, currentState);
                              HapticFeedback.mediumImpact();
                            },
                          ))
                      .toList(),
                ),
        );
      },
    );
  }
}
