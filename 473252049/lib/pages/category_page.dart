import 'dart:io';

import 'package:chat_journal/cubits/categories/categories_cubit.dart';
import 'package:chat_journal/cubits/records/records_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../model/category.dart';
import '../model/record.dart';
import '../utils/utils.dart';
import '../widgets/record_widget.dart';
import 'search_record_page.dart';

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

  File _image;
  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  void deactivate() {
    context.read<RecordsCubit>().unselectAll(
          categoryId: widget.category.id,
        );
    super.deactivate();
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
                      ? AppBar(
                          title: Text('Edit mode'),
                          actions: [
                            IconButton(
                              icon: Icon(Icons.close),
                              onPressed: () {
                                context.read<RecordsCubit>().unselectAll(
                                      categoryId: widget.category.id,
                                    );
                                _textEditingController.clear();
                                FocusScope.of(context).unfocus();
                              },
                            ),
                          ],
                        )
                      : AppBar(
                          title: Text('Select'),
                          leading: IconButton(
                            icon: Icon(Icons.close),
                            onPressed: () {
                              context.read<RecordsCubit>().unselectAll(
                                    categoryId: widget.category.id,
                                  );
                            },
                          ),
                          actions: [
                            if (state.records
                                    .where(
                                      (element) => element.isSelected,
                                    )
                                    .length <
                                2)
                              IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () {
                                  context.read<RecordsCubit>().beginUpdate(
                                      state.records.firstWhere(
                                        (element) => element.isSelected,
                                      ),
                                      categoryId: widget.category.id);

                                  _textEditingController.text = state.records
                                      .firstWhere(
                                          (element) => element.isSelected)
                                      .message;
                                  _messageFocus.requestFocus();
                                },
                              ),
                            IconButton(
                              icon: Icon(Icons.share),
                              onPressed: () {
                                _showSendRecordsDialog(
                                  context,
                                  category: widget.category,
                                );
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.bookmark_outlined),
                              onPressed: () async {
                                await context
                                    .read<RecordsCubit>()
                                    .changeFavorite(
                                      state.records
                                          .where(
                                            (element) => element.isSelected,
                                          )
                                          .toList(),
                                      categoryId: widget.category.id,
                                    );
                                await context.read<RecordsCubit>().unselectAll(
                                      records: state.records,
                                      categoryId: widget.category.id,
                                    );
                              },
                            ),
                            Builder(
                              builder: (context) => IconButton(
                                icon: Icon(Icons.copy),
                                onPressed: () {
                                  context.read<RecordsCubit>().copyToClipboard(
                                      records: state.records
                                          .where(
                                            (element) => element.isSelected,
                                          )
                                          .toList());
                                  context.read<RecordsCubit>().unselectAll(
                                        categoryId: widget.category.id,
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
                                _showDeleteDialog(
                                  context,
                                  category: widget.category,
                                );
                              },
                            )
                          ],
                        )
                  : AppBar(
                      title: Text(widget.category.name),
                      actions: [
                        IconButton(
                          icon: Icon(Icons.search),
                          onPressed: () {
                            showSearch(
                              context: context,
                              delegate: SerachRecordPage(
                                  records: state.records,
                                  category: widget.category),
                            );
                          },
                        ),
                      ],
                    ),
          body: Column(
            children: [
              if (state is RecordsLoadInProcess)
                Center(
                  child: CircularProgressIndicator(),
                ),
              if (!(state is RecordsLoadInProcess))
                Expanded(
                  child: RecordsListView(
                    records: state.records,
                    category: widget.category,
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
                          await getImage();
                          if (_image == null) return;
                          showDialog(
                            context: context,
                            builder: (newContext) {
                              return SimpleDialog(
                                children: [
                                  Container(
                                    constraints: BoxConstraints(maxHeight: 400),
                                    child: Image.file(_image),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: MessageTextFormField(
                                            controller: _textEditingController,
                                            focusNode: _messageFocus,
                                          ),
                                        ),
                                        IconButton(
                                          icon: Icon(Icons.send),
                                          onPressed: () async {
                                            await context
                                                .read<RecordsCubit>()
                                                .add(
                                                  Record(
                                                    _textEditingController.text,
                                                    categoryId:
                                                        widget.category.id,
                                                    image: _image,
                                                  ),
                                                );
                                            _textEditingController.clear();
                                            Navigator.of(context).pop();
                                          },
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    Expanded(
                      child: MessageTextFormField(
                        focusNode: _messageFocus,
                        controller: _textEditingController,
                      ),
                    ),
                    IconButton(
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          if (state is RecordUpdateInProcess) {
                            await context.read<RecordsCubit>().update(
                                  state.record.copyWith(
                                    message: _textEditingController.text.trim(),
                                  ),
                                  categoryId: widget.category.id,
                                );
                            context.read<RecordsCubit>().unselectAll(
                                  categoryId: widget.category.id,
                                );
                            _messageFocus.unfocus();
                          } else {
                            context.read<RecordsCubit>().add(
                                  Record(
                                    _textEditingController.text.trim(),
                                    categoryId: widget.category.id,
                                  ),
                                  categoryId: widget.category.id,
                                );
                          }
                          _textEditingController.clear();
                        }
                      },
                      icon: state is RecordUpdateInProcess
                          ? Icon(Icons.check)
                          : Icon(Icons.send),
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

class DeleteRecordDialog extends StatelessWidget {
  final int categoryId;

  const DeleteRecordDialog({Key key, this.categoryId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecordsCubit, RecordsState>(
      builder: (context, state) => AlertDialog(
        title: Text('Delete records?'),
        actions: [
          TextButton(
            child: Text("Don't"),
            onPressed: () {
              context.read<RecordsCubit>().unselectAll(
                    records: state.records,
                    categoryId: categoryId,
                  );
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

Future _showDeleteDialog(BuildContext context, {Category category}) {
  return showDialog(
    context: context,
    builder: (newContext) {
      return BlocProvider.value(
        value: context.read<RecordsCubit>(),
        child: DeleteRecordDialog(
          categoryId: category.id,
        ),
      );
    },
  );
}

class RecordsListView extends StatelessWidget {
  final List<Record> records;
  final Category category;

  const RecordsListView({Key key, @required this.records, this.category})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: ListView.builder(
        reverse: true,
        itemCount: records.length,
        itemBuilder: (context, index) {
          return RecordWidget(
            record: records[index],
            category: category,
          );
        },
      ),
    );
  }
}

class MessageTextFormField extends StatelessWidget {
  final FocusNode focusNode;
  final TextEditingController controller;

  const MessageTextFormField({Key key, this.focusNode, this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: TextFormField(
        decoration: InputDecoration(
          hintText: 'Your record',
        ),
        minLines: 1,
        maxLines: 8,
        validator: (value) {
          if (value.trim().isEmpty) {
            return "Record can't be empty";
          }
          return null;
        },
        focusNode: focusNode,
        controller: controller,
      ),
    );
  }
}

Future _showSendRecordsDialog(BuildContext context,
    {@required Category category}) {
  return showDialog(
    context: context,
    builder: (newContext) {
      return BlocProvider.value(
        value: context.read<CategoriesCubit>(),
        child: BlocProvider.value(
          value: context.read<RecordsCubit>(),
          child: SendRecordsDialog(
            categoryFrom: category,
          ),
        ),
      );
    },
  );
}

class SendRecordsDialog extends StatelessWidget {
  final Category categoryFrom;

  const SendRecordsDialog({Key key, this.categoryFrom}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecordsCubit, RecordsState>(
      builder: (context, state) {
        return SimpleDialog(
          children: [
            ...context.read<CategoriesCubit>().state.categories.map(
              (category) {
                if (category == categoryFrom) {
                  return Container(
                    height: 0,
                  );
                }
                return ListTile(
                  title: Text(category.name),
                  onTap: () async {
                    await context.read<RecordsCubit>().sendAll(
                          state.records
                              .where(
                                (element) => element.isSelected,
                              )
                              .toList(),
                          categoryId: categoryFrom.id,
                          categoryToId: category.id,
                        );
                    await context.read<RecordsCubit>().unselectAll(
                          categoryId: category.id,
                        );
                    await context
                        .read<RecordsCubit>()
                        .unselectAll(categoryId: categoryFrom.id);
                    Navigator.of(context).pop();
                  },
                );
              },
            ),
          ],
        );
      },
    );
  }
}
