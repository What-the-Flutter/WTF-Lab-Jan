import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'category.dart';
import 'main.dart';

class CreateCategory extends StatefulWidget {
  CreateCategory({Key? key, this.index}) : super(key: key);
  final int? index;
  @override
  _CreateCategoryState createState() => _CreateCategoryState();
}

class _CreateCategoryState extends State<CreateCategory> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late FocusNode node;
  Categories? _categories;

  @override
  void initState() {
    super.initState();
    if (widget.index != null) {
      final category = context.read<CategoryList>().list[widget.index!];
      _titleController = TextEditingController(text: category.title);
      _descriptionController = TextEditingController(text: category.descripton);
      _categories = category.categories;
    } else {
      _titleController = TextEditingController();
      _descriptionController = TextEditingController();
    }
    Future.delayed(Duration.zero, () => node = FocusScope.of(context));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Flexible(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: TextField(
                  controller: _titleController,
                  style: TextStyle(color: Colors.grey, fontSize: 18),
                  textInputAction: TextInputAction.next,
                  onEditingComplete: () => node.nextFocus(),
                  decoration: InputDecoration(
                    hintText: 'Title',
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 18),
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey,
                        width: 2,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: TextField(
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                  controller: _descriptionController,
                  maxLines: null,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => node.unfocus(),
                  decoration: InputDecoration(
                    hintText: 'Description',
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 16),
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey,
                        width: 2,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            _categoryList(),
          ],
        ),
        floatingActionButton: _categories == null
            ? FloatingActionButton(
                onPressed: () => Navigator.pop(context),
                child: Icon(Icons.close),
              )
            : FloatingActionButton(
                onPressed: () {
                  if (widget.index == null) {
                    context.read<CategoryList>().add(_categories!,
                        _descriptionController.text, _titleController.text);
                  } else {
                    context.read<CategoryList>().update(
                        widget.index!,
                        _descriptionController.text,
                        _titleController.text,
                        _categories!);
                  }

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MyHomePage(),
                    ),
                  );
                },
                child: Icon(Icons.done),
              ),
      ),
    );
  }

  Expanded _categoryList() {
    return Expanded(
      child: GridView(
        physics: NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(10),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
        ),
        children: Categories.values.map(
          (value) {
            return GestureDetector(
              child: _categories == value
                  ? Container(
                      decoration: BoxDecoration(
                        border:
                            Border.all(width: 2, color: Colors.lime.shade900),
                        borderRadius: BorderRadius.circular(20),
                        image: DecorationImage(
                          image: AssetImage(value.img),
                          fit: BoxFit.cover,
                        ),
                      ),
                    )
                  : Image.asset(value.img),
              onTap: () {
                setState(
                  () {
                    if (_categories != null) {
                      _categories = null;
                    }
                    _categories = value;
                  },
                );
              },
            );
          },
        ).toList(),
      ),
    );
  }
}
