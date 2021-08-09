import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../models/category.dart';
import '../utils/constants.dart';
import '../widgets/category_item.dart';

class NewCategoryArguments {
  final NoteCategory? category;

  NewCategoryArguments(this.category);
}

class NewCategoryPage extends StatefulWidget {
  final NoteCategory? editCategory;
  static const routeName = '/new_category';

  NewCategoryPage({Key? key, this.editCategory}) : super(key: key);

  @override
  _NewCategoryPageState createState() => _NewCategoryPageState();
}

class _NewCategoryPageState extends State<NewCategoryPage> {
  final _textController = TextEditingController();
  NoteCategory? _selectedCategory;
  bool _showError = false;

  final List<NoteCategory> _defaultCategories = [
    NoteCategory(image: 'city.png', color: Colors.lightBlue),
    NoteCategory(image: 'family.png', color: Colors.indigoAccent),
    NoteCategory(image: 'health.png', color: Colors.amber.shade800),
    NoteCategory(image: 'home_plant.png', color: Colors.amberAccent.shade400),
    NoteCategory(image: 'it.png', color: Colors.lightBlue.shade300),
    NoteCategory(image: 'money.png', color: Colors.red.shade800),
    NoteCategory(image: 'plant.png', color: Colors.lightBlueAccent.shade100),
    NoteCategory(image: 'shopping.png', color: Colors.blueGrey.shade800),
    NoteCategory(image: 'space.png', color: Colors.blue.shade800),
    NoteCategory(image: 'sports.png', color: Colors.orangeAccent),
    NoteCategory(image: 'todo.png', color: Colors.pinkAccent),
    NoteCategory(image: 'travel.png', color: Colors.lightBlue)
  ];

  @override
  void initState() {
    _textController.text = widget.editCategory?.name ?? '';
    _selectedCategory = widget.editCategory;
    super.initState();
  }

  void _addCategory() {
    var name = _textController.text;
    var selectedCategory = _selectedCategory;
    if (name.isEmpty) {
      setState(() => _showError = true);
      return;
    }
    if (selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Specify the icon for new category'),
        ),
      );
      return;
    }
    setState(() => _showError = false);
    Navigator.of(context).pop(
      NoteCategory(
        name: name,
        image: selectedCategory.image,
        color: selectedCategory.color,
      ),
    );
  }

  Widget _textInput() {
    return Padding(
      padding: const EdgeInsets.only(top: Insets.medium, right: Insets.large, left: Insets.large),
      child: TextField(
        textInputAction: TextInputAction.done,
        style: Theme.of(context).textTheme.bodyText2?.copyWith(fontSize: FontSize.big),
        decoration: InputDecoration(
          hintText: 'Type the name...',
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).accentColor),
          ),
          errorText: _showError ? 'Name can\'t be empty' : null,
        ),
        controller: _textController,
        onChanged: (text) => setState(() => _showError = text.isEmpty),
      ),
    );
  }

  Widget _gridContent() {
    return Expanded(
      child: GridView.count(
        padding: const EdgeInsets.symmetric(vertical: Insets.medium, horizontal: Insets.large),
        crossAxisCount: 3,
        children: _defaultCategories
            .map(
              (category) => Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(CornerRadius.card),
                  border: Border.all(
                    width: 2,
                    color: _selectedCategory?.image == category.image
                        ? Theme.of(context).accentColor
                        : Theme.of(context).scaffoldBackgroundColor,
                  ),
                  color: _selectedCategory?.image == category.image
                      ? Theme.of(context).accentColor.withAlpha(50)
                      : null,
                ),
                child: CategoryItem(
                  category: category,
                  onTap: (category) => setState(() => _selectedCategory = category),
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: !kIsWeb && (Platform.isMacOS || Platform.isIOS)
              ? const Icon(Icons.arrow_back_ios)
              : const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'New Category',
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
        actions: [IconButton(onPressed: _addCategory, icon: const Icon(Icons.done))],
      ),
      body: Column(
        children: [_textInput(), _gridContent()],
      ),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
}
