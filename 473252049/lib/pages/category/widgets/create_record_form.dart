import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../model/record.dart';
import '../../settings/cubit/settings_cubit.dart';
import '../cubit/records_cubit.dart';
import '../dialogs/choose_image_source_dialog.dart';
import '../dialogs/create_image_record_dialog.dart';
import 'message_text_form_field.dart';

class CreateRecordForm extends StatelessWidget {
  final TextEditingController textEditingController;
  final FocusNode messageFocus;
  final int categoryId;
  final DateTime createRecordDateTime;
  final GlobalKey<FormState> formKey;

  const CreateRecordForm({
    Key key,
    @required this.textEditingController,
    @required this.messageFocus,
    @required this.categoryId,
    @required this.createRecordDateTime,
    @required this.formKey,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: BlocBuilder<RecordsCubit, RecordsState>(
        builder: (context, state) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (!(state is RecordUpdateInProcess))
                IconButton(
                  icon: Icon(Icons.photo),
                  onPressed: () async {
                    final imageSource =
                        await showChooseImageSourceDialog(context);
                    if (imageSource == null) return;
                    final image = await getImage(imageSource);
                    if (image == null) return;
                    showCreateImageRecordDialog(
                      context: context,
                      image: image,
                      textEditingController: textEditingController,
                      messageFocus: messageFocus,
                      categoryId: categoryId,
                    );
                  },
                ),
              Expanded(
                child: MessageTextFormField(
                  focusNode: messageFocus,
                  controller: textEditingController,
                ),
              ),
              BlocBuilder<SettingsCubit, SettingsState>(
                builder: (context, settingsState) {
                  return IconButton(
                    icon: state is RecordUpdateInProcess
                        ? Icon(Icons.check)
                        : Icon(Icons.send),
                    onPressed: () async {
                      if (formKey.currentState.validate()) {
                        if (state is RecordUpdateInProcess) {
                          await context.read<RecordsCubit>().update(
                                state.record.copyWith(
                                  message: textEditingController.text.trim(),
                                  createDateTime: settingsState
                                          .showCreateRecordDateTimePickerButton
                                      ? createRecordDateTime
                                      : state.record.createDateTime,
                                ),
                                categoryId: categoryId,
                              );
                          context.read<RecordsCubit>().unselectAll(
                                categoryId: categoryId,
                              );
                          messageFocus.unfocus();
                        } else {
                          context.read<RecordsCubit>().add(
                                Record(
                                  textEditingController.text.trim(),
                                  categoryId: categoryId,
                                  createDateTime: settingsState
                                          .showCreateRecordDateTimePickerButton
                                      ? createRecordDateTime
                                      : DateTime.now(),
                                ),
                                categoryId: categoryId,
                              );
                        }
                        textEditingController.clear();
                      }
                    },
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
