import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../models/category.dart';
import '../../../repository/note_repository.dart';
import 'bloc/bloc.dart';
import 'bloc/starred_notes_bloc.dart';
import 'starred_notes_content.dart';

class StarredNotesArguments {
  final Category category;

  StarredNotesArguments({required this.category});
}

class StarredNotesPage extends StatelessWidget {
  final Category category;

  static const routeName = '/starred_notes';

  const StarredNotesPage({Key? key, required this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => StarredNotesBloc(
        const InitialStarredNotesState(),
        category: category,
        noteRepository: RepositoryProvider.of<NoteRepository>(context),
      )..add(const FetchStarredNotesEvent()),
      child: const StarredNotesContent(),
    );
  }
}
