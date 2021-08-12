import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../models/category.dart';
import '../../../repository/category_repository.dart';
import 'bloc/bloc.dart';
import 'new_category_content.dart';

class NewCategoryArguments {
  final Category? category;

  NewCategoryArguments(this.category);
}

class NewCategoryPage extends StatelessWidget {
  final Category? editCategory;
  static const routeName = '/new_category';

  const NewCategoryPage({Key? key, this.editCategory}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => NewCategoryBloc(
        const FetchingDefaultCategoriesState(),
        repository: RepositoryProvider.of<CategoryRepository>(context),
      )..add(FetchDefaultCategoriesEvent(editCategory: editCategory)),
      child: NewCategoryContent(),
    );
  }
}
