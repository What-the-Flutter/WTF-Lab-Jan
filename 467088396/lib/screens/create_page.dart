import 'package:flutter/material.dart';

import '../../../constants.dart';
import '../models/category.dart';

class CreatePage extends StatefulWidget {
  @override
  _CreatePageState createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  final _controller = TextEditingController();
  IconData _selectedIcon = icons[0];
  late Category? _editCategory;
  bool _isEdit = false;

  @override
  Widget build(BuildContext context) {
    _editCategory = ModalRoute.of(context)?.settings.arguments as Category?;
    if (_editCategory != null) {
      _isEdit = true;
     // _controller.text = _editCategory!.name;
      //_selectedIcon = icons[icons.indexOf(_editCategory!.iconData)];
    }
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 20,
            horizontal: 30,
          ),
          child: Column(
            children: <Widget>[
              Text(
                _isEdit ? 'Edit Page' : 'Create a new Page',
                style: const TextStyle(
                  fontWeight: FontWeight.w300,
                  fontSize: 20,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 3,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      spreadRadius: 5,
                      blurRadius: 5,
                      offset: const Offset(5, 5),
                      color: primaryColor.withOpacity(0.10),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _controller,
                  onChanged: (_) => setState(() {}),
                  decoration:  const InputDecoration(
                    hintText: 'Enter Event',
                    border: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Expanded(
                child: GridView.count(
                  padding: const EdgeInsets.all(20),
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 20,
                  crossAxisCount: 4,
                  children: _iconList,
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: _floatingActionButton(context),
    );
  }

  List<Widget> get _iconList {
    return icons.map(
      (iconData) {
        return GestureDetector(
          onTap: () {
            _selectedIcon = iconData;
            setState(() {});
          },
          child: _iconListElement(iconData),
        );
      },
    ).toList();
  }

  Stack _iconListElement(IconData iconData) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(
              Radius.circular(100),
            ),
            boxShadow: [
              BoxShadow(
                spreadRadius: 5,
                blurRadius: 5,
                offset: const Offset(3, 5),
                color: primaryColor.withOpacity(0.20),
              ),
            ],
          ),
          child: CircleAvatar(
            child: Icon(
              iconData,
              color: secondColor,
            ),
            radius: 32,
            backgroundColor: Theme.of(context).cardColor,
          ),
        ),
        if (_selectedIcon == iconData)
          const CircleAvatar(
            radius: 11,
            backgroundColor: Colors.white,
            child: CircleAvatar(
              radius: 9,
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              child: Icon(
                Icons.check,
                color: Colors.white,
                size: 17,
              ),
            ),
          ),
      ],
    );
  }

  FloatingActionButton _floatingActionButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: _finishCreatingPage,
      elevation: 0,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: secondColor,
          borderRadius: const BorderRadius.all(
            Radius.circular(100),
          ),
          boxShadow: [
            BoxShadow(
              spreadRadius: 5,
              blurRadius: 5,
              offset: const Offset(3, 5),
              color: Theme.of(context).primaryColor.withOpacity(0.20),
            ),
          ],
        ),
        child: _controller.text.isNotEmpty
            ? const Icon(
                Icons.check_rounded,
                color: Colors.white,
                size: 32,
              )
            : const Icon(
                Icons.close_rounded,
                color: Colors.white,
                size: 32,
              ),
      ),
      backgroundColor: Colors.white,
    );
  }

  void _finishCreatingPage() {
    if (_controller.text.isNotEmpty) {
      Category category;
      category = Category(
        name: _controller.text,
        iconData: _selectedIcon,
        createdTime: DateTime.now(),
      );
      Navigator.of(context).pop(category);
      //Navigator.pop(context);
    } else {
      Navigator.pop(context);
    }
  }
}
