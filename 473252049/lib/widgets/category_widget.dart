import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../components/category_bottom_sheet.dart';
import '../model/category.dart';
import '../pages/category_page.dart';
import '../pages/chats_cubit/chats_cubit.dart';

class CategoryWidget extends StatelessWidget {
  final Category category;

  CategoryWidget(this.category);

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return GestureDetector(
          onLongPress: () {
            showModalBottomSheet(
              context: context,
              builder: (_) {
                return BlocProvider.value(
                  value: BlocProvider.of<ChatsCubit>(context),
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
                    value: context.read<ChatsCubit>(),
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
                      Row(
                        children: [
                          if (category.isPinned)
                            Icon(
                              Icons.pin_drop_outlined,
                              color: Theme.of(context).accentColor,
                              size: Theme.of(context)
                                  .textTheme
                                  .headline5
                                  .fontSize,
                            ),
                          Text(
                            category.name,
                            style: Theme.of(context).textTheme.headline5,
                          ),
                        ],
                      ),
                      Text(
                        category.records.isEmpty
                            ? 'No events. Tap to create first'
                            : category.records.first.message.isEmpty
                                ? 'Image record'
                                : category.records.first.message,
                        style: Theme.of(context).textTheme.bodyText1,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
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
      },
    );
  }
}
