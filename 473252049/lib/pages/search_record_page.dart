import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../model/record.dart';
import 'category/cubit/records_cubit.dart';
import 'category/widgets/records_list_view.dart';
import 'main/tabs/home/cubit/categories_cubit.dart';

class SearchRecordPage extends SearchDelegate<Record> {
  final List<Record> records;
  final BuildContext context;
  final bool withCategories;

  SearchRecordPage({
    @required this.context,
    @required this.records,
    this.withCategories = false,
  });

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
      child: BlocProvider.value(
        value: this.context.read<CategoriesCubit>(),
        child: RecordsListView(
          records: records.where(
            (record) {
              return record.message.contains(query);
            },
          ).toList(),
          withCategories: withCategories,
        ),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return BlocProvider.value(
      value: this.context.read<RecordsCubit>(),
      child: BlocProvider.value(
        value: this.context.read<CategoriesCubit>(),
        child: RecordsListView(
          records: records.where(
            (record) {
              return record.message.contains(query);
            },
          ).toList(),
          withCategories: withCategories,
        ),
      ),
    );
  }
}
