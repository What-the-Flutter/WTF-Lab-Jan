import 'package:chat_journal/tabs/home_tab/hometab_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../model/category.dart';

class CategoryEditPage extends StatelessWidget {
  final Category category;
  final _textEditingController = TextEditingController();
  final _categoryNameFocus = FocusNode();

  CategoryEditPage(this.category) {
    _textEditingController.text = category.name;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () {
              BlocProvider.of<HometabCubit>(context).updateCategory(
                  category, category.icon, _textEditingController.text);
              Navigator.of(context).pop();
            },
          ),
        ],
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text('Edit category'),
      ),
      body: Form(
        child: Column(
          children: [
            TextFormField(
              focusNode: _categoryNameFocus..requestFocus(),
              controller: _textEditingController,
            ),
          ],
        ),
      ),
    );
  }
}
