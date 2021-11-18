import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'category_creator_view.dart';
import 'category_details_view.dart';
import 'mockup.dart';
import 'models/category.dart';

class CategoriesListPage extends StatefulWidget {
  const CategoriesListPage({Key? key}) : super(key: key);

  @override
  State<CategoriesListPage> createState() => _CategoriesListPageState();
}

class _CategoriesListPageState extends State<CategoriesListPage> {
  Category? chosenCategory;
  bool isHiddenMenuChecked = false;
  static final List<Category> _categories = Mockup.categories;

  Future<bool> _onAddCategoryButtonPress([Category? category]) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (_) => CategoryCreatorView(category: category)),
    );
    if (result != null) {
      setState(() => _categories.add(result as Category));
      return true;
    }
    return false;
  }

  void _onListItemPress(String category) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => CategoryView(category: category)),
    );
  }

  void _onListItemLongPress(Category category) {
    setState(() {
      isHiddenMenuChecked = !isHiddenMenuChecked;
      chosenCategory = category;
    });
  }

  void _exitHiddenMenu() {
    setState(() {
      isHiddenMenuChecked = false;
      chosenCategory = null;
    });
  }

  AlertDialog myDialog() {
    final tmp = chosenCategory!;
    return AlertDialog(
      title: ListTile(
        title: Text(tmp.name),
        leading: Icon(tmp.icon),
      ),
      content: Text('isFavourite: ${tmp.favourite}\nCreated: ${tmp.formattedDate}'),
    );
  }

  void _onInfoButtonPress() async {
    await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => myDialog(),
    );
    _exitHiddenMenu();
  }

  void _onPinButtonPress() {
    final category = chosenCategory!;
    setState(() {
      _categories.add(Category(
          category.name, category.icon, !category.favourite, category.created));
      _categories.sort((a, b) => b.sort());
    });
    _onDeleteButtonPress();
  }

  void _onDeleteButtonPress() {
    setState(() => _categories.remove(chosenCategory!));
    _exitHiddenMenu();
  }

  void _onArchiveButtonPress() {
    Mockup.mockup(
        'Category "${chosenCategory!.name}" added to archive', context);
    _exitHiddenMenu();
  }

  void _onEditButtonPress() async {
    final result = await _onAddCategoryButtonPress(chosenCategory);
    if (result) _onDeleteButtonPress();
  }

  Widget _hiddenMenu() {
    return Visibility(
      child: Container(
        color: Colors.black38,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('Info'),
              onTap: _onInfoButtonPress,
            ),
            ListTile(
              leading: const Icon(Icons.attach_file),
              title: const Text('Pin/Unpin Category'),
              onTap: _onPinButtonPress,
            ),
            ListTile(
              leading: const Icon(Icons.archive),
              title: const Text('Archive Page'),
              onTap: _onArchiveButtonPress,
            ),
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Edit Page'),
              onTap: _onEditButtonPress,
            ),
            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text('Delete Page'),
              onTap: _onDeleteButtonPress,
            ),
          ],
        ),
      ),
      visible: isHiddenMenuChecked,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ListView.separated(
          padding: const EdgeInsets.all(10),
          itemCount: _categories.length,
          itemBuilder: (_, index) {
            final item = _categories[index];
            return ListTile(
              leading: Icon(item.icon),
              title: Text(item.name),
              trailing: item.favourite
                  ? const Icon(Icons.attach_file)
                  : const SizedBox(),
              onTap: () => _onListItemPress(item.name),
              onLongPress: () => _onListItemLongPress(item),
            );
          },
          separatorBuilder: (_, __) => const Divider(),
        ),
        Positioned(
          bottom: 10.0,
          right: 10.0,
          child: FloatingActionButton(
            onPressed: _onAddCategoryButtonPress,
            tooltip: 'Add entry',
            child: const Icon(Icons.add),
          ),
        ),
        Positioned(
          bottom: 0.0,
          child: _hiddenMenu(),
        )
      ],
    );
  }
}
