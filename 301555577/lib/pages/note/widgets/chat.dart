import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../logic/cubit/notes_cubit.dart';

ListView chat(NotesState state) {
  return ListView.builder(
    reverse: state.notes.isNotEmpty,
    itemCount: state.notes.length,
    itemBuilder: (context, index) {
      return Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 8,
          horizontal: 10,
        ),
        child: GestureDetector(
          onLongPress: () {
            BlocProvider.of<NotesCubit>(context).select(state.notes[index]);
          },
          child: Row(
            children: [
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: state.selectedNotes.contains(state.notes[index])
                        ? Theme.of(context).primaryColor
                        : Theme.of(context).cardColor,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                      bottomRight: Radius.circular(15),
                    ),
                  ),
                  child: Text(
                    state.notes[index].text as String,
                    style: TextStyle(
                      color: state.selectedNotes.contains(state.notes[index])
                          ? Theme.of(context).backgroundColor
                          : Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                '${state.notes[index].created.hour}:${state.notes[index].created.minute}',
              )
            ],
          ),
        ),
      );
    },
  );
}
