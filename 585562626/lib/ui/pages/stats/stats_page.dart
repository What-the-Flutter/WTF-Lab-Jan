import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../repository/note_repository.dart';
import 'bloc/bloc.dart';
import 'bloc/stats_bloc.dart';
import 'stats_content.dart';

class StatsPage extends StatelessWidget {
  const StatsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => StatsBloc(
        const InitialDataState(),
        noteRepository: RepositoryProvider.of<NoteRepository>(context),
      )..add(const FetchDataEvent()),
      child: const StatsContent(),
    );
  }
}
