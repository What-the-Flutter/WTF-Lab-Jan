import 'package:chat_journal/tabs/home_tab/hometab_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../model/category.dart';

class CategoryAddPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final _defaultIcon = Icons.ac_unit;
  final _textEditingController = TextEditingController();
  final FocusNode _categoryNameFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () {
              if (_formKey.currentState.validate()) {
                BlocProvider.of<HometabCubit>(context).addCategory(
                    Category(_textEditingController.text, icon: _defaultIcon));
                Navigator.of(context).pop();
              }
            },
          ),
        ],
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text('Add category'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              maxLength: 14,
              validator: (value) {
                if (value.trim().isEmpty) {
                  return "Category name can't be empty";
                }
                return null;
              },
              focusNode: _categoryNameFocus..requestFocus(),
              controller: _textEditingController,
            ),
          ],
        ),
      ),
    );
  }
}
