import 'package:flutter/material.dart';
import 'package:line_icons/line_icon.dart';

import '../../../data/models/category_model.dart';
import '../../../logic/cubit/categories_cubit.dart';
import '../../note/notes_page.dart';

Widget categoryListItem(CategoriesFetchedState state, int index) {
  return Builder(
    builder: (context) {
      return Material(
        color: Theme.of(context).backgroundColor,
        child: InkWell(
          child: Builder(
            builder: (context) {
              return Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                height: 90,
                decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(color: Colors.black.withOpacity(0.1))),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: LineIcon(
                        state.categories[index].icon,
                        size: 36,
                      ),
                    ),
                    const SizedBox(width: 20),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Builder(
                          builder: (context) {
                            return Text(
                              state.categories[index].name as String,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Theme.of(context).primaryColor,
                              ),
                            );
                          },
                        ),
                        Text(
                          'No events. Click to create one',
                          style:
                              TextStyle(color: Theme.of(context).primaryColor),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (state.categories[index].priority ==
                            CategoryPriority.high)
                          const Icon(Icons.push_pin),
                        Text(
                          '12:30',
                          style:
                              TextStyle(color: Theme.of(context).primaryColor),
                        ),
                      ],
                    ),
                    const SizedBox(width: 5),
                  ],
                ),
              );
            },
          ),
          onTap: () => Navigator.of(context).pushNamed(
            NotesPage.routeName,
            arguments: NotesArguments(category: state.categories[index]),
          ),
        ),
      );
    },
  );
}
