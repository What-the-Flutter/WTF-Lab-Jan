import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../models/category.dart';
import '../../../repository/note_repository.dart';
import 'bloc/bloc.dart';
import 'category_notes_content.dart';

class CategoryNotesArguments {
  final Category category;

  CategoryNotesArguments({required this.category});
}

class CategoryNotesPage extends StatelessWidget {
  final Category category;
  static const routeName = '/categoryNotes';

  const CategoryNotesPage({Key? key, required this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CategoryNotesBloc(
        CategoryNotesState(category: category),
        noteRepository: RepositoryProvider.of<NoteRepository>(context),
      )..add(const FetchNotesEvent()),
      child: const CategoryNotesContent(),
    );
  }
}
