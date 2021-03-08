import 'package:flutter/material.dart';

import '../model/category.dart';
import '../model/record.dart';
import 'category_page.dart';

class SerachRecordPage extends SearchDelegate<Record> {
  final List<Record> records;
  final Category category;

  SerachRecordPage({@required this.records, this.category});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return RecordsListView(
      records: records.where(
        (record) {
          return record.message.contains(query);
        },
      ).toList(),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return RecordsListView(
      records: records.where(
        (record) {
          return record.message.contains(query);
        },
      ).toList(),
    );
  }
}
