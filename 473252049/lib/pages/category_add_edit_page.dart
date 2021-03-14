import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../cubits/categories/categories_cubit.dart';
import '../model/category.dart';

enum CategoryAddEditMode { add, edit }

class CategoryAddEditPage extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _textEditingController = TextEditingController();
  final FocusNode _categoryNameFocus = FocusNode();
  final CategoryAddEditMode mode;
  final Category category;

  CategoryAddEditPage({Key key, @required this.mode, this.category})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (mode == CategoryAddEditMode.edit) {
      _textEditingController.text = category.name;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(mode == CategoryAddEditMode.add
            ? 'Add category'
            : mode == CategoryAddEditMode.edit
                ? 'Edit category'
                : null),
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () {
              if (_formKey.currentState.validate()) {
                if (mode == CategoryAddEditMode.add) {
                  context.read<CategoriesCubit>().add(
                        category: Category(
                          _textEditingController.text.trim(),
                          icon: Icons.access_alarm,
                        ),
                      );
                } else if (mode == CategoryAddEditMode.edit) {
                  context.read<CategoriesCubit>().update(
                        category.copyWith(
                          name: _textEditingController.text.trim(),
                        ),
                      );
                }
                Navigator.of(context).pop();
              }
            },
          ),
        ],
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
