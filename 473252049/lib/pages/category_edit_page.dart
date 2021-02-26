import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/home_page_bloc/homepage_bloc.dart';
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
              BlocProvider.of<HomepageBloc>(context).add(
                CategoryUpdated(
                  category,
                  newIconData: category.icon,
                  newName: _textEditingController.text,
                ),
              );
              Navigator.of(context).pop();
            },
          ),
        ],
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            BlocProvider.of<HomepageBloc>(context).add(
              CategoryUpdateCancelled(),
            );
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
