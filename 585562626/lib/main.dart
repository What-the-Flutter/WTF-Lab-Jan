import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'repository/category_repository.dart';
import 'repository/database/database_provider.dart';
import 'repository/note_repository.dart';
import 'repository/preferences_provider.dart';
import 'simple_bloc_observer.dart';
import 'ui/app/app.dart';

void main() async {
  Bloc.observer = SimpleBlocObserver();
  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider<CategoryRepository>(
          create: (_) => CategoryRepository(DbProvider.dbProvider),
        ),
        RepositoryProvider<NoteRepository>(create: (_) => NoteRepository(DbProvider.dbProvider)),
        RepositoryProvider<PreferencesProvider>(create: (_) => PreferencesProvider.prefsProvider),
      ],
      child: const App(),
    ),
  );
}
