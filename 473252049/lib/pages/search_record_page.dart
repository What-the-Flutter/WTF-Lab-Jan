import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../model/record.dart';
import 'category/cubit/records_cubit.dart';
import 'main/tabs/home/cubit/categories_cubit.dart';
import 'shared/widgets/records_list_view.dart';

class SearchRecordPage extends SearchDelegate<Record> {
  final List<RecordWithCategory> records;
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
        child: BlocBuilder<RecordsCubit, RecordsState>(
          builder: (context, state) {
            return RecordsListView(
              records: records.where(
                (record) {
                  return record.record.message.contains(query);
                },
              ).toList(),
              withCategories: withCategories,
              isOnSearchPage: true,
            );
          },
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
        child: BlocBuilder<RecordsCubit, RecordsState>(
          builder: (context, state) {
            return RecordsListView(
              records: records.where(
                (record) {
                  return record.record.message.toLowerCase().contains(
                        query.toLowerCase(),
                      );
                },
              ).toList(),
              withCategories: withCategories,
              isOnSearchPage: true,
            );
          },
        ),
      ),
    );
  }
}
