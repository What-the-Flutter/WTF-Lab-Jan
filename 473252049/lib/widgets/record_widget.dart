import 'package:bubble/bubble.dart';
import 'package:chat_journal/pages/category/category_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

//import '../blocs/category_bloc/category_bloc.dart';
import '../model/record.dart';

class RecordWidget extends StatelessWidget {
  final Record record;

  const RecordWidget({Key key, this.record}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryCubit, CategoryState>(
      builder: (context, state) {
        return GestureDetector(
          behavior: HitTestBehavior.translucent,
          onLongPress: () {
            context.read<CategoryCubit>().selectRecord(record);
          },
          onTap: () {
            if (context
                .read<CategoryCubit>()
                .state
                .category
                .hasSelectedRecords) {
              if (record.isSelected) {
                BlocProvider.of<CategoryCubit>(context).unselectRecord(record);
              } else {
                BlocProvider.of<CategoryCubit>(context).selectRecord(record);
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
                  if (record.isFavorite)
                    Icon(
                      Icons.bookmark,
                      size: 12,
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
