import 'package:cool_notes/repository/category_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../models/category.dart';
import 'bloc/bloc.dart';
import 'new_category_content.dart';

class NewCategoryArguments {
  final NoteCategory? category;

  NewCategoryArguments(this.category);
}

class NewCategoryPage extends StatelessWidget {
  final NoteCategory? editCategory;
  static const routeName = '/new_category';

  const NewCategoryPage({Key? key, this.editCategory}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final bloc = NewCategoryBloc(
          const FetchingDefaultCategoriesState(),
          repository: RepositoryProvider.of<CategoryRepository>(context),
        );
        bloc.add(const FetchDefaultCategoriesEvent());
        if (editCategory != null) {
          bloc.add(CategoryChanged(editCategory!));
        }
        return bloc;
      },
      child: NewCategoryContent(),
    );
  }
}
