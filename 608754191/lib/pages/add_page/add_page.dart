import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../main.dart';
import '../entity/category.dart';
import 'add_page_cubit.dart';

class AddPage extends StatefulWidget {
  final List<Category> categories;
  final List<IconData> icons = initialIcons;
  final int indexOfCategory;

  AddPage({Key? key, required this.categories, required this.indexOfCategory}) : super(key: key);

  AddPage.add({this.categories = const <Category>[], this.indexOfCategory = 0});

  @override
  _AddPageState createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  late final TextEditingController _textEditingController;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    _textEditingController = TextEditingController();
    _focusNode.requestFocus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddPageCubit, AddPageState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.blueGrey[100],
          appBar: _appBarFromAddingPage(),
          body: _bodyFromAddingPage(state),
          floatingActionButton: FloatingActionButton(
            onPressed: () => _create(state, context),
            child: const Icon(
              Icons.done,
              size: 40,
            ),
            foregroundColor: Colors.black,
            backgroundColor: Colors.yellow,
          ),
        );
      },
    );
  }

  AppBar _appBarFromAddingPage() {
    return AppBar(
      backgroundColor: Colors.black,
      title: const Center(
        child: Text(
          'Create a new page',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  void _create(AddPageState state, BuildContext context) {
    Navigator.of(context).pop(
      Category(
        _textEditingController.text,
        widget.icons[state.selectedIconIndex],
        [],
      ),
    );
    _textEditingController.clear();
  }

  Widget _bodyFromAddingPage(AddPageState state) {
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
            itemCount: widget.icons.length,
            itemBuilder: (
              context,
              index,
            ) {
              return GridTile(
                child: Padding(
                  padding: index == state.selectedIconIndex
                      ? const EdgeInsets.all(10.0)
                      : const EdgeInsets.all(22.0),
                  child: CircleAvatar(
                    foregroundColor: Colors.white,
                    backgroundColor:
                        index == state.selectedIconIndex ? (Colors.red) : (Colors.black),
                    child: IconButton(
                      onPressed: () {
                        BlocProvider.of<AddPageCubit>(context).setSelectedIconIndex(index);
                      },
                      icon: Icon(
                        widget.icons[index],
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
