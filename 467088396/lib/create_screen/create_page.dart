import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../constants.dart';
import '../models/category.dart';
import 'create_cubit.dart';
import 'create_state.dart';

class CreatePage extends StatefulWidget {
  Category? editCategory;

  CreatePage({this.editCategory});

  @override
  _CreatePageState createState() =>
      _CreatePageState(editCategory: editCategory);
}

class _CreatePageState extends State<CreatePage> {
  final _controller = TextEditingController();
  IconData _selectedIcon = icons[0];
  late Category? editCategory;
  bool _isEdit = false;

  _CreatePageState({this.editCategory});

  @override
  void initState() {
    if (editCategory != null) {
      _isEdit = true;
      _controller.text = editCategory!.name;
      _selectedIcon = icons[icons.indexOf(editCategory!.iconData)];
    }
    BlocProvider.of<CreatePageCubit>(context).init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreatePageCubit, CreatePageState>(
      builder: (context, state) {
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
                      decoration: const InputDecoration(
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
          floatingActionButton: _floatingActionButton(),
        );
      },
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

  FloatingActionButton _floatingActionButton() {
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
