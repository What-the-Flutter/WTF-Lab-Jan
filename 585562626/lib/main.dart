import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'repository/category_repository.dart';
import 'repository/note_repository.dart';
import 'simple_bloc_observer.dart';
import 'ui/app/app.dart';

void main() {
  Bloc.observer = SimpleBlocObserver();
  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider<CategoryRepository>(
          create: (context) => CategoryRepository(),
        ),
        RepositoryProvider<NoteRepository>(
          create: (context) => NoteRepository(),
        ),
      ],
      child: const App(),
    ),
  );
}
