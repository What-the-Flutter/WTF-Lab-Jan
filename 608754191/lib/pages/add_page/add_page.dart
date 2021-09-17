import 'package:flutter/material.dart';

import '../../main.dart';
import '../entity/category.dart';

class AddPage extends StatefulWidget {
  List<Category> categories;
  final List<IconData> icons;

  AddPage({
    Key? key,
    required this.categories,
    required this.icons,
  }) : super(key: key);

  AddPage.add({
    this.categories = const <Category>[],
    this.icons = const <IconData>[],
  });

  @override
  State<StatefulWidget> createState() => _AddPage();
}

class _AddPage extends State<AddPage> {
  late List<Category> categories;
  final TextEditingController _textEditingController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  int _selectedIndex = 0;

  @override
  void initState() {
    categories = widget.categories;
    _focusNode.requestFocus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[100],
      appBar: _appBarFromAddingPage(),
      body: _bodyFromAddingPage(),
      floatingActionButton: _floatingActionButtonFromSaving(),
    );
  }

  AppBar _appBarFromAddingPage() {
    return AppBar(
      backgroundColor: Colors.black,
      title: const Center(
        child: Text(
          'Create a new page',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  FloatingActionButton _floatingActionButtonFromSaving() {
    return FloatingActionButton(
      onPressed: () => _create(context),
      child: const Icon(
        Icons.done,
        size: 40,
      ),
      foregroundColor: Colors.black,
      backgroundColor: Colors.yellow,
    );
  }

  void _create(BuildContext context) {
    final category = Category(
      _textEditingController.text,
      '',
      icons[_selectedIndex],
      [],
    );
    Navigator.pop(context, category);
    _textEditingController.clear();
  }

  Widget _bodyFromAddingPage() {
    return Column(
      children: [
        const SizedBox(
          height: 40,
        ),
        TextField(
          controller: _textEditingController,
          focusNode: _focusNode,
          decoration: const InputDecoration(
            hintText: 'Name of the Page',
            filled: false,
            hoverColor: Colors.black,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(
                  40,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 30,
        ),
        Expanded(
          child: GridView.builder(
            itemCount: icons.length,
            itemBuilder: (
              context,
              index,
            ) {
              return GridTile(
                child: Padding(
                  padding: index == _selectedIndex
                      ? const EdgeInsets.all(10.0)
                      : const EdgeInsets.all(19.0),
                  child: CircleAvatar(
                    foregroundColor: Colors.white,
                    backgroundColor: index == _selectedIndex ? (Colors.red) : (Colors.black),
                    child: IconButton(
                      onPressed: () => setState(
                        () => _selectedIndex = index,
                      ),
                      icon: Icon(
                        icons[index],
                        size: 33,
                      ),
                    ),
                  ),
                ),
              );
            },
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
            ),
          ),
        ),
      ],
    );
  }
}
