import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import '../../models/category.dart';

import '../home/home.dart';
import '../home/home_cubit.dart';
import 'create_category_cubit.dart';

class CreateCategory extends StatefulWidget {
  final int? index;

  CreateCategory({Key? key, this.index}) : super(key: key);

  @override
  _CreateCategoryState createState() => _CreateCategoryState();
}

class _CreateCategoryState extends State<CreateCategory> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late FocusNode _node;
  late List<Categories> _categories;

  @override
  void initState() {
    super.initState();
    _categories = context.read<CreateCategoryCubit>().iconsRepository.list;
    final category =
        context.read<CreateCategoryCubit>().init(context, widget.index);
    if (category == null) {
      _titleController = TextEditingController();
      _descriptionController = TextEditingController();
    } else {
      _titleController = TextEditingController(text: category.title);
      _descriptionController = TextEditingController(text: category.descripton);
    }

    Future.delayed(Duration.zero, () => _node = FocusScope.of(context));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: BlocBuilder<CreateCategoryCubit, CreateCategoryState>(
      builder: (context, state) {
        return Scaffold(
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _titleTextField(state),
              _descriptionTextField(state),
              _categoryList(state),
            ],
          ),
          floatingActionButton: !state.isSelected
              ? FloatingActionButton(
                  onPressed: () => Navigator.pop(context),
                  child: Icon(Icons.close),
                )
              : FloatingActionButton(
                  onPressed: () {
                    if (state is CreateCategoryAddChoose) {
                      context.read<HomeCubit>().add(
                            state.index!,
                            _descriptionController.text,
                            _titleController.text,
                          );
                    } else if (state is CreateCategoryUpdateChoose) {
                      context.read<HomeCubit>().update(
                            widget.index!,
                            _descriptionController.text,
                            _titleController.text,
                            state.index!,
                          );
                    }
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MyHomePage(),
                      ),
                    );
                  },
                  child: Icon(Icons.done),
                ),
        );
      },
    ));
  }

  Flexible _titleTextField(CreateCategoryState state) {
    return Flexible(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: TextField(
          controller: _titleController,
          style: TextStyle(color: Colors.grey, fontSize: 18),
          textInputAction: TextInputAction.next,
          onEditingComplete: () => _node.nextFocus(),
          decoration: InputDecoration(
            hintText: 'Title',
            hintStyle: TextStyle(color: Colors.grey, fontSize: 18),
            border: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.grey,
                width: 2,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Flexible _descriptionTextField(CreateCategoryState state) {
    return Flexible(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: TextField(
          style: TextStyle(color: Colors.grey, fontSize: 16),
          controller: _descriptionController,
          maxLines: null,
          textInputAction: TextInputAction.done,
          onSubmitted: (_) => _node.unfocus(),
          decoration: InputDecoration(
            hintText: 'Description',
            hintStyle: TextStyle(color: Colors.grey, fontSize: 16),
            border: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.grey,
                width: 2,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Expanded _categoryList(CreateCategoryState state) {
    return Expanded(
      child: GridView(
        physics: NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(10),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
        ),
        children: _categories.map(
          (value) {
            return Hero(
              tag: '$value',
              child: GestureDetector(
                child: state.index == value
                    ? Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 2,
                            color: Colors.lime.shade900,
                          ),
                          borderRadius: BorderRadius.circular(20),
                          image: DecorationImage(
                            image: AssetImage(value.img),
                            fit: BoxFit.cover,
                          ),
                        ),
                      )
                    : Image.asset(value.img),
                onTap: () {
                  context.read<CreateCategoryCubit>().onChooseIcon(value);
                },
              ),
            );
          },
        ).toList(),
      ),
    );
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _titleController.dispose();
    _node.dispose();
    super.dispose();
  }
}
