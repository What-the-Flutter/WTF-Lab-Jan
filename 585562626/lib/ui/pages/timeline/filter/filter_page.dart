import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../repository/category_repository.dart';
import '../../../../repository/note_repository.dart';
import 'bloc/bloc.dart';
import 'bloc/filter_bloc.dart';
import 'filter_content.dart';

class FilterPage extends StatelessWidget {
  static const routeName = '/timeline_filter';

  const FilterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => FilterBloc(
        InitialState(),
        noteRepository: RepositoryProvider.of<NoteRepository>(context),
        categoryRepository: RepositoryProvider.of<CategoryRepository>(context),
      )..add(const FetchDataEvent()),
      child: const FilterContent(),
    );
  }
}
