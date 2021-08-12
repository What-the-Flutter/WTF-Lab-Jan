import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../models/category.dart';
import '../../../utils/constants.dart';
import '../../../widgets/actions_popup_menu.dart';
import '../../../widgets/category_item.dart';
import '../../category_notes/category_notes_page.dart';
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

  void _addCategory(NoteCategory category) {
    _categoriesBloc.add(AddCategoryEvent(category));
  }

  void _updateCategory(NoteCategory category) {
    _categoriesBloc.add(UpdateCategoryEvent(category));
  }

  void _deleteNoteCategory(NoteCategory category) {
    _categoriesBloc.add(DeleteCategoryEvent(category));
  }

  void _switchPriority(NoteCategory category) {
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
                  style: TextStyle(
                    color: Theme.of(context).accentIconTheme.color,
                    fontSize: FontSize.normal,
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

  void _showPopupMenu(NoteCategory category) async {
    final overlay = Overlay.of(context)?.context.findRenderObject() as RenderBox?;
    final tapOffset = _tapPosition;
    if (overlay != null && tapOffset != null) {
      final action = await showMenu(
        context: context,
        position: RelativeRect.fromRect(
          tapOffset & const Size(40, 40),
          Offset.zero & overlay.size,
        ),
        items: [
          ActionPopupMenuEntry(
            action: PopupAction.edit,
            name: 'Edit',
            color: Theme.of(context).accentColor,
          ),
          ActionPopupMenuEntry(
            action: PopupAction.pin,
            name: category.priority == CategoryPriority.high ? 'Unpin' : 'Pin',
            color: Theme.of(context).accentColor,
          ),
          ActionPopupMenuEntry(
            action: PopupAction.delete,
            name: 'Delete',
            color: Colors.red,
          ),
        ],
      );
      if (action != null) {
        switch (action) {
          case PopupAction.edit:
            final result = await Navigator.of(context)
                .pushNamed(NewCategoryPage.routeName, arguments: NewCategoryArguments(category));
            if (result != null && result is NoteCategory) {
              _updateCategory(result);
            }
            break;
          case PopupAction.delete:
            _showDeleteDialog(category);
            break;
          case PopupAction.pin:
            _switchPriority(category);
            break;
        }
      }
    }
  }

  void _showDeleteDialog(NoteCategory category) {
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
      child: BlocBuilder<CategoriesBloc, CategoriesState>(builder: (context, state) {
        if (state is! CategoriesFetchedState) {
          return const Center(child: CircularProgressIndicator());
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
                      onTap: _onCategoryClick,
                      onLongPress: _showPopupMenu,
                    ),
                  ),
                ),
              )
              .toList(),
        );
      }),
    );
  }

  void _onCategoryClick(NoteCategory category) {
    Navigator.of(context).pushNamed(
      CategoryNotesPage.routeName,
      arguments: CategoryNotesArguments(category: category),
    );
  }

  void _navigateToNewCategory() async {
    final result = await Navigator.of(context).pushNamed(NewCategoryPage.routeName);
    if (result != null && result is NoteCategory) {
      result.id == null ? _addCategory(result) : _updateCategory(result);
    }
  }

  Widget _fab(BuildContext context) {
    return FloatingActionButton(
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
