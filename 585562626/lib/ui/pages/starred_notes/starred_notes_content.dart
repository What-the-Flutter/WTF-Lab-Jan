import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../models/note.dart';
import '../../../widgets/note_item.dart';
import 'bloc/bloc.dart';
import 'bloc/starred_notes_bloc.dart';

class StarredNotesContent extends StatefulWidget {
  const StarredNotesContent({Key? key}) : super(key: key);

  @override
  _StarredNotesContentState createState() => _StarredNotesContentState();
}

class _StarredNotesContentState extends State<StarredNotesContent> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  AppBar _appBar(FetchedStarredNotesState state) {
    return AppBar(
      leading: IconButton(
        onPressed: () => _onPop(state),
        icon: Platform.isIOS ? const Icon(Icons.arrow_back_ios) : const Icon(Icons.arrow_back),
      ),
      title: Text(
        'Starred notes',
        style: Theme.of(context).appBarTheme.titleTextStyle,
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, Note note) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text('Delete note'),
          content: const Text('Are you sure you want to delete this note?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel'.toUpperCase(),
                style: TextStyle(color: Theme.of(context).accentColor),
              ),
            ),
            TextButton(
              onPressed: () {
                context.read<StarredNotesBloc>().add(DeleteFromStarredNotesEvent(note));
                Navigator.pop(context);
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

  Future<bool> _onPop(FetchedStarredNotesState state) async {
    Navigator.pop(context, state.deleteAt != null);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<StarredNotesBloc, StarredNotesState>(
      listener: (context, state) {
        if (state is FetchedStarredNotesState) {
          if (state.deleteAt != null) {
            _listKey.currentState?.removeItem(
              state.deleteAt!,
              (context, animation) => FadeTransition(
                opacity: animation,
                child: NoteItem(
                  note: state.noteToDelete!,
                  isStarred: false,
                ),
              ),
              duration: const Duration(milliseconds: 300),
            );
          }
        }
      },
      builder: (context, state) {
        if (state is FetchingStarredNotesState) {
          return Center(
            child: CircularProgressIndicator(color: Theme.of(context).accentColor),
          );
        }
        final currentState = state as FetchedStarredNotesState;
        return WillPopScope(
          onWillPop: () => _onPop(currentState),
          child: Scaffold(
            appBar: _appBar(currentState),
            body: currentState.notes.isEmpty
                ? Center(
                    child: Text(
                      'Nothing starred yet.',
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                  )
                : AnimatedList(
                    key: _listKey,
                    initialItemCount: currentState.notes.length,
                    physics: const ClampingScrollPhysics(),
                    itemBuilder: (context, i, animation) {
                      return NoteItem(
                        note: currentState.notes[i],
                        isStarred: true,
                        onLongPress: (note) {
                          _showDeleteDialog(context, note);
                          HapticFeedback.mediumImpact();
                        },
                      );
                    },
                  ),
          ),
        );
      },
    );
  }
}
