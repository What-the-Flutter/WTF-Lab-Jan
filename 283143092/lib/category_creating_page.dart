import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'blocs/category_creating_bloc.dart';
import 'blocs/category_list_bloc.dart';
import 'models/category.dart';

class CategoryCreatingPage extends StatefulWidget {
  const CategoryCreatingPage(this.categoryBloc, {Key? key, this.category})
      : super(key: key);

  final CategoryListBloc categoryBloc;
  final Category? category;

  @override
  State<CategoryCreatingPage> createState() => _CategoryCreatingPageState();
}

class _CategoryCreatingPageState extends State<CategoryCreatingPage> {
  final TextEditingController _controller = TextEditingController();
  final CategoryCreatingBloc categoryCreationBloc = CategoryCreatingBloc();

  @override
  void initState() {
    super.initState();
    if (widget.category != null) {
      categoryCreationBloc.set(widget.category!.icon);
    }
    _controller.text = widget.category?.name ?? '';
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.category == null ? 'Create New Category' : 'Editing Category',
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(30),
        alignment: Alignment.center,
        child: Column(
          children: [
            const Text(
              'Create New Category',
              style: TextStyle(fontSize: 20),
            ),
            TextField(
              controller: _controller,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.black26,
              ),
              child: const Text(
                'Create',
                style: TextStyle(fontSize: 20),
              ),
              onPressed: () => {
                if (_controller.text.isNotEmpty &&
                    categoryCreationBloc.isNotEmpty)
                  {
                    widget.categoryBloc.add(
                      Category(
                        _controller.text,
                        categoryCreationBloc.state as IconData,
                        widget.category?.favourite ?? false,
                        widget.category?.created ?? DateTime.now(),
                      ),
                    ),
                    if (widget.category != null)
                      {widget.categoryBloc.remove(widget.category!)},
                    Navigator.pop(context, true),
                  }
              },
            ),
            _iconsGrid(),
          ],
        ),
      ),
    );
  }

  Widget _iconsGrid() {
    return Expanded(
      child: BlocBuilder(
        bloc: categoryCreationBloc,
        builder: (context, state) => GridView.builder(
            itemCount: iconList.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount:
                    (MediaQuery.of(context).size.width / 100).round()),
            itemBuilder: (context, index) {
              return GestureDetector(
                child: Card(
                  shape: const CircleBorder(),
                  color: state == iconList[index] ? Colors.grey : Colors.white,
                  child: Icon(iconList[index]),
                ),
                onTap: () => categoryCreationBloc.set(iconList[index]),
              );
            }),
      ),
    );
  }
}
