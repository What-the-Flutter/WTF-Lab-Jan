import 'package:flutter/material.dart';
import '../domain.dart';

class UpdateCategoryPage extends StatefulWidget {
  final Category category;

  UpdateCategoryPage({Key? key, required this.category}) : super(key: key);

  @override
  _UpdateCategoryPageState createState() => _UpdateCategoryPageState(category);
}

class _UpdateCategoryPageState extends State<UpdateCategoryPage> {
  final Category _category;
  final List<IconData> _icons = initialIcons;
  final TextEditingController _textEditingController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  int _indexOfSelectedElement = 0;
  IconData _selectedIcon = initialIcons.first;

  _UpdateCategoryPageState(this._category);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Center(child: Text('Update Page')),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.auto_awesome),
          onPressed: () {
            _textEditingController.text.isEmpty
                ? () {}
                : {
                    _category.iconData = _selectedIcon,
                    _category.name = _textEditingController.text,
                    Navigator.of(context).pop(),
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
                    child: Row(children: <Widget>[
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: TextField(
                          controller: _textEditingController,
                          focusNode: _focusNode,
                          decoration: InputDecoration(
                            hintText: 'Enter new name of the Page',
                            border: InputBorder.none,
                            filled: false,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                    ])),
              );
            }
            return ListTile(
              title: Text('tab to select this icon'),
              subtitle: Text('#${index - 1}'),
              leading: CircleAvatar(
                  foregroundColor: Colors.black54,
                  child: Icon(_icons[index - 1])),
              onTap: () {
                setState(() {
                  _indexOfSelectedElement = index - 1;
                  _selectedIcon = _icons[index - 1];
                });
              },
              selected: _indexOfSelectedElement == index - 1,
            );
          },
          separatorBuilder: (context, index) => const Divider(),
        ));
  }
}
