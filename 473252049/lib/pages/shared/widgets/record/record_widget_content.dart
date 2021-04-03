import 'dart:io';

import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';

import '../../../category/cubit/records_cubit.dart';
import '../message_rich_text.dart';
import 'record_category_name.dart';
import 'record_info_row.dart';

class RecordWidgetContent extends StatelessWidget {
  final bool isSelected;
  final bool isFavorite;
  final Alignment bubbleAlignment;
  final File image;
  final String message;
  final bool isDateRecord;
  final List<RecordWithCategory> records;
  final DateTime createDateTime;
  final bool withCategory;
  final String categoryName;
  final int categoryId;

  const RecordWidgetContent({
    Key key,
    @required this.isSelected,
    @required this.isFavorite,
    @required this.bubbleAlignment,
    @required this.image,
    @required this.message,
    @required this.isDateRecord,
    @required this.records,
    @required this.createDateTime,
    @required this.withCategory,
    @required this.categoryName,
    @required this.categoryId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Bubble(
        padding: BubbleEdges.zero,
        radius: Radius.circular(8),
        color: isSelected
            ? Theme.of(context).scaffoldBackgroundColor
            : Theme.of(context).backgroundColor,
        alignment: bubbleAlignment,
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.75,
            ),
            child: Column(
              crossAxisAlignment: bubbleAlignment == Alignment.centerRight
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                if (image != null)
                  Container(
                    constraints: BoxConstraints(
                      maxHeight: 400,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(4),
                        topRight: Radius.circular(4),
                        bottomLeft: Radius.circular(2),
                        bottomRight: Radius.circular(2),
                      ),
                      child: Image.file(
                        image,
                      ),
                    ),
                  ),
                Padding(
                  padding: EdgeInsets.only(
                    top: image == null ? 0 : 2,
                  ),
                  child: Column(
                    crossAxisAlignment: bubbleAlignment == Alignment.centerRight
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                    children: [
                      if (message.isNotEmpty && !isDateRecord)
                        MessageRichText(
                          key: UniqueKey(),
                          message: message,
                          records: records,
                        ),
                      if (isDateRecord)
                        Text(
                          message,
                          textAlign: TextAlign.center,
                        ),
                      if (!isDateRecord)
                        RecordInfoRow(
                          bubbleAlignment: bubbleAlignment,
                          isFavorite: isFavorite,
                          recordCreateDateTime: createDateTime,
                        ),
                      if (!isDateRecord && withCategory)
                        RecordCategoryName(
                          categoryName: categoryName,
                          categoryId: categoryId,
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
