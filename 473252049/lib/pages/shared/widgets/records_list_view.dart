import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../model/category.dart';
import '../../../model/record.dart';
import '../../category/cubit/records_cubit.dart';
import '../../main/tabs/home/cubit/categories_cubit.dart';
import '../../settings/cubit/settings_cubit.dart';
import 'record/record_widget.dart';

class RecordsListView extends StatefulWidget {
  final List<Record> records;
  final Category category;
  final bool withCategories;

  const RecordsListView({
    Key key,
    @required this.records,
    this.category,
    this.withCategories,
  }) : super(key: key);

  @override
  _RecordsListViewState createState() => _RecordsListViewState();
}

class _RecordsListViewState extends State<RecordsListView> {
  @override
  void initState() {
    context.read<RecordsCubit>().loadRecords(categoryId: widget.category?.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: ListView(
        reverse: true,
        children: [
          ...recordWidgetsFromRecords(
            records: widget.records,
            category: widget.category,
            context: context,
            withCategories: widget.withCategories,
          ),
        ],
      ),
    );
  }
}

List<Widget> recordWidgetsFromRecords({
  List<Record> records,
  Category category,
  BuildContext context,
  bool withCategories,
}) {
  final recordWidgets = <Widget>[];
  for (var i = 0; i < records.length; ++i) {
    if (i > 0 &&
        records[i].createDateTime.day != records[i - 1].createDateTime.day) {
      recordWidgets.add(
        BlocBuilder<SettingsCubit, SettingsState>(
          builder: (context, state) {
            return RecordWidget(
              record: Record(
                DateFormat.yMEd().format(
                  records[i - 1].createDateTime,
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
            record: records[i],
            category: category,
            bubbleAlignment: state.bubbleAlignment,
            withCategory: withCategories,
            futureCategory:
                context.read<CategoriesCubit>().getById(records[i].categoryId),
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
                records.last.createDateTime,
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
