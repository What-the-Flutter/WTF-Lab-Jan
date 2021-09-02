import 'package:flutter/material.dart';

import '../../Themes/theme_change.dart';
import '../../models/note_model.dart';

class NoteSearchDelegate extends SearchDelegate<String> {
  final List<String> _history;
  final int _index;
  final List<String> _words;
  final List<Note> _elements;

  NoteSearchDelegate(int index, words, elements)
      : _history = <String>[],
        _words = words,
        _index = index,
        _elements = elements,
        super();

  @override
  List<Widget> buildActions(BuildContext context) {
    return <Widget>[
      query.isNotEmpty
          ? IconButton(
              onPressed: () {
                query = '';
                showSuggestions(context);
              },
              icon: const Icon(Icons.clear),
            )
          : Container(),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      tooltip: 'Back',
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final textTheme =
        ThemeSelector.instanceOf(context).theme.textTheme.headline1;
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Center(
        child: ListTile(
            title: Text(
              query,
              style: textTheme!
                  .copyWith(fontWeight: FontWeight.bold, color: Colors.blue),
            ),
            leading: Icon(_elements[_index].icon),
            subtitle: Text(_elements[_index].time),
            trailing: IconButton(
              icon: const Icon(Icons.reply),
              onPressed: () {
                close(context, query);
              },
            )),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    Iterable<String> getSuggestions() {
      final suggestions = query.isEmpty
          ? _history
          : _words.where((word) => word.startsWith(query));

      return suggestions;
    }

    return _SuggestionsList(
      query: query,
      suggestions: getSuggestions().toList(),
      onSelected: (suggestion) {
        query = suggestion;
        _history.insert(0, suggestion);
        showResults(context);
      },
    );
  }
}

class _SuggestionsList extends StatelessWidget {
  final List<String> suggestions;
  final String query;
  final ValueChanged<String> onSelected;

  const _SuggestionsList({
    required this.query,
    required this.onSelected,
    required this.suggestions,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme =
        ThemeSelector.instanceOf(context).theme.textTheme.subtitle1;
    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, i) {
        final suggestion = suggestions[i];
        return ListTile(
          leading: query.isEmpty ? const Icon(Icons.history) : const Icon(null),
          title: RichText(
            text: TextSpan(
              text: suggestion.substring(0, query.length),
              style: textTheme!
                  .copyWith(fontWeight: FontWeight.bold, color: Colors.blue),
              children: <TextSpan>[
                TextSpan(
                  text: suggestion.substring(query.length),
                  style: textTheme,
                ),
              ],
            ),
          ),
          onTap: () {
            onSelected(suggestion);
          },
        );
      },
    );
  }
}
