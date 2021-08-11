import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../repository/category_repository.dart';
import 'bloc/bloc.dart';
import 'categories_content.dart';

class CategoriesPage extends StatelessWidget {
  const CategoriesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CategoriesBloc(
        const InitialCategoriesState(),
        repository: RepositoryProvider.of<CategoryRepository>(context),
      )..add(const FetchCategoriesEvent()),
      child: CategoriesContent(),
    );
  }
}
