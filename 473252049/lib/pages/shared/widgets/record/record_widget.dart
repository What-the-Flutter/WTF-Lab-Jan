import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../model/category.dart';
import '../../../../model/record.dart';
import '../../../category/cubit/records_cubit.dart';
import 'record_widget_content.dart';

class RecordWidget extends StatefulWidget {
  final Category category;
  final Record record;
  final bool isDateRecord;
  final Alignment bubbleAlignment;
  final bool withCategory;
  final Future<Category> futureCategory;

  const RecordWidget({
    Key key,
    this.record,
    this.category,
    this.isDateRecord = false,
    this.bubbleAlignment = Alignment.centerRight,
    this.withCategory = false,
    this.futureCategory,
  }) : super(key: key);

  @override
  _RecordWidgetState createState() => _RecordWidgetState();
}

class _RecordWidgetState extends State<RecordWidget> {
  Category category;

  @override
  void initState() {
    if (category == null) {
      setCategory();
    }
    super.initState();
  }

  void setCategory() async {
    category = await Future(() => widget.futureCategory);
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecordsCubit, RecordsState>(
      builder: (context, state) {
        return GestureDetector(
          behavior: HitTestBehavior.translucent,
          onLongPress: () {
            if (widget.isDateRecord) return;
            context.read<RecordsCubit>().select(widget.record);
          },
          onTap: () {
            if (widget.isDateRecord) return;
            if (state.records.map((e) => e.isSelected).contains(true)) {
              if (widget.record.isSelected) {
                context.read<RecordsCubit>().unselect(widget.record);
              } else {
                context.read<RecordsCubit>().select(widget.record);
              }
            }
          },
          child: RecordWidgetContent(
            isSelected: widget.record.isSelected,
            isFavorite: widget.record.isFavorite,
            bubbleAlignment: widget.bubbleAlignment,
            image: widget.record.image,
            message: widget.record.message,
            isDateRecord: widget.isDateRecord,
            records: state.records,
            createDateTime: widget.record.createDateTime,
            withCategory: widget.withCategory,
            categoryName: category?.name,
            categoryId: category?.id,
          ),
        );
      },
    );
  }
}
