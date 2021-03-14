import 'package:chat_journal/cubits/records/records_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../model/category.dart';
import '../model/record.dart';
import 'category_page.dart';

class SerachRecordPage extends SearchDelegate<Record> {
  final List<Record> records;
  final Category category;
  final BuildContext context;

  SerachRecordPage(
      {@required this.context, @required this.records, this.category});

  @override
  ThemeData appBarTheme(BuildContext context) {
    return Theme.of(context);
  }

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
    return BlocProvider.value(
      value: this.context.read<RecordsCubit>(),
      child: RecordsListView(
        records: records.where(
          (record) {
            return record.message.contains(query);
          },
        ).toList(),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return BlocProvider.value(
      value: this.context.read<RecordsCubit>(),
      child: RecordsListView(
        records: records.where(
          (record) {
            return record.message.contains(query);
          },
        ).toList(),
      ),
    );
  }
}
