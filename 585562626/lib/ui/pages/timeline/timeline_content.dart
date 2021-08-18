import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../models/category.dart';
import '../../../models/tag.dart';
import '../../../widgets/note_item.dart';
import 'bloc/bloc.dart';
import 'bloc/timeline_bloc.dart';
import 'filter/filter_page.dart';

class TimelineContent extends StatefulWidget {
  const TimelineContent({Key? key}) : super(key: key);

  @override
  _TimelineContentState createState() => _TimelineContentState();
}

class _TimelineContentState extends State<TimelineContent> {
  late final TimelineBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = context.read();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TimelineBloc, TimelineState>(
      builder: (context, state) {
        final content;
        if (state is FetchedNotesState) {
          content = state.filteredNotes.isEmpty
              ? Center(
                  child: Text('Nothing found.', style: Theme.of(context).textTheme.bodyText2),
                )
              : ListView(
                  physics: const ClampingScrollPhysics(),
                  children: state.filteredNotes
                      .map((note) => NoteItem(note: note.note, category: note.category))
                      .toList(),
                );
        } else {
          content = Center(
            child: CircularProgressIndicator(color: Theme.of(context).accentColor),
          );
        }
        return Scaffold(
          body: content,
          floatingActionButton: FloatingActionButton(
            heroTag: 'filter_hero',
            child: const Icon(Icons.filter_list),
            onPressed: _navigateToFilter,
          ),
        );
      },
    );
  }

  void _navigateToFilter() async {
    final result = await Navigator.of(context).pushNamed(FilterPage.routeName);
    if (result != null && result is FilterResult) {
      _bloc.add(ApplyFilterEvent(result.categories, result.tags, result.query));
    }
  }
}

class FilterResult {
  final String query;
  final List<Tag> tags;
  final List<Category> categories;

  FilterResult({required this.query, required this.tags, required this.categories});
}
