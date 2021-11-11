import 'package:flutter/material.dart';

class CategoryCreatorView extends StatefulWidget {
  const CategoryCreatorView({Key? key}) : super(key: key);

  @override
  State<CategoryCreatorView> createState() => _CategoryCreatorViewState();
}

class _CategoryCreatorViewState extends State<CategoryCreatorView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Create New Category',
        ),
      ),
      body: const Center(
        child: Text('Create New Category'),
      ),
    );
  }
}
