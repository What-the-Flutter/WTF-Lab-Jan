import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../model/category.dart';
import '../cubit/records_cubit.dart';
import '../dialogs/delete_records_dialog.dart';
import '../dialogs/send_records_dialog.dart';

AppBar selectRecordAppBar(
  BuildContext context, {
  List<RecordWithCategory> records,
  FocusNode messageFocus,
  TextEditingController controller,
  Category category,
  Function(DateTime) setCreateRecordDateTime,
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
      if (records
              .where(
                (element) => element.record.isSelected,
              )
              .length <
          2)
        IconButton(
          icon: Icon(Icons.edit),
          onPressed: () {
            setCreateRecordDateTime(records
                .where(
                  (element) => element.record.isSelected,
                )
                .first
                .record
                .createDateTime);
            context.read<RecordsCubit>().beginUpdate(
                records
                    .firstWhere(
                      (element) => element.record.isSelected,
                    )
                    .record,
                categoryId: category.id);

            controller.text = records
                .firstWhere((element) => element.record.isSelected)
                .record
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
                records
                    .where(
                      (element) => element.record.isSelected,
                    )
                    .map((e) => e.record)
                    .toList(),
                categoryId: category.id,
              );
          await context.read<RecordsCubit>().unselectAll(
                records: records.map((e) => e.record).toList(),
                categoryId: category.id,
              );
        },
      ),
      Builder(
        builder: (context) => IconButton(
          icon: Icon(Icons.copy),
          onPressed: () {
            context.read<RecordsCubit>().copyToClipboard(
                records: records
                    .where(
                      (element) => element.record.isSelected,
                    )
                    .map((e) => e.record)
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
