import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../model/category.dart';
import '../settings/cubit/settings_cubit.dart';
import '../shared/widgets/records_list_view.dart';
import 'cubit/records_cubit.dart';
import 'widgets/create_record_form.dart';
import 'widgets/default_app_bar.dart';
import 'widgets/edit_mode_app_bar.dart';
import 'widgets/record_create_date_time_choice_button.dart';
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
              : state.records.map((e) => e.record.isSelected).contains(true)
                  ? state is RecordUpdateInProcess
                      ? editModeAppBar(
                          context,
                          categoryId: widget.category.id,
                          controller: _textEditingController,
                        )
                      : selectRecordAppBar(
                          context,
                          records: state.records,
                          messageFocus: _messageFocus,
                          controller: _textEditingController,
                          category: widget.category,
                          setCreateRecordDateTime: setCreateRecordDateTime,
                        )
                  : defaultAppBar(
                      context,
                      state: state,
                      categoryId: widget.category.id,
                      categoryName: widget.category.name,
                    ),
          body: SafeArea(
            child: Column(
              verticalDirection: VerticalDirection.up,
              children: [
                CreateRecordForm(
                  formKey: _formKey,
                  textEditingController: _textEditingController,
                  messageFocus: _messageFocus,
                  categoryId: widget.category.id,
                  createRecordDateTime: createRecordDateTime,
                ),
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
                              withCategories: false,
                              isOnSearchPage: false,
                            ),
                            if (settingsState
                                .showCreateRecordDateTimePickerButton)
                              Padding(
                                padding: const EdgeInsets.all(4),
                                child: RecordCreateDateTimeChoiceButton(
                                  createRecordDateTime: createRecordDateTime,
                                  setCreateRecordDateTime:
                                      setCreateRecordDateTime,
                                ),
                              ),
                          ],
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
