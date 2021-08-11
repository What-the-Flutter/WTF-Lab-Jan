import 'dart:io';

import 'package:cool_notes/repository/note_repository.dart';
import 'package:cool_notes/ui/category_notes/bloc/bloc.dart';
import 'package:cool_notes/ui/category_notes/category_notes_content.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../models/category.dart';
import '../../models/note.dart';
import '../../utils/constants.dart';
import '../../widgets/badge.dart';
import '../../widgets/note_item.dart';
import '../starred_notes/starred_notes_page.dart';

class CategoryNotesArguments {
  final NoteCategory category;
  final List<BaseNote> notes;

  CategoryNotesArguments({required this.category, required this.notes});
}

class CategoryNotesPage extends StatelessWidget {
  final NoteCategory category;
  static const routeName = '/categoryNotes';

  const CategoryNotesPage({Key? key, required this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CategoryNotesBloc(
        CategoryNotesState(category: category),
        noteRepository: RepositoryProvider.of<NoteRepository>(context),
      )..add(FetchNotesEvent()),
      child: const CategoryNotesContent(),
    );
  }
}
