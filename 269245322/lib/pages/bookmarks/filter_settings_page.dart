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

class _FilterSettingsPageState extends State<FilterSettingsPage>
    with TickerProviderStateMixin {
  bool _idkHowToDoAnotherWay = false;
  late final BookmarksCubit _bookmarksCubit;
  late final AnimationController _animationController;
  late Animation _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _animationController.repeat(reverse: true);
    _animation = Tween(begin: 1.0, end: 13.0).animate(_animationController)
      ..addListener(
        () {
          setState(() {});
        },
      );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _animation.isDismissed;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_idkHowToDoAnotherWay != true) {
      _bookmarksCubit =
          ModalRoute.of(context)!.settings.arguments as BookmarksCubit;
      _idkHowToDoAnotherWay = true;
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
                  _bookmarksCubit.getPagesFilterMap(),
                  _bookmarksCubit.getPagesFilterList(),
                  _bookmarksCubit,
                ),
              ),
              Expanded(
                flex: 1,
                child: _iconsFilterButtons(
                  _bookmarksCubit.getIconsFilterMap(),
                  _bookmarksCubit.getIconsFilterList(),
                  _bookmarksCubit,
                ),
              )
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              _bookmarksCubit.applyFiltersToNotesList();
              Navigator.pop(context);
            },
            child: Container(
              width: 100,
              height: 100,
              child: Icon(
                Icons.done,
                color: Theme.of(context).primaryColorLight,
                size: 35,
              ),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).primaryColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: _animation.value + _animation.value,
                    spreadRadius: _animation.value,
                    offset: Offset(_animation.value, _animation.value),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

Widget _pageFilterButtons(
  Map<String, bool> pagesMap,
  List<String> pagesList,
  BookmarksCubit bookmarksCubit,
) {
  return ListView.builder(
    itemCount: pagesList.length,
    itemBuilder: (context, index) {
      return FilterChip(
        key: ValueKey(index),
        label: Text(pagesList[index]),
        labelStyle: TextStyle(
          color: Theme.of(context).primaryColorLight,
        ),
        selected: pagesMap[pagesList.elementAt(index)]!,
        onSelected: (selected) {
          bookmarksCubit.updatePagesFilterList(pagesList.elementAt(index));
        },
        selectedColor: Colors.blue,
        checkmarkColor: Colors.white,
      );
    },
  );
}

Widget _iconsFilterButtons(
  Map<int, bool> iconsMap,
  List<int> iconsList,
  BookmarksCubit bookmarksCubit,
) {
  return ListView.builder(
    itemCount: iconsList.length,
    itemBuilder: (context, index) {
      return FilterChip(
        key: ValueKey(index),
        label: Icon(
          noteMenuItemList[iconsList[index]]!.iconData,
          color: Theme.of(context).primaryColorLight,
        ),
        selected: iconsMap[iconsList.elementAt(index)]!,
        onSelected: (selected) {
          bookmarksCubit.updateiconsFilterList(iconsList.elementAt(index));
        },
        selectedColor: Colors.blue,
        checkmarkColor: Colors.white,
      );
    },
  );
}
