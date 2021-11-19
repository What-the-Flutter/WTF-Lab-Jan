import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/category_model.dart';
import '../../data/repositories/category_repository.dart';
import '../../data/repositories/note_repository.dart';
import '../../logic/cubit/notes_cubit.dart';
import 'widgets/app_with_options.dart';
import 'widgets/chat.dart';
import 'widgets/floating_search_bar.dart';
import 'widgets/text_input.dart';

class NotesArguments {
  final Category category;
  NotesArguments({required this.category});
}

class NotesPage extends StatelessWidget {
  final Category category;

  const NotesPage({Key? key, required this.category}) : super(key: key);

  static const routeName = '/notes';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      lazy: false,
      create: (context) => NotesCubit(
        NotesState(
            category: category,
            notes: [],
            selectedNotes: [],
            updateTime: DateTime.now(),
            selectedCategory: category),
        categoryRepository: RepositoryProvider.of<CategoryRepository>(context),
        noteRepository: RepositoryProvider.of<NoteRepository>(context),
      )..fetchNotes(category),
      child: BlocBuilder<NotesCubit, NotesState>(
        builder: (context, state) {
          return Scaffold(
            appBar: state.selectedNotes.isNotEmpty
                ? appBarWithOptions(state, context)
                : AppBar(
                    title: Text(category.name as String),
                    actions: [
                      IconButton(
                        onPressed: () {
                          BlocProvider.of<NotesCubit>(context)
                              .showOrCloseSearchBar();
                        },
                        icon: const Icon(Icons.search),
                      )
                    ],
                  ),
            body: Column(
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      Builder(
                        builder: (context) {
                          return chat(state);
                        },
                      ),
                      if (BlocProvider.of<NotesCubit>(context)
                          .state
                          .showImagePicker)
                        Container(
                          height: 80,
                          child: buildFloatingSearchBar(context),
                        ),
                    ],
                  ),
                ),
                textInput(context),
              ],
            ),
          );
        },
      ),
    );
  }
}
