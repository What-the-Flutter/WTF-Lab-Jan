import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../components/category_bottom_sheet.dart';
import '../pages/category_page.dart';
import '../pages/cubits/categories/categories_cubit.dart';
import '../pages/cubits/records/records_cubit.dart';
import '../repositories/local_database/local_database_records_repository.dart';

class CategoryWidget extends StatefulWidget {
  final CategoryWithLastRecord categoryWithLastRecord;

  CategoryWidget(this.categoryWithLastRecord);

  @override
  _CategoryWidgetState createState() => _CategoryWidgetState();
}

class _CategoryWidgetState extends State<CategoryWidget> {
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
                  value: BlocProvider.of<CategoriesCubit>(context),
                  child: CategoryBottomSheet(
                      widget.categoryWithLastRecord.category),
                );
              },
            );
          },
          behavior: HitTestBehavior.translucent,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) {
                  return BlocProvider.value(
                    value: context.read<CategoriesCubit>(),
                    child: BlocProvider(
                      create: (context) => RecordsCubit(
                        LocalDatabaseRecordsRepository(),
                      )..loadFromCategory(
                          categoryId: widget.categoryWithLastRecord.category.id,
                        ),
                      child:
                          CategoryPage(widget.categoryWithLastRecord.category),
                    ),
                  );
                },
              ),
            ).then(
              (value) => context.read<CategoriesCubit>().loadCategories(),
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
                      widget.categoryWithLastRecord.category.icon,
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
                          if (widget.categoryWithLastRecord.category.isPinned)
                            Icon(
                              Icons.pin_drop_outlined,
                              color: Theme.of(context).accentColor,
                              size: Theme.of(context)
                                  .textTheme
                                  .headline5
                                  .fontSize,
                            ),
                          Text(
                            widget.categoryWithLastRecord.category.name,
                            style: Theme.of(context).textTheme.headline5,
                          ),
                        ],
                      ),
                      Text(
                        widget.categoryWithLastRecord.lastRecord == null
                            ? 'No records. Tap to create first'
                            : widget.categoryWithLastRecord.lastRecord
                                    .message ??
                                'Image record',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      // Text(
                      //   category.records.isEmpty
                      //       ? DateFormat.E().format(category.createDateTime)
                      //       : category.records.first.createDateTime.day ==
                      //               DateTime.now().day
                      //           ? DateFormat.Hm().format(
                      //               category.records.first.createDateTime)
                      //           : DateFormat.E().format(
                      //               category.records.first.createDateTime),
                      //   style: Theme.of(context).textTheme.bodyText2,
                      //   textAlign: TextAlign.center,
                      // ),
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
