import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/category.dart';
import '../main/tabs/home/cubit/categories_cubit.dart';
import 'category_choose_icon_widget.dart';
import 'category_icons.dart';

enum CategoryAddEditMode { add, edit }

class CategoryAddEditPage extends StatefulWidget {
  final CategoryAddEditMode mode;
  final Category category;
  final IconData defaultIconData;

  CategoryAddEditPage(
      {Key key, @required this.mode, this.category, this.defaultIconData})
      : super(key: key);

  @override
  _CategoryAddEditPageState createState() => _CategoryAddEditPageState();
}

class _CategoryAddEditPageState extends State<CategoryAddEditPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _textEditingController = TextEditingController();

  final FocusNode _categoryNameFocus = FocusNode();

  IconData iconData;

  @override
  void initState() {
    iconData = widget.defaultIconData ?? categoryIcons.first;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.mode == CategoryAddEditMode.edit) {
      _textEditingController.text = widget.category.name;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.mode == CategoryAddEditMode.add
            ? 'Add category'
            : widget.mode == CategoryAddEditMode.edit
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
                if (widget.mode == CategoryAddEditMode.add) {
                  context.read<CategoriesCubit>().add(
                        category: Category(
                          _textEditingController.text.trim(),
                          icon: iconData,
                        ),
                      );
                } else if (widget.mode == CategoryAddEditMode.edit) {
                  context.read<CategoriesCubit>().update(
                        widget.category.copyWith(
                          name: _textEditingController.text.trim(),
                          icon: iconData,
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
            Expanded(
              child: GridView.builder(
                itemCount: categoryIcons.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4),
                itemBuilder: (context, index) {
                  if (categoryIcons[index] == iconData) {
                    return CategoryChooseIconWidget(
                      iconData: categoryIcons[index],
                      backgroundColor: Colors.grey,
                    );
                  }
                  return GestureDetector(
                    child: CategoryChooseIconWidget(
                      iconData: categoryIcons[index],
                    ),
                    onTap: () {
                      setState(() {
                        iconData = categoryIcons[index];
                      });
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
