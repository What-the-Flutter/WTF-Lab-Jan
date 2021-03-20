import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../model/category.dart';
import '../../../model/record.dart';
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
          ...recordWidgetsFromRecords(records, category),
        ],
      ),
    );
  }
}

List<RecordWidget> recordWidgetsFromRecords(
  List<Record> records,
  Category category,
) {
  final recordWidgets = <RecordWidget>[];
  for (var i = 0; i < records.length; ++i) {
    if (i > 0 &&
        records[i].createDateTime.day != records[i - 1].createDateTime.day) {
      recordWidgets.add(
        RecordWidget(
          record: Record(
            DateFormat.yMEd().format(
              records[i - 1].createDateTime,
            ),
            categoryId: category?.id,
          ),
          isDateRecord: true,
        ),
      );
    }
    recordWidgets.add(
      RecordWidget(
        record: records[i],
        category: category,
      ),
    );
  }
  recordWidgets.add(
    RecordWidget(
      record: Record(
        DateFormat.yMEd().format(
          records.last.createDateTime,
        ),
        categoryId: category?.id,
      ),
      isDateRecord: true,
    ),
  );
  return recordWidgets;
}
