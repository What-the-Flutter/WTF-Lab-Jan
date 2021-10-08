import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../main.dart';
import '../entity/category.dart';
import 'add_page_cubit.dart';

class AddPage extends StatefulWidget {
  final List<Category>? categories;
  final Category? category;
  final List<IconData> icons = initialIcons;
  final int indexOfCategory;

  AddPage({
    Key? key,
    required this.categories,
    required this.indexOfCategory,
    this.category,
  }) : super(key: key);

  AddPage.add({
    this.categories = const <Category>[],
    this.indexOfCategory = 0,
    this.category,
  });

  @override
  _AddPageState createState() => _AddPageState(
        category: category,
        categories: categories,
      );
}

class _AddPageState extends State<AddPage> {
  final TextEditingController _textEditingController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final Category? category;
  final List<Category>? categories;

  _AddPageState({
    this.category,
    this.categories,
  });

  @override
  void initState() {
    if (category != null) {
      BlocProvider.of<AddPageCubit>(context).setSelectedIconIndex(
        category!.iconIndex,
      );
      _textEditingController.text = category!.title;
      _focusNode.requestFocus();
    } else {
      BlocProvider.of<AddPageCubit>(context).setSelectedIconIndex(0);
    }
    BlocProvider.of<AddPageCubit>(context).init(
      category,
      categories,
    );
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
    if (category != null) {
      category!.title = _textEditingController.text;
      category!.iconIndex = state.selectedIconIndex;
      Navigator.of(context).pop(category);
    } else {
      Navigator.pop(
        context,
        Category(
          title: _textEditingController.text,
          iconIndex: 1,
          subTitleMessage: '',
        ),
      );
    }
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
