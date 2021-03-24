import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../model/category.dart';
import '../../../model/record.dart';
import '../../main/tabs/home/cubit/categories_cubit.dart';
import '../cubit/records_cubit.dart';

class RecordWidget extends StatefulWidget {
  final Category category;
  final Record record;
  final bool isDateRecord;
  final Alignment bubbleAlignment;
  final bool withCategory;

  const RecordWidget({
    Key key,
    this.record,
    this.category,
    this.isDateRecord = false,
    this.bubbleAlignment = Alignment.centerRight,
    this.withCategory = false,
  }) : super(key: key);

  @override
  _RecordWidgetState createState() => _RecordWidgetState(category: category);
}

class _RecordWidgetState extends State<RecordWidget> {
  Category category;

  _RecordWidgetState({this.category});

  void setCategory() async {
    category = await context.read<CategoriesCubit>().getById(
          widget.record.categoryId,
        );
    if (mounted) setState(() {});
  }

  @override
  void initState() {
    super.initState();
    if (widget?.withCategory ?? false) {
      setCategory();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecordsCubit, RecordsState>(
      builder: (context, state) {
        return GestureDetector(
          behavior: HitTestBehavior.translucent,
          onLongPress: () {
            context.read<RecordsCubit>().select(
                  widget.record,
                );
          },
          onTap: () {
            if (state.records
                .map(
                  (e) => e.isSelected,
                )
                .contains(true)) {
              if (widget.record.isSelected) {
                context.read<RecordsCubit>().unselect(
                      widget.record,
                    );
              } else {
                context.read<RecordsCubit>().select(
                      widget.record,
                    );
              }
            }
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 1.5),
            child: Bubble(
              color: widget.record.isSelected
                  ? Theme.of(context).scaffoldBackgroundColor
                  : Theme.of(context).backgroundColor,
              alignment: widget.bubbleAlignment,
              child: Column(
                crossAxisAlignment:
                    widget.bubbleAlignment == Alignment.centerRight
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                children: [
                  if (widget.record.image != null)
                    Container(
                      constraints: BoxConstraints(maxHeight: 400),
                      child: Image.file(widget.record.image),
                    ),
                  if (widget.record.message.isNotEmpty)
                    Text(
                      widget.record.message,
                      textAlign: widget.bubbleAlignment == Alignment.centerRight
                          ? TextAlign.end
                          : TextAlign.start,
                    ),
                  if (!widget.isDateRecord)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment:
                          widget.bubbleAlignment == Alignment.centerRight
                              ? MainAxisAlignment.end
                              : MainAxisAlignment.start,
                      children: [
                        if (widget.record.isFavorite)
                          Icon(
                            Icons.bookmark,
                            size: 12,
                          ),
                        Text(
                          getFormattedRecordCreateDateTime(
                            widget.record.createDateTime,
                          ),
                          style: Theme.of(context).textTheme.bodyText2.copyWith(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              ),
                        ),
                      ],
                    ),
                  if (!widget.isDateRecord &&
                      widget.withCategory == true &&
                      category != null)
                    Text(
                      category?.name,
                      style: Theme.of(context).textTheme.bodyText2.copyWith(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
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
