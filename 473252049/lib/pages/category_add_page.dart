import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/home_page_bloc/homepage_bloc.dart';
import '../model/category.dart';

class CategoryAddPage extends StatelessWidget {
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
              BlocProvider.of<HomepageBloc>(context).add(
                CategoryAdded(
                  Category(_textEditingController.text, icon: _defaultIcon),
                ),
              );
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
        title: Text('Add category'),
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
