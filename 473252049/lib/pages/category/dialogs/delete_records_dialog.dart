import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../model/category.dart';
import '../cubit/records_cubit.dart';

class DeleteRecordsDialog extends StatelessWidget {
  final int categoryId;

  const DeleteRecordsDialog({Key key, this.categoryId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecordsCubit, RecordsState>(
      builder: (context, state) => AlertDialog(
        title: Text('Delete records?'),
        actions: [
          TextButton(
            child: Text("Don't"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text('Delete'),
            onPressed: () async {
              await context.read<RecordsCubit>().deleteAll(
                    state.records
                        .where(
                          (e) => e.isSelected,
                        )
                        .toList(),
                    categoryId: categoryId,
                  );
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}

Future showDeleteRecordsDialog(
  BuildContext context, {
  Category category,
}) {
  return showDialog(
    context: context,
    builder: (newContext) {
      return BlocProvider.value(
        value: context.read<RecordsCubit>(),
        child: DeleteRecordsDialog(
          categoryId: category?.id,
        ),
      );
    },
  );
}
