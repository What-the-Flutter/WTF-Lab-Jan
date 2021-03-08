import 'dart:io';

import 'package:chat_journal/pages/search_record_page.dart';
import 'package:chat_journal/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../model/category.dart';
import '../model/record.dart';
import '../widgets/record_widget.dart';
import 'chats_cubit/chats_cubit.dart';

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
    context.read<ChatsCubit>().unselectAllRecords(widget.category);
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatsCubit, ChatsState>(
      builder: (context, state) {
        return Scaffold(
          appBar: widget.category.hasSelectedRecords
              ? state is RecordUpdateInProcess
                  ? AppBar(
                      title: Text('Edit mode'),
                      actions: [
                        IconButton(
                          icon: Icon(Icons.close),
                          onPressed: () {
                            context
                                .read<ChatsCubit>()
                                .unselectAllRecords(widget.category);
                            _textEditingController.clear();
                            FocusScope.of(context).unfocus();
                          },
                        ),
                      ],
                    )
                  : AppBar(
                      title: Text('Select'),
                      leading: IconButton(
                        onPressed: () {
                          context
                              .read<ChatsCubit>()
                              .unselectAllRecords(widget.category);
                        },
                        icon: Icon(Icons.close),
                      ),
                      actions: [
                        if (widget.category.selectedRecords.length < 2)
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              context.read<ChatsCubit>().beginUpdateRecord(
                                  widget.category,
                                  widget.category.selectedRecords.first);

                              _textEditingController.text =
                                  widget.category.selectedRecords.first.message;
                              _messageFocus.requestFocus();
                            },
                          ),
                        ShareRecordIconButton(
                          categoryFrom: widget.category,
                        ),
                        IconButton(
                          icon: Icon(Icons.bookmark_outlined),
                          onPressed: () {
                            context.read<ChatsCubit>().changeFavoriteRecords(
                                widget.category,
                                widget.category.selectedRecords);
                            context
                                .read<ChatsCubit>()
                                .unselectAllRecords(widget.category);
                          },
                        ),
                        Builder(
                          builder: (context) => IconButton(
                            icon: Icon(Icons.copy),
                            onPressed: () {
                              copyToClipboard(widget.category.selectedRecords);
                              context
                                  .read<ChatsCubit>()
                                  .unselectAllRecords(widget.category);
                              Scaffold.of(context).showSnackBar(
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
                              records: widget.category.records,
                              category: widget.category),
                        );
                      },
                    ),
                  ],
                ),
          body: Column(
            children: [
              Expanded(
                child: RecordsListViewWithCubit(
                  records: widget.category.records,
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
                                          onPressed: () {
                                            context
                                                .read<ChatsCubit>()
                                                .addRecord(
                                                  widget.category,
                                                  Record(
                                                      _textEditingController
                                                          .text,
                                                      image: _image),
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
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          if (state is RecordUpdateInProcess) {
                            context.read<ChatsCubit>().updateRecord(
                                  widget.category,
                                  widget.category.selectedRecords.first,
                                  newMessage: _textEditingController.text,
                                );
                            context
                                .read<ChatsCubit>()
                                .unselectAllRecords(widget.category);
                            _messageFocus.unfocus();
                          } else {
                            context.read<ChatsCubit>().addRecord(
                                widget.category,
                                Record(_textEditingController.text));
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

Future _showDeleteDialog(BuildContext context, {Category category}) {
  return showDialog(
    context: context,
    builder: (newContext) {
      return AlertDialog(
        title: Text('Delete records?'),
        actions: [
          TextButton(
            child: Text("Don't"),
            onPressed: () {
              context.read<ChatsCubit>().unselectAllRecords(category);
              Navigator.of(newContext).pop();
            },
          ),
          TextButton(
            child: Text('Delete'),
            onPressed: () {
              context
                  .read<ChatsCubit>()
                  .deleteRecords(category, category.selectedRecords);
              Navigator.of(newContext).pop();
            },
          ),
        ],
      );
    },
  );
}

class RecordsListViewWithCubit extends RecordsListView {
  RecordsListViewWithCubit({List<Record> records, Category category})
      : super(records: records, category: category);
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      reverse: true,
      itemCount: records.length,
      itemBuilder: (context, index) {
        return BlocProvider.value(
          value: context.read<ChatsCubit>(),
          child: RecordWidget(
            record: records[index],
            category: category,
          ),
        );
      },
    );
  }
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

class ShareRecordIconButton extends StatelessWidget {
  final Category categoryFrom;

  const ShareRecordIconButton({Key key, @required this.categoryFrom})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.share_outlined),
      onPressed: () {
        showDialog(
          context: context,
          builder: (newContext) {
            return SimpleDialog(
              children: [
                ...context.read<ChatsCubit>().state.categories.map(
                  (category) {
                    if (category == categoryFrom) {
                      return Container(
                        height: 0,
                      );
                    }
                    return ListTile(
                      title: Text(category.name),
                      onTap: () {
                        context.read<ChatsCubit>().sendRecord(
                              categoryFrom: categoryFrom,
                              categoryTo: category,
                              records: categoryFrom.selectedRecords,
                            );
                        context.read<ChatsCubit>().unselectAllRecords(category);
                        context.read<ChatsCubit>().sortCategory(category);
                        Navigator.of(context).pop();
                      },
                    );
                  },
                ).toList(),
              ],
            );
          },
        );
      },
    );
  }
}
