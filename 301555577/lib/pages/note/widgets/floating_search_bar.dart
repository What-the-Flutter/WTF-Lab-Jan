import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import '../../../logic/cubit/notes_cubit.dart';

Widget buildFloatingSearchBar(BuildContext context) {
  return FloatingSearchBar(
    queryStyle: TextStyle(color: Theme.of(context).primaryColor),
    isScrollControlled: true,
    clearQueryOnClose: false,
    backgroundColor: Theme.of(context).backgroundColor,
    accentColor: Theme.of(context).primaryColor,
    borderRadius: BorderRadius.circular(0),
    hint: 'Search...',
    elevation: 10,
    transitionDuration: const Duration(milliseconds: 0),
    onSubmitted: (query) {
      BlocProvider.of<NotesCubit>(context).fetchSearchNotes(query);
    },
    backdropColor: Colors.transparent,
    builder: (context, transition) {
      return Container();
    },
  );
}
