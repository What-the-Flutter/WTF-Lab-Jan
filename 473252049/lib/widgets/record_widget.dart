import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../model/category.dart';
import '../model/record.dart';
import '../pages/cubits/records/records_cubit.dart';

class RecordWidget extends StatelessWidget {
  final Category category;
  final Record record;

  const RecordWidget({Key key, @required this.record, this.category})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecordsCubit, RecordsState>(
      builder: (context, state) {
        return GestureDetector(
          behavior: HitTestBehavior.translucent,
          onLongPress: () {
            if (category == null) return;
            context.read<RecordsCubit>().select(
                  record,
                  categoryId: category.id,
                );
          },
          onTap: () {
            if (category == null) return;
            if (state.records
                .map(
                  (e) => e.isSelected,
                )
                .contains(true)) {
              if (record.isSelected) {
                context.read<RecordsCubit>().unselect(
                      record,
                      categoryId: category.id,
                    );
              } else {
                context.read<RecordsCubit>().select(
                      record,
                      categoryId: category.id,
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
              alignment: Alignment.bottomRight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (record.image != null)
                    Container(
                      constraints: BoxConstraints(maxHeight: 400),
                      child: Image.file(record.image),
                    ),
                  if (record.message.isNotEmpty)
                    Text(
                      record.message,
                      textAlign: TextAlign.end,
                    ),
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
                        '${record.createDateTime.hour}:${record.createDateTime.minute}',
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
