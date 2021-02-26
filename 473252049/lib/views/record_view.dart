import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/category_bloc/category_bloc.dart';
import '../model/record.dart';

class RecordView extends StatelessWidget {
  final Record record;

  RecordView(this.record);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onLongPress: () {
        BlocProvider.of<CategoryBloc>(context).add(RecordSelectChanged(record));
      },
      onTap: () {
        if (BlocProvider.of<CategoryBloc>(context)
            .category
            .hasSelectedRecords) {
          return BlocProvider.of<CategoryBloc>(context)
              .add(RecordSelectChanged(record));
        }
      },
      child: Bubble(
        color: record.isSelected ? Colors.blueGrey : Colors.white,
        alignment: Alignment.bottomRight,
        child: BlocBuilder<CategoryBloc, CategoryState>(
          builder: (context, state) => Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
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
