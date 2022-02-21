import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_lab_project/main.dart';
import 'package:my_lab_project/pages/bookmarks.dart/bookmarks_cubit.dart';
import 'package:my_lab_project/pages/bookmarks.dart/bookmarks_state.dart';
import 'package:toggle_switch/toggle_switch.dart';

import '../../services/firebase_auth_service.dart';
import '../../style/theme_cubit.dart';

class BookmarksPage extends StatefulWidget {
  BookmarksPage({Key? key}) : super(key: key);

  static const routeName = '/pageBookmarks';
  @override
  _BookmarksPageState createState() => _BookmarksPageState();
}

class _BookmarksPageState extends State<BookmarksPage> {
  final BookmarksCubit _bookmarksCubit = BookmarksCubit();

  @override
  void initState() {
    super.initState();
    _bookmarksCubit.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookmarksCubit, BookmarksState>(
        bloc: _bookmarksCubit,
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: const Center(child: Text('Bookmarks')),
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.bookmark_border,
                    color: Theme.of(context).primaryColorLight,
                  ),
                ),
              ],
            ),
            body: _bookmarksBody(
              _bookmarksCubit,
              state,
              context,
            ),
            backgroundColor: Theme.of(context).backgroundColor,
          );
        });
  }
}

Widget _bookmarksBody(
  BookmarksCubit bookmarksCubit,
  BookmarksState state,
  BuildContext context,
) {
  return ListView.builder(
    itemCount: state.notesList.length,
    itemBuilder: (context, index) {
      return _listTile(context, bookmarksCubit, state, index);
    },
  );
}

Widget _listTile(
  BuildContext context,
  BookmarksCubit bookmarksCubit,
  BookmarksState state,
  int index,
) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 4.0),
    child: ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width - 10.0,
      ),
      child: Card(
        color: Theme.of(context).cardColor,
        child: IntrinsicWidth(
          child: ListTile(
            key: ValueKey(state.notesList[index].id),
            leading: Column(
              children: [
                Icon(
                  noteMenuItemList[state.notesList[index].icon]!.iconData,
                  color: Theme.of(context).iconTheme.color,
                ),
              ],
            ),
            title: Text(
              '${state.notesList[index].heading}',
              maxLines: 1,
              style: TextStyle(
                color: state.notesList[index].isFavorite
                    ? Colors.green
                    : Theme.of(context).colorScheme.primaryVariant,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  state.notesList[index].data,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                Text(
                  state.notesList[index].tags!,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondaryVariant,
                  ),
                ),
              ],
            ),
            isThreeLine: state.notesList[index].data.length > 30 ? true : false,
          ),
        ),
      ),
    ),
  );
}
