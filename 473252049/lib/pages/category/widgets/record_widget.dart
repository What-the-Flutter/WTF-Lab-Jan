import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../model/category.dart';
import '../../../model/record.dart';
import '../cubit/records_cubit.dart';

class RecordWidget extends StatelessWidget {
  final Category category;
  final Record record;
  final bool isDateRecord;
  final Alignment bubbleAlignment;

  const RecordWidget({
    Key key,
    this.record,
    this.category,
    this.isDateRecord = false,
    this.bubbleAlignment = Alignment.centerRight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecordsCubit, RecordsState>(
      builder: (context, state) {
        return GestureDetector(
          behavior: HitTestBehavior.translucent,
          onLongPress: () {
            context.read<RecordsCubit>().select(
                  record,
                  categoryId: category?.id,
                );
          },
          onTap: () {
            if (state.records
                .map(
                  (e) => e.isSelected,
                )
                .contains(true)) {
              if (record.isSelected) {
                context.read<RecordsCubit>().unselect(
                      record,
                      categoryId: category?.id,
                    );
              } else {
                context.read<RecordsCubit>().select(
                      record,
                      categoryId: category?.id,
                    );
              }
            }
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 1.5),
            child: Bubble(
              color: record.isSelected
                  ? Theme.of(context).scaffoldBackgroundColor
                  : Theme.of(context).backgroundColor,
              alignment: bubbleAlignment,
              child: Column(
                crossAxisAlignment: bubbleAlignment == Alignment.centerRight
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: [
                  if (record.image != null)
                    Container(
                      constraints: BoxConstraints(maxHeight: 400),
                      child: Image.file(record.image),
                    ),
                  if (record.message.isNotEmpty)
                    Text(
                      record.message,
                      textAlign: bubbleAlignment == Alignment.centerRight
                          ? TextAlign.end
                          : TextAlign.start,
                    ),
                  if (!isDateRecord)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (record.isFavorite)
                          Icon(
                            Icons.bookmark,
                            size: 12,
                          ),
                        Text(
                          getFormattedRecordCreateDateTime(
                            record.createDateTime,
                          ),
                          style: Theme.of(context).textTheme.bodyText2.copyWith(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

String getFormattedRecordCreateDateTime(DateTime dateTime) {
  return DateFormat.Hm().format(dateTime);
}
