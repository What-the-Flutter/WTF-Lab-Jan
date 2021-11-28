import 'package:flutter/material.dart';

import '../../components/floating_action_button.dart';
import '../../models/page_model.dart';
import '../add_page_screen/add_page_screen.dart';
import 'widgets/page_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<PageCard> _listOfChats = <PageCard>[];

  @override
  void initState() {
    _listOfChats.addAll([
      PageCard(
        icon: Icons.notes,
        title: 'Notes',
        key: UniqueKey(),
        deletePage: _deleteSelectedPage,
        editPage: _editSelectedPage,
      ),
      PageCard(
        icon: Icons.travel_explore,
        title: 'Travel',
        key: UniqueKey(),
        deletePage: _deleteSelectedPage,
        editPage: _editSelectedPage,
      ),
      PageCard(
        icon: Icons.sports_score,
        title: 'Sport',
        key: UniqueKey(),
        deletePage: _deleteSelectedPage,
        editPage: _editSelectedPage,
      ),
    ]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: _listOfChats.length,
        itemBuilder: (context, index) {
          return _listOfChats[index];
        },
      ),
      floatingActionButton: AppFloatingActionButton(
        onPressed: () => _navigateToAddPageAndFetchResult(context),
        child: const Icon(Icons.add, size: 50),
      ),
    );
  }

  Future<void> _navigateToAddPageAndFetchResult(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddPageScreen(
          title: 'Create a new Page',
        ),
      ),
    );
    if (result != null) {
      final pageModel = result as PageModel;
      final pageCard = PageCard(
        key: UniqueKey(),
        icon: pageModel.icon,
        title: pageModel.name,
        deletePage: _deleteSelectedPage,
        editPage: _editSelectedPage,
      );
      setState(() => _listOfChats.add(pageCard));
    }
  }

  Future<void> _navigateToEditPageAndEditPage({
    required BuildContext context,
    required String currentTitleOfPage,
    required Key key,
  }) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddPageScreen(
          title: 'Edit Page',
          titleOfPage: currentTitleOfPage,
        ),
      ),
    );
    if (result != null) {
      int? index;
      final pageModel = result as PageModel;
      for (final value in _listOfChats) {
        if (value.key == key) {
          index = _listOfChats.indexOf(value);
          break;
        }
      }
      if (index != null) {
        _listOfChats[index] = PageCard(
          key: key,
          icon: pageModel.icon,
          title: pageModel.name,
          deletePage: _deleteSelectedPage,
          editPage: _editSelectedPage,
        );
      }
    }
  }

  Future<void> _deleteSelectedPage(Key key) async {
    await _showDeleteDialog(key);
    setState(() {});
  }

  Future<void> _editSelectedPage(Key key, String titleOfPage) async {
    await _navigateToEditPageAndEditPage(
      context: context,
      currentTitleOfPage: titleOfPage,
      key: key,
    );
    setState(() {});
  }

  Future<void> _showDeleteDialog(Key key) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete page?'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Are you really sure you want to delete this page?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Yes'),
              onPressed: () {
                _listOfChats.removeWhere((element) => element.key == key);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
