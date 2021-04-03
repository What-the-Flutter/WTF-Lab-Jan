import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../model/category.dart';
import '../../../model/record.dart';
import '../../category/cubit/records_cubit.dart';
import '../../settings/cubit/settings_cubit.dart';
import 'record/record_widget.dart';

class RecordsListView extends StatelessWidget {
  final List<RecordWithCategory> records;
  final Category category;
  final bool withCategories;
  final bool isOnSearchPage;

  const RecordsListView(
      {Key key,
      this.records,
      this.category,
      this.withCategories,
      this.isOnSearchPage})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: ListView(
        reverse: true,
        children: [
          ...recordWidgetsFromRecords(
            records: records,
            category: category,
            context: context,
            withCategories: withCategories,
            isOnSearchPage: isOnSearchPage,
          ),
        ],
      ),
    );
  }
}

List<Widget> recordWidgetsFromRecords(
    {List<RecordWithCategory> records,
    Category category,
    BuildContext context,
    bool withCategories,
    bool isOnSearchPage}) {
  final recordWidgets = <Widget>[];
  for (var i = 0; i < records.length; ++i) {
    if (i > 0 &&
        records[i].record.createDateTime.day !=
            records[i - 1].record.createDateTime.day) {
      recordWidgets.add(
        BlocBuilder<SettingsCubit, SettingsState>(
          builder: (context, state) {
            return RecordWidget(
              record: Record(
                DateFormat.yMEd().format(
                  records[i - 1].record.createDateTime,
                ),
                categoryId: category?.id,
              ),
              isDateRecord: true,
              bubbleAlignment: state.centerDateBubble
                  ? Alignment.center
                  : state.bubbleAlignment,
            );
          },
        ),
      );
    }
    recordWidgets.add(
      BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, state) {
          return RecordWidget(
            key: UniqueKey(),
            record: records[i].record,
            category: category ?? records[i].category,
            bubbleAlignment: state.bubbleAlignment,
            withCategory: withCategories,
            isOnSearchPage: isOnSearchPage,
          );
        },
      ),
    );
  }
  if (records.isNotEmpty) {
    recordWidgets.add(
      BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, state) {
          return RecordWidget(
            record: Record(
              DateFormat.yMEd().format(
                records.last.record.createDateTime,
              ),
              categoryId: category?.id,
            ),
            isDateRecord: true,
            bubbleAlignment: state.centerDateBubble
                ? Alignment.center
                : state.bubbleAlignment,
          );
        },
      ),
    );
  }
  return recordWidgets;
}
