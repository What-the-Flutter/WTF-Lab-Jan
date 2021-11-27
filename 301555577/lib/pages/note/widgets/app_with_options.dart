import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../../../logic/cubit/notes_cubit.dart';

AppBar appBarWithOptions(NotesState state, BuildContext context) {
  return AppBar(
    centerTitle: false,
    title: Text(state.selectedNotes.length.toString()),
    leading: IconButton(
      icon: const Icon(Icons.close),
      onPressed: () {
        BlocProvider.of<NotesCubit>(context).clearSelected();
      },
    ),
    actions: [
      Builder(builder: (context) {
        return IconButton(
          icon: const Icon(Icons.share_rounded),
          onPressed: () {
            showMaterialModalBottomSheet(
              context: context,
              builder: (_) => Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).backgroundColor,
                ),
                height: 450,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      child: Text(
                        'Select a category to transfer',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: BlocProvider.of<NotesCubit>(context)
                            .categoryList
                            .length,
                        shrinkWrap: true,
                        itemBuilder: (_, index) {
                          return Padding(
                            padding: const EdgeInsets.all(10),
                            child: OutlinedButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                  Theme.of(context).backgroundColor,
                                ),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                                BlocProvider.of<NotesCubit>(context)
                                    .changeSelectedCategory(index);
                              },
                              child: Text(
                                BlocProvider.of<NotesCubit>(context)
                                    .categoryList[index]
                                    .name as String,
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
      IconButton(
        icon: const Icon(Icons.bookmark_add_outlined),
        onPressed: () {},
      ),
      if (state.selectedNotes.length == 1 &&
          state.selectedNotes.first.image == null)
        IconButton(
          icon: const Icon(Icons.copy),
          onPressed: () {
            BlocProvider.of<NotesCubit>(context).copyToClipboard();
          },
        ),
      if (state.selectedNotes.length == 1 &&
          state.selectedNotes.first.image == null)
        IconButton(
          icon: const Icon(Icons.edit),
          onPressed: () {
            BlocProvider.of<NotesCubit>(context).editNote();
          },
        ),
      IconButton(
        icon: const Icon(Icons.delete_outline),
        onPressed: () {
          BlocProvider.of<NotesCubit>(context).deleteSelected();
        },
      ),
    ],
  );
}
