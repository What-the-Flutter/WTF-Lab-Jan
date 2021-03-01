import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../blocs/category_bloc/category_bloc.dart';
import '../model/category.dart';
import '../model/record.dart';
import '../views/record_view.dart';

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
  void initState() {
    BlocProvider.of<CategoryBloc>(context).add(
      AllRecordsUnselected(),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryBloc, CategoryState>(
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
                            BlocProvider.of<CategoryBloc>(context).add(
                              RecordUpdateCancelled(),
                            );
                            BlocProvider.of<CategoryBloc>(context).add(
                              AllRecordsUnselected(),
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
                        onPressed: () {
                          BlocProvider.of<CategoryBloc>(context)
                              .add(AllRecordsUnselected());
                        },
                        icon: Icon(Icons.close),
                      ),
                      actions: [
                        if (widget.category.selectedRecords.length < 2)
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              BlocProvider.of<CategoryBloc>(context).add(
                                RecordUpdateStarted(
                                    widget.category.selectedRecords.first),
                              );
                              _textEditingController.text =
                                  widget.category.selectedRecords.first.message;
                              _messageFocus.requestFocus();
                            },
                          ),
                        IconButton(
                          icon: Icon(Icons.bookmark_outlined),
                          onPressed: () {
                            for (var r in widget.category.selectedRecords) {
                              BlocProvider.of<CategoryBloc>(context).add(
                                RecordFavoriteChanged(r),
                              );
                            }
                          },
                        ),
                        Builder(
                          builder: (context) => IconButton(
                            icon: Icon(Icons.copy),
                            onPressed: () {
                              BlocProvider.of<CategoryBloc>(context).add(
                                  RecordsCopied(
                                      widget.category.selectedRecords));
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
                            showDialog(
                              context: context,
                              builder: (newContext) {
                                return AlertDialog(
                                  title: Text('Delete records?'),
                                  actions: [
                                    TextButton(
                                      child: Text("Don't"),
                                      onPressed: () {
                                        BlocProvider.of<CategoryBloc>(context)
                                            .add(
                                          RecordsDeleteCancelled(),
                                        );
                                        Navigator.of(newContext).pop();
                                      },
                                    ),
                                    TextButton(
                                      child: Text('Delete'),
                                      onPressed: () {
                                        BlocProvider.of<CategoryBloc>(context)
                                            .add(
                                          RecordsDeleted(
                                              widget.category.selectedRecords),
                                        );
                                        Navigator.of(newContext).pop();
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        )
                      ],
                    )
              : AppBar(
                  title: Text(widget.category.name),
                ),
          body: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  reverse: true,
                  itemCount: widget.category.records.length,
                  itemBuilder: (context, index) {
                    return RecordView(widget.category.records[index]);
                  },
                ),
              ),
              Form(
                key: _formKey,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: Icon(Icons.photo),
                      onPressed: () async {
                        await getImage();
                        if (_image == null) return;
                        showDialog(
                          context: context,
                          builder: (newContext) {
                            return AlertDialog(
                              actions: [
                                TextButton(
                                  child: Text('Send'),
                                  onPressed: () {
                                    BlocProvider.of<CategoryBloc>(context).add(
                                      RecordAdded(
                                        Record(_textEditingController.text,
                                            image: _image),
                                      ),
                                    );
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                              content: Container(
                                child: Image.file(_image),
                                constraints: BoxConstraints(
                                  maxHeight: 400,
                                ),
                              ),
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
                            BlocProvider.of<CategoryBloc>(context).add(
                              RecordUpdated(state.record,
                                  _textEditingController.text.trim()),
                            );
                            _messageFocus.unfocus();
                          } else {
                            BlocProvider.of<CategoryBloc>(context).add(
                              RecordAdded(
                                Record(_textEditingController.text.trim()),
                              ),
                            );
                          }
                          _textEditingController.clear();
                        }
                      },
                      icon: Icon(Icons.send),
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

class MessageTextFormField extends StatelessWidget {
  final FocusNode focusNode;
  final TextEditingController controller;

  const MessageTextFormField({Key key, this.focusNode, this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
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
    );
  }
}
