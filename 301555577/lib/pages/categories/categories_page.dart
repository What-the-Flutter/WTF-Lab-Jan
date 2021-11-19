import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../data/repositories/category_repository.dart';
import '../../logic/cubit/categories_cubit.dart';
import 'widgets/app_bar.dart';
import 'widgets/category_list_item.dart';
import 'widgets/floating_action_button.dart';
import 'widgets/slide_actions.dart';

class CategoriesPage extends StatefulWidget {
  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  @override
  Widget build(BuildContext buildContext) {
    return BlocProvider(
      create: (context) {
        return CategoriesCubit(
          repository: RepositoryProvider.of<CategoryRepository>(context),
        )..fetchCategories();
      },
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: appBar(),
            floatingActionButton: floatingActionButton(context),
            body: Column(
              children: [
                Expanded(
                  child: BlocConsumer<CategoriesCubit, CategoriesState>(
                    listener: (context, state) {
                      if (state is CategoriesFetchedState && state.error) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Something went wrong')),
                        );
                      }
                    },
                    builder: (context, state) {
                      if (state is! CategoriesFetchedState) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: state.categories.length,
                        itemBuilder: (context, index) {
                          return Slidable(
                            endActionPane: endActionPane(state, index, context),
                            startActionPane: startActionPane(state, index),
                            child: categoryListItem(state, index),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
