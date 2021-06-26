import 'package:flutter/material.dart';
import '../domain.dart';

class AddCategoryPage extends StatefulWidget {
  AddCategoryPage({Key? key}) : super(key: key);

  @override
  _AddCategoryPageState createState() => _AddCategoryPageState();
}

class _AddCategoryPageState extends State<AddCategoryPage> {
  final List<IconData> _icons = initialIcons;
  final TextEditingController _textEditingController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  int _indexOfSelectedElement = 0;
  IconData _selectedIcon = initialIcons.first;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Create a new Page')),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          _textEditingController.text.isEmpty
              ? () {}
              : {
                  Navigator.of(context).pop(Category(
                      _textEditingController.text,
                      [],
                      _selectedIcon,
                      DateTime.now())),
                  _textEditingController.clear(),
                };
        },
      ),
      body: ListView.separated(
        itemCount: _icons.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return Center(
              child: Container(
                width: 350.0,
                height: 80.0,
                padding: const EdgeInsets.all(4.0),
                child: Row(
                  children: <Widget>[
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: TextField(
                        controller: _textEditingController,
                        focusNode: _focusNode,
                        decoration: InputDecoration(
                          hintText: 'Enter name of the Page',
                          border: InputBorder.none,
                          filled: false,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                  ],
                ),
              ),
            );
          }
          return ListTile(
            title: Text('tab to select this icon'),
            subtitle: Text('#${index - 1}'),
            leading: CircleAvatar(
                foregroundColor: Colors.black54,
                child: Icon(_icons[index - 1])),
            onTap: () {
              setState(
                () {
                  _indexOfSelectedElement = index - 1;
                  _selectedIcon = _icons[index - 1];
                },
              );
            },
            selected: _indexOfSelectedElement == index - 1,
          );
        },
        separatorBuilder: (context, index) => const Divider(),
      ),
    );
  }
}
