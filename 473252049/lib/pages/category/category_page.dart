import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../model/category.dart';
import '../../model/record.dart';
import '../settings/cubit/settings_cubit.dart';
import 'cubit/records_cubit.dart';
import 'dialogs/choose_image_source_dialog.dart';
import 'dialogs/create_image_record_dialog.dart';
import 'dialogs/date_time_picker_dialog.dart';
import 'widgets/default_app_bar.dart';
import 'widgets/edit_mode_app_bar.dart';
import 'widgets/message_text_form_field.dart';
import 'widgets/records_list_view.dart';
import 'widgets/select_record_app_bar.dart';

class CategoryPage extends StatefulWidget {
  final Category category;

  CategoryPage(this.category);

  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  final _formKey = GlobalKey<FormState>();
  final _messageFocus = FocusNode();
  final _textEditingController = TextEditingController();
  DateTime createRecordDateTime = DateTime.now();

  void setCreateRecordDateTime(DateTime dateTime) {
    setState(() {
      createRecordDateTime = dateTime;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecordsCubit, RecordsState>(
      builder: (context, state) {
        return Scaffold(
          appBar: state is RecordsLoadInProcess
              ? AppBar(
                  title: Text(widget.category.name),
                )
              : state.records.map((e) => e.isSelected).contains(true)
                  ? state is RecordUpdateInProcess
                      ? editModeAppBar(
                          context,
                          categoryId: widget.category.id,
                          controller: _textEditingController,
                        )
                      : selectRecordAppBar(
                          context,
                          recordsState: state,
                          messageFocus: _messageFocus,
                          controller: _textEditingController,
                          category: widget.category,
                          setRecordCreateDateTime: setCreateRecordDateTime,
                        )
                  : defaultAppBar(
                      context,
                      state: state,
                      categoryId: widget.category.id,
                      categoryName: widget.category.name,
                    ),
          body: Column(
            children: [
              if (state is RecordsLoadInProcess)
                Center(
                  child: CircularProgressIndicator(),
                ),
              if (!(state is RecordsLoadInProcess))
                Expanded(
                  child: BlocBuilder<SettingsCubit, SettingsState>(
                    builder: (context, settingsState) {
                      return Stack(
                        alignment: settingsState.bubbleAlignment ==
                                Alignment.centerRight
                            ? AlignmentDirectional.topStart
                            : AlignmentDirectional.topEnd,
                        children: [
                          RecordsListView(
                            records: state.records,
                            category: widget.category,
                          ),
                          if (settingsState
                              .showCreateRecordDateTimePickerButton)
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4),
                              child: OutlinedButton(
                                onPressed: () async {
                                  final dateTime =
                                      await showDateTimePickerDialog(
                                    context,
                                    initialDateTime: createRecordDateTime,
                                  );
                                  setCreateRecordDateTime(dateTime);
                                },
                                child: Text(
                                  '${DateFormat.yMEd().add_Hm().format(createRecordDateTime)}',
                                ),
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                ),
              Form(
                key: _formKey,
                child: Row(
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
                            textEditingController: _textEditingController,
                            messageFocus: _messageFocus,
                            categoryId: widget.category.id,
                          );
                        },
                      ),
                    Expanded(
                      child: MessageTextFormField(
                        focusNode: _messageFocus,
                        controller: _textEditingController,
                      ),
                    ),
                    BlocBuilder<SettingsCubit, SettingsState>(
                      builder: (context, settingsState) {
                        return IconButton(
                          icon: state is RecordUpdateInProcess
                              ? Icon(Icons.check)
                              : Icon(Icons.send),
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              if (state is RecordUpdateInProcess) {
                                await context.read<RecordsCubit>().update(
                                      state.record.copyWith(
                                        message:
                                            _textEditingController.text.trim(),
                                        createDateTime: settingsState
                                                .showCreateRecordDateTimePickerButton
                                            ? createRecordDateTime
                                            : state.record.createDateTime,
                                      ),
                                      categoryId: widget.category.id,
                                    );
                                context.read<RecordsCubit>().unselectAll(
                                      categoryId: widget.category.id,
                                    );
                                _messageFocus.unfocus();
                              } else {
                                await context.read<RecordsCubit>().add(
                                      Record(
                                        _textEditingController.text.trim(),
                                        categoryId: widget.category.id,
                                        createDateTime: createRecordDateTime,
                                      ),
                                      categoryId: widget.category.id,
                                    );
                              }
                              _textEditingController.clear();
                            }
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
