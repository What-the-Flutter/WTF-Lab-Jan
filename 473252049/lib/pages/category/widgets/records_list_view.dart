import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../model/category.dart';
import '../../../model/record.dart';
import '../../settings/cubit/settings_cubit.dart';
import 'record_widget.dart';

class RecordsListView extends StatelessWidget {
  final List<Record> records;
  final Category category;

  const RecordsListView({
    Key key,
    @required this.records,
    this.category,
  }) : super(key: key);

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
            record: records[i],
            category: category,
            bubbleAlignment: state.bubbleAlignment,
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
