import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/category_bloc/category_bloc.dart';
import '../blocs/home_page_bloc/homepage_bloc.dart';
import '../components/category_bottom_sheet.dart';
import '../model/category.dart';
import '../pages/category_page.dart';

class CategoryView extends StatelessWidget {
  final Category category;

  CategoryView(this.category);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        showModalBottomSheet(
          context: context,
          builder: (_) {
            return BlocProvider.value(
              value: BlocProvider.of<HomepageBloc>(context),
              child: CategoryBottomSheet(category),
            );
          },
        );
      },
      behavior: HitTestBehavior.translucent,
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) {
              return BlocProvider.value(
                value: BlocProvider.of<CategoryBloc>(context),
                child: CategoryPage(category),
              );
            },
          ),
        );
      },
      child: Container(
        constraints: BoxConstraints(
          minHeight: 80,
        ),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: AspectRatio(
                child: Icon(
                  category.icon,
                  size: 36,
                ),
                aspectRatio: 1,
              ),
            ),
            Expanded(
              flex: 5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BlocBuilder<HomepageBloc, HomepageState>(
                    builder: (context, state) {
                      return Row(
                        children: [
                          if (category.isPinned)
                            Icon(
                              Icons.pin_drop_outlined,
                              color: Theme.of(context).accentColor,
                            ),
                          Text(
                            category.name,
                            style: Theme.of(context).textTheme.headline5,
                          ),
                        ],
                      );
                    },
                  ),
                  BlocBuilder<CategoryBloc, CategoryState>(
                    builder: (context, state) {
                      return Text(
                        category.records.isEmpty
                            ? 'No events. Tap to create first'
                            : category.records.first.message.isEmpty
                                ? 'Image record'
                                : category.records.first.message,
                        style: Theme.of(context).textTheme.bodyText1,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      );
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  Text(
                    'Yesterday',
                    style: Theme.of(context).textTheme.bodyText2,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
