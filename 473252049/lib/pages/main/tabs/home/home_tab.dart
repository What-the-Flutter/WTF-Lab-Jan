import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../widgets/category_widget.dart';
import 'cubit/categories_cubit.dart';

class HomeTab extends StatefulWidget {
  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  @override
  void initState() {
    context.read<CategoriesCubit>().loadCategories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoriesCubit, CategoriesState>(
      builder: (context, state) {
        if (state is CategoriesLoadInProcess) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return ListView.separated(
          separatorBuilder: (context, index) => Divider(
            height: 1,
          ),
          itemBuilder: (context, index) =>
              CategoryWidget(state.categories[index]),
          itemCount: state.categories.length,
        );
      },
    );
  }
}
