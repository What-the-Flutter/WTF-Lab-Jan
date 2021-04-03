import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../model/category.dart';
import '../../../../model/record.dart';
import '../../../category/cubit/records_cubit.dart';
import 'record_widget_content.dart';

class RecordWidget extends StatelessWidget {
  final Category category;
  final Record record;
  final bool isDateRecord;
  final Alignment bubbleAlignment;
  final bool withCategory;

  const RecordWidget({
    Key key,
    this.category,
    this.record,
    this.isDateRecord = false,
    this.bubbleAlignment,
    this.withCategory = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecordsCubit, RecordsState>(
      builder: (context, state) {
        return GestureDetector(
          behavior: HitTestBehavior.translucent,
          onLongPress: () {
            if (isDateRecord) return;
            context
                .read<RecordsCubit>()
                .select(record, categoryId: withCategory ? null : category.id);
          },
          onTap: () {
            if (isDateRecord) return;
            if (state.records.map((e) => e.record.isSelected).contains(true)) {
              if (record.isSelected) {
                context.read<RecordsCubit>().unselect(record,
                    categoryId: withCategory ? null : category.id);
              } else {
                context.read<RecordsCubit>().select(record,
                    categoryId: withCategory ? null : category.id);
              }
            }
          },
          child: RecordWidgetContent(
            isSelected: record.isSelected,
            isFavorite: record.isFavorite,
            bubbleAlignment: bubbleAlignment,
            image: record.image,
            message: record.message,
            isDateRecord: isDateRecord,
            records: state.records,
            createDateTime: record.createDateTime,
            withCategory: withCategory,
            categoryName: category?.name,
            categoryId: category?.id,
          ),
        );
      },
    );
  }
}
