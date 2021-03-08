import 'package:bubble/bubble.dart';
import 'package:chat_journal/chats/cubit/chats_cubit.dart';
import 'package:chat_journal/model/category.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../model/record.dart';

class RecordWidget extends StatelessWidget {
  final Category category;
  final Record record;

  const RecordWidget({Key key, @required this.record, this.category})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onLongPress: () {
        if (category == null) return;
        context.read<ChatsCubit>().selectRecord(category, record);
      },
      onTap: () {
        if (category == null) return;
        if (category.hasSelectedRecords) {
          if (record.isSelected) {
            context.read<ChatsCubit>().unselectRecord(category, record);
          } else {
            context.read<ChatsCubit>().selectRecord(category, record);
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
  }
}
