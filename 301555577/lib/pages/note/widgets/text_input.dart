import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../../../logic/cubit/notes_cubit.dart';

Container textInput(BuildContext context) {
  return Container(
    padding: const EdgeInsets.only(
      left: 20,
      top: 10,
      right: 10,
      bottom: 10,
    ),
    decoration: BoxDecoration(
      color: Theme.of(context).disabledColor,
      boxShadow: [
        BoxShadow(
          blurRadius: 4,
          color: Colors.black.withOpacity(0.3),
        ),
      ],
    ),
    child: SafeArea(
      child: Row(
        children: [
          const Icon(
            Icons.camera_alt_outlined,
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(40),
              ),
              child: Row(
                children: [
                  IconButton(
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
                                padding:
                                    const EdgeInsets.symmetric(vertical: 15),
                                child: Text(
                                  'Select a category for send',
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: ListView.builder(
                                  itemCount:
                                      BlocProvider.of<NotesCubit>(context)
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
                                              .changeSendCategory(index);
                                        },
                                        child: Text(
                                          BlocProvider.of<NotesCubit>(context)
                                              .categoryList[index]
                                              .name as String,
                                          style: TextStyle(
                                            color:
                                                Theme.of(context).primaryColor,
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
                    icon: Icon(
                      BlocProvider.of<NotesCubit>(context)
                          .state
                          .selectedCategory
                          .icon,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      style: TextStyle(color: Theme.of(context).primaryColor),
                      cursorColor: Theme.of(context).primaryColor,
                      controller: BlocProvider.of<NotesCubit>(context)
                          .textInputController,
                      decoration: const InputDecoration(
                        hintText: 'Type message',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Icon(Icons.attach_file_outlined),
                ],
              ),
            ),
          ),
          // const SizedBox(width: 10),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () {
              BlocProvider.of<NotesCubit>(context).addNote();
            },
          ),
        ],
      ),
    ),
  );
}
