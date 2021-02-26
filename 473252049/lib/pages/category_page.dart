import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
                              BlocProvider.of<CategoryBloc>(context)
                                  .add(RecordFavoriteChanged(r));
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
                      onPressed: () {},
                    ),
                    Expanded(
                      child: TextFormField(
                        decoration: InputDecoration(
                          hintText: 'Your record',
                        ),
                        minLines: 1,
                        maxLines: 8,
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Record can't be empty";
                          }
                          return null;
                        },
                        focusNode: _messageFocus,
                        controller: _textEditingController,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          if (state is RecordUpdateInProcess) {
                            BlocProvider.of<CategoryBloc>(context).add(
                              RecordUpdated(
                                  state.record, _textEditingController.text),
                            );
                            _messageFocus.unfocus();
                          } else {
                            BlocProvider.of<CategoryBloc>(context).add(
                              RecordAdded(
                                Record(_textEditingController.text),
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
              if (Platform.isIOS &&
                  MediaQuery.of(context).viewInsets.bottom == 0)
                Container(
                  height: 24,
                ),
            ],
          ),
        );
      },
    );
  }
}
