import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../model/category.dart';
import '../cubit/records_cubit.dart';
import '../dialogs/delete_records_dialog.dart';
import '../dialogs/send_records_dialog.dart';

AppBar selectRecordAppBar(
  BuildContext context, {
  RecordsState recordsState,
  FocusNode messageFocus,
  TextEditingController controller,
  Category category,
  void Function(DateTime) setRecordCreateDateTime,
}) {
  return AppBar(
    title: Text('Select'),
    leading: IconButton(
      icon: Icon(Icons.close),
      onPressed: () {
        context.read<RecordsCubit>().unselectAll(
              categoryId: category.id,
            );
      },
    ),
    actions: [
      if (recordsState.records
              .where(
                (element) => element.isSelected,
              )
              .length <
          2)
        IconButton(
          icon: Icon(Icons.edit),
          onPressed: () {
            setRecordCreateDateTime(recordsState.records
                .where(
                  (element) => element.isSelected,
                )
                .first
                .createDateTime);
            context.read<RecordsCubit>().beginUpdate(
                recordsState.records.firstWhere(
                  (element) => element.isSelected,
                ),
                categoryId: category.id);

            controller.text = recordsState.records
                .firstWhere((element) => element.isSelected)
                .message;
            messageFocus.requestFocus();
          },
        ),
      IconButton(
        icon: Icon(Icons.share),
        onPressed: () {
          showSendRecordsDialog(
            context,
            category: category,
          );
        },
      ),
      IconButton(
        icon: Icon(Icons.bookmark_outlined),
        onPressed: () async {
          await context.read<RecordsCubit>().changeFavorite(
                recordsState.records
                    .where(
                      (element) => element.isSelected,
                    )
                    .toList(),
                categoryId: category.id,
              );
          await context.read<RecordsCubit>().unselectAll(
                records: recordsState.records,
                categoryId: category.id,
              );
        },
      ),
      Builder(
        builder: (context) => IconButton(
          icon: Icon(Icons.copy),
          onPressed: () {
            context.read<RecordsCubit>().copyToClipboard(
                records: recordsState.records
                    .where(
                      (element) => element.isSelected,
                    )
                    .toList());
            context.read<RecordsCubit>().unselectAll(
                  categoryId: category.id,
                );
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Copied to clipboard'),
                action: SnackBarAction(
                  label: 'OK',
                  onPressed: () {},
                ),
              ),
            );
          },
        ),
      ),
      IconButton(
        icon: Icon(Icons.delete),
        onPressed: () {
          showDeleteRecordsDialog(
            context,
            category: category,
          );
        },
      )
    ],
  );
}
