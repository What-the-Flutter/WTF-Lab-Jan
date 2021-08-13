import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../models/note.dart';
import '../../../utils/constants.dart';
import '../../../widgets/note_item.dart';

class NoteSearch extends SearchDelegate<String> {
  final List<Note> notes;

  NoteSearch(BuildContext context, this.notes)
      : super(
          searchFieldStyle: Theme.of(context).textTheme.bodyText2?.copyWith(fontSize: FontSize.big),
        );

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(onPressed: () => query = '', icon: const Icon(Icons.clear)),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () => Navigator.pop(context),
      icon: !kIsWeb && (Platform.isMacOS || Platform.isIOS)
          ? Icon(Icons.arrow_back_ios, color: Theme.of(context).iconTheme.color)
          : Icon(Icons.arrow_back, color: Theme.of(context).iconTheme.color),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container(
      color: Colors.red,
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isNotEmpty) {
      final filteredList =
          notes.where((element) => element.text?.contains(query) ?? false).toList();
      return ListView.builder(
        itemCount: filteredList.length,
        itemBuilder: (context, index) {
          return NoteItem(note: filteredList[index]);
        },
      );
    } else {
      return Center(
        child: FractionallySizedBox(
          widthFactor: 0.3,
          child: Image.asset('assets/search.png'),
        ),
      );
    }
  }
}
