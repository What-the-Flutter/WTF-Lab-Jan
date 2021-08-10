import 'dart:ui';

import 'package:flutter/material.dart';

import '../models/category.dart';
import '../models/note.dart';
import '../utils/constants.dart';
import '../widgets/actions_popup_menu.dart';
import '../widgets/category_item.dart';
import '../widgets/inherited/app_theme.dart';
import 'category_notes_page.dart';
import 'new_category_page.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key, required this.categories}) : super(key: key);

  final List<NoteCategory> categories;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentTab = 0;
  Offset? _tapPosition;
  late final List<NoteCategory> _categories = widget.categories;
  late final Map<int, List<BaseNote>> _categoryNotes = {
    for (final category in _categories) category.id: []
  };

  void _changeTheme(BuildContext context) {
    AppTheme.of(context).switchTheme();
  }

  void _showToast() {
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('No magic happened yet')));
  }

  void _addCategory(NoteCategory category) {
    setState(() => _categories.add(category));
  }

  void _updateCategory(NoteCategory category) {
    setState(() {
      final oldCategory = _categories.firstWhere((element) => element.id == category.id);
      if (oldCategory.image != category.image || oldCategory.name != category.name) {
        final index = _categories.indexOf(oldCategory);
        _categories.remove(oldCategory);
        _categories.insert(index, category);
      }
    });
  }

  void _selectTab(int tab) {
    setState(() => _currentTab = tab);
  }

  Widget _topButton() {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(Insets.xmedium),
        margin: const EdgeInsets.symmetric(horizontal: 40.0),
        child: ElevatedButton(
          onPressed: _showToast,
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

  void _switchPriority(NoteCategory category) {
    setState(() {
      if (category.priority == CategoryPriority.high) {
        category.priority = CategoryPriority.normal;
      } else {
        category.priority = CategoryPriority.high;
      }
    });
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

  void _deleteNoteCategory(NoteCategory category) {
    setState(() {
      _categoryNotes.remove(category.id);
      _categories.remove(category);
    });
  }

  Widget _categoriesGrid() {
    _categories.sort((a, b) => a.priority.index.compareTo(b.priority.index));
    return Expanded(
      child: GridView.count(
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
        children: _categories
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
      ),
    );
  }

  void _onCategoryClick(NoteCategory category) {
    Navigator.of(context).pushNamed(
      CategoryNotesPage.routeName,
      arguments: CategoryNotesArguments(
        category: category,
        notes: _categoryNotes[category.id] ?? [],
      ),
    );
  }

  void _navigateToNewCategory() async {
    final result = await Navigator.of(context).pushNamed(NewCategoryPage.routeName);
    if (result != null && result is NoteCategory) {
      _addCategory(result);
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

  Widget _bottomNavigationBar() {
    return BottomNavigationBar(
      selectedItemColor: Theme.of(context).accentColor,
      unselectedItemColor: Colors.indigo,
      backgroundColor: Theme.of(context).primaryColor,
      items: [
        const BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          label: 'Home',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.list_alt_outlined),
          label: 'Daily',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.timeline_outlined),
          label: 'Timeline',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.explore_outlined),
          label: 'Explore',
        ),
      ],
      onTap: _selectTab,
      currentIndex: _currentTab,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = AppTheme.of(context).isDarkMode;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Home',
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
        actions: [
          IconButton(
            onPressed: () => _changeTheme(context),
            icon: isDarkMode ? const Icon(Icons.light_mode) : const Icon(Icons.dark_mode),
          ),
        ],
      ),
      drawer: const Drawer(),
      bottomNavigationBar: _bottomNavigationBar(),
      body: Center(
        child: Column(
          children: [_topButton(), _categoriesGrid()],
        ),
      ),
      floatingActionButton: _fab(context),
    );
  }
}
