import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../main.dart';
import 'bookmarks_cubit.dart';
import 'bookmarks_state.dart';

class FilterSettingsPage extends StatefulWidget {
  FilterSettingsPage({Key? key}) : super(key: key);

  static const routeName = '/pageFilterSettingsPage';
  @override
  _FilterSettingsPageState createState() => _FilterSettingsPageState();
}

class _FilterSettingsPageState extends State<FilterSettingsPage> {
  bool idkHowToDoAnotherWay = false;
  late final BookmarksCubit _bookmarksCubit;
  late final BookmarksState state;

  @override
  Widget build(BuildContext context) {
    if (idkHowToDoAnotherWay != true) {
      final args =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      _bookmarksCubit = args['cubit'];
      state = args['state'];
      idkHowToDoAnotherWay = true;
    }
    return BlocBuilder<BookmarksCubit, BookmarksState>(
      bloc: _bookmarksCubit,
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Center(
              child: Text('Filters'),
            ),
          ),
          body: Flex(
            direction: Axis.vertical,
            children: [
              Expanded(
                flex: 1,
                child: _pageFilterButtons(
                  state.pagesFilterMap,
                  _bookmarksCubit,
                  state,
                ),
              ),
              Expanded(
                flex: 1,
                child: _iconsFilterButtons(
                  state.iconsFilterMap,
                  _bookmarksCubit,
                  state,
                ),
              )
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              _bookmarksCubit.applyFiltersToNotesList();
              Navigator.pop(context);
            },
            child: Icon(
              Icons.done,
              color: Theme.of(context).primaryColorLight,
            ),
          ),
        );
      },
    );
  }
}

Widget _pageFilterButtons(
  Map<String, bool> map,
  BookmarksCubit bookmarksCubit,
  BookmarksState state,
) {
  return ListView.builder(
    itemCount: state.pagesFilterList.length,
    itemBuilder: (context, index) {
      return FilterChip(
        key: ValueKey(index),
        label: Text(state.pagesFilterList[index]),
        labelStyle: TextStyle(
            color: state.pagesFilterMap[state.pagesFilterList.elementAt(index)]!
                ? Colors.white
                : Colors.white),
        selected: state.pagesFilterMap[state.pagesFilterList.elementAt(index)]!,
        onSelected: (selected) {
          bookmarksCubit
              .updatePagesFilterList(state.pagesFilterList.elementAt(index));
        },
        selectedColor: Colors.blue,
        checkmarkColor: Colors.white,
      );
    },
  );
}

Widget _iconsFilterButtons(
  Map<int, bool> map,
  BookmarksCubit bookmarksCubit,
  BookmarksState state,
) {
  return ListView.builder(
    itemCount: state.iconsFilterList.length,
    itemBuilder: (context, index) {
      return FilterChip(
        key: ValueKey(index),
        label: Icon(
          noteMenuItemList[state.iconsFilterList[index]]!.iconData,
          color: Theme.of(context).primaryColorLight,
        ),
        selected: state.iconsFilterMap[state.iconsFilterList.elementAt(index)]!,
        onSelected: (selected) {
          bookmarksCubit
              .updateiconsFilterList(state.iconsFilterList.elementAt(index));
        },
        selectedColor: Colors.blue,
        checkmarkColor: Colors.white,
      );
    },
  );
}
