import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../models/category.dart';
import '../../../utils/constants.dart';
import '../../../widgets/category_item.dart';
import '../category_notes/category_notes_page.dart';
import '../new_category/new_category_page.dart';
import 'bloc/bloc.dart';

class CategoriesContent extends StatefulWidget {
  @override
  _CategoriesContentState createState() => _CategoriesContentState();
}

class _CategoriesContentState extends State<CategoriesContent> {
  Offset? _tapPosition;
  late CategoriesBloc _categoriesBloc;

  @override
  void initState() {
    super.initState();
    _categoriesBloc = context.read<CategoriesBloc>();
  }

  void _addCategory(Category category) {
    _categoriesBloc.add(AddCategoryEvent(category));
  }

  void _updateCategory(Category category) {
    _categoriesBloc.add(UpdateCategoryEvent(category));
  }

  void _deleteNoteCategory(Category category) {
    _categoriesBloc.add(DeleteCategoryEvent(category));
  }

  void _switchPriority(Category category) {
    _categoriesBloc.add(SwitchPriorityForCategoryEvent(category));
  }

  void _showSnackBar() {
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('No magic happened yet')));
  }

  Widget _topButton() {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(Insets.xmedium),
        margin: const EdgeInsets.symmetric(horizontal: 40.0),
        child: ElevatedButton(
          onPressed: _showSnackBar,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: Insets.small),
                child: Icon(
                  Icons.attractions,
                  color: Theme.of(context).accentIconTheme.color,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: Insets.xmedium),
                child: Text(
                  'Questionnaire Bot',
                  style: Theme.of(context).textTheme.headline4!.copyWith(
                        color: Theme.of(context).accentIconTheme.color,
                        fontSize: Theme.of(context).textTheme.headline4!.fontSize! - 2,
                        fontWeight: FontWeight.bold,
                      ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _update(Category category) async {
    final result = await Navigator.of(context)
        .pushNamed(NewCategoryPage.routeName, arguments: NewCategoryArguments(category));
    if (result != null && result is Category) {
      _updateCategory(result);
    }
  }

  void _showCategoryMenu(Category category) async {
    await showModalBottomSheet(
      context: context,
      builder: (_) {
        return Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.edit_outlined),
              title: const Text('Edit'),
              onTap: () {
                Navigator.of(context).pop();
                _update(category);
              },
            ),
            ListTile(
              leading: Icon(
                category.priority == CategoryPriority.high
                    ? Icons.push_pin_outlined
                    : Icons.push_pin,
              ),
              title: Text(category.priority == CategoryPriority.high ? 'Unpin' : 'Pin'),
              onTap: () {
                Navigator.of(context).pop();
                _switchPriority(category);
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(
                Icons.delete_forever_outlined,
                color: Colors.red,
              ),
              title: const Text(
                'Delete',
                style: TextStyle(color: Colors.red),
              ),
              onTap: () {
                Navigator.of(context).pop();
                _showDeleteDialog(category);
              },
            ),
          ],
        );
      },
    );
  }

  void _showDeleteDialog(Category category) {
    showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete note category'),
          content:
              const Text('Are you sure you want to delete the category and all associated notes?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel'.toUpperCase(),
                style: TextStyle(color: Theme.of(context).accentColor),
              ),
            ),
            TextButton(
              onPressed: () {
                _deleteNoteCategory(category);
                Navigator.pop(context);
              },
              child: Text(
                'Delete'.toUpperCase(),
                style: const TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _categoriesGrid() {
    return Expanded(
      child: BlocConsumer<CategoriesBloc, CategoriesState>(
        listener: (context, state) {
          if (state is CategoriesFetchedState && state.errorOccurred) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Something went wrong :(')),
            );
          }
        },
        builder: (context, state) {
          if (state is! CategoriesFetchedState) {
            return Center(child: CircularProgressIndicator(color: Theme.of(context).accentColor));
          }
          return GridView.count(
            shrinkWrap: true,
            crossAxisCount: 2,
            mainAxisSpacing: Insets.xsmall,
            crossAxisSpacing: Insets.xsmall,
            padding: const EdgeInsets.fromLTRB(
              Insets.large,
              0.0,
              Insets.large,
              Insets.medium,
            ),
            childAspectRatio: 1.0,
            children: state.categories
                .map(
                  (category) => GestureDetector(
                    onTapDown: (position) => setState(() => _tapPosition = position.globalPosition),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(CornerRadius.card),
                      ),
                      child: CategoryItem(
                        category: category,
                        showPin: true,
                        onTap: _onCategoryClick,
                        onLongPress: _showCategoryMenu,
                      ),
                    ),
                  ),
                )
                .toList(),
          );
        },
      ),
    );
  }

  void _onCategoryClick(Category category) {
    Navigator.of(context).pushNamed(
      CategoryNotesPage.routeName,
      arguments: CategoryNotesArguments(category: category),
    );
  }

  void _navigateToNewCategory() async {
    final result = await Navigator.of(context).pushNamed(NewCategoryPage.routeName);
    if (result != null && result is Category) {
      result.id == null ? _addCategory(result) : _updateCategory(result);
    }
  }

  Widget _fab(BuildContext context) {
    return FloatingActionButton(
      heroTag: 'new_category',
      onPressed: _navigateToNewCategory,
      child: Icon(
        Icons.add,
        color: Theme.of(context).accentIconTheme.color,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [_topButton(), _categoriesGrid()],
        ),
      ),
      floatingActionButton: _fab(context),
    );
  }
}
