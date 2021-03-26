import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../model/record.dart';
import '../cubit/records_cubit.dart';
import '../widgets/message_text_form_field.dart';

Future showCreateImageRecordDialog({
  @required BuildContext context,
  @required File image,
  @required TextEditingController textEditingController,
  @required FocusNode messageFocus,
  @required int categoryId,
}) {
  return showDialog(
    context: context,
    builder: (newContext) {
      return SimpleDialog(
        contentPadding: EdgeInsets.all(2),
        children: [
          ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(4),
              topRight: Radius.circular(4),
              bottomLeft: Radius.circular(2),
              bottomRight: Radius.circular(2),
            ),
            child: Image.file(image),
          ),
          Row(
            children: [
              Expanded(
                child: MessageTextFormField(
                  controller: textEditingController,
                  focusNode: messageFocus,
                ),
              ),
              IconButton(
                icon: Icon(Icons.send),
                onPressed: () async {
                  await context.read<RecordsCubit>().add(
                        Record(
                          textEditingController.text,
                          categoryId: categoryId,
                          image: image,
                        ),
                        categoryId: categoryId,
                      );
                  textEditingController.clear();
                  Navigator.of(context).pop();
                },
              )
            ],
          ),
        ],
      );
    },
  );
}
