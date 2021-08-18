import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../repository/note_repository.dart';
import 'bloc/bloc.dart';
import 'bloc/timeline_bloc.dart';
import 'timeline_content.dart';

class TimelinePage extends StatelessWidget {
  const TimelinePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TimelineBloc(
        const InitialNotesState(),
        noteRepository: RepositoryProvider.of<NoteRepository>(context),
      )..add(const FetchNotesEvent()),
      child: const TimelineContent(),
    );
  }
}
