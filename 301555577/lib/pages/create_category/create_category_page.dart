import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/category_model.dart';
import '../../data/repositories/category_repository.dart';
import '../../logic/cubit/new_category_cubit.dart';
import 'widgets/category_grid.dart';

class NewCategoryArguments {
  final Category? category;

  NewCategoryArguments(this.category);
}

class NewCategoryPage extends StatelessWidget {
  final Category? editCategory;
  NewCategoryPage({Key? key, this.editCategory}) : super(key: key);

  static const routeName = '/new_category';
  final _textController = TextEditingController();

  @override
  Widget build(BuildContext buildContext) {
    return BlocProvider(
      create: (context) {
        return NewCategoryCubit(
          repository: RepositoryProvider.of<CategoryRepository>(context),
        )..fetchDefaultCategories(editCategory);
      },
      child: BlocConsumer<NewCategoryCubit, NewCategoryState>(
        listener: (context, state) {
          if (state is UpdateCategoryState) {
            switch (state.result) {
              case SubmissionResult.success:
                Navigator.of(context).pop(state.selectedCategory);
                break;
              case SubmissionResult.failure:
                if (state.selectedCategory == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Theme.of(context).backgroundColor,
                      content: Text(
                        'Select the icon for new category',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  );
                }
                break;
              case SubmissionResult.unknown:
                break;
              default:
            }
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Theme.of(context).primaryColorLight,
            ),
            floatingActionButton: FloatingActionButton(
              heroTag: 'new_category',
              onPressed: () {
                context.read<NewCategoryCubit>().categorySubmitted();
              },
              child: const Icon(
                Icons.done,
                size: 28,
              ),
            ),
            body: Builder(builder: (context) {
              if (state is FetchingDefaultCategoriesState) {
                return Center(
                  child: CircularProgressIndicator(
                      color: Theme.of(context).primaryColor),
                );
              }
              final currentState = state as UpdateCategoryState;
              if (_textController.text != currentState.name) {
                _textController.text = currentState.name ?? '';
              }
              return Column(
                children: [
                  Expanded(
                    flex: 1,
                    child: Text(
                      'Create category',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 70,
                      bottom: 15,
                      right: 70,
                    ),
                    child: TextField(
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                      ),
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                        hintText: 'Type the title...',
                        focusedBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Theme.of(context).primaryColor),
                        ),
                        errorText: state.error == NameValidationError.empty
                            ? 'Name can\'t be empty'
                            : null,
                      ),
                      controller: _textController,
                      onChanged: (text) =>
                          context.read<NewCategoryCubit>().nameChanged(text),
                    ),
                  ),
                  categoryGrid(state, context),
                ],
              );
            }),
          );
        },
      ),
    );
  }
}
