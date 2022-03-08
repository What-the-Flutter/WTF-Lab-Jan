import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../main.dart';
import 'bookmarks_cubit.dart';
import 'bookmarks_state.dart';
import 'filter_settings_page.dart';

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
                  onPressed: _bookmarksCubit.bookmarkButtonTap,
                  icon: Icon(
                    _bookmarksCubit.bookmarkButtonState()
                        ? Icons.bookmark
                        : Icons.bookmark_border,
                    color: Theme.of(context).primaryColorLight,
                  ),
                ),
              ],
            ),
            body: _bookmarksPageBody(
              _bookmarksCubit,
              state,
              context,
            ),
            floatingActionButton: _bookmarksPageFloatingActionButton(
              context,
              _bookmarksCubit,
              state,
            ),
            backgroundColor: Theme.of(context).backgroundColor,
          );
        });
  }
}

Widget _bookmarksPageBody(
  BookmarksCubit bookmarksCubit,
  BookmarksState state,
  BuildContext context,
) {
  return ListView.builder(
    itemCount: state.notesListUI.length,
    itemBuilder: (context, index) {
      return _listTile(context, state, index);
    },
  );
}

FloatingActionButton _bookmarksPageFloatingActionButton(
  BuildContext context,
  BookmarksCubit bookmarksCubit,
  BookmarksState state,
) {
  return FloatingActionButton(
    onPressed: () =>
        _bookmarksPageFloatingActionButtonEvent(context, bookmarksCubit, state),
    child: const Icon(Icons.filter_alt),
  );
}

void _bookmarksPageFloatingActionButtonEvent(
  BuildContext context,
  BookmarksCubit bookmarksCubit,
  BookmarksState state,
) {
  Navigator.pushNamed(
    context,
    FilterSettingsPage.routeName,
    arguments: bookmarksCubit,
  );
}

Widget _listTile(
  BuildContext context,
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
            key: ValueKey(state.notesListUI[index].id),
            leading: ExcludeSemantics(
              child: CircleAvatar(
                backgroundColor: Theme.of(context).backgroundColor,
                child: Icon(
                  noteMenuItemList[state.notesListUI[index].icon]!.iconData,
                  color: Theme.of(context).iconTheme.color,
                ),
              ),
            ),
            title: Text(
              '${state.notesListUI[index].heading}',
              maxLines: 1,
              style: TextStyle(
                color: state.notesListUI[index].isFavorite
                    ? Colors.green
                    : Theme.of(context).colorScheme.primaryVariant,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  state.notesListUI[index].data,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                Text(
                  state.notesListUI[index].tags!,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondaryVariant,
                  ),
                ),
              ],
            ),
            isThreeLine:
                state.notesListUI[index].data.length > 30 ? true : false,
          ),
        ),
      ),
    ),
  );
}
