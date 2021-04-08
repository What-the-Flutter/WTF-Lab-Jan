import 'package:chat_journal/repositories/local_database/local_database_categories_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../repositories/local_database/local_database_records_repository.dart';
import '../../category/category_page.dart';
import '../../category/cubit/records_cubit.dart';
import '../components/category_bottom_sheet.dart';
import '../tabs/home/cubit/categories_cubit.dart';

class CategoryWidget extends StatelessWidget {
  final CategoryWithLastRecord categoryWithLastRecord;

  CategoryWidget(this.categoryWithLastRecord);

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
                  child: CategoryBottomSheet(categoryWithLastRecord.category),
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
                        recordsRepository: LocalDatabaseRecordsRepository(),
                        categoriesRepository:
                            LocalDatabaseCategoriesRepository(),
                      )..loadRecords(
                          categoryId: categoryWithLastRecord.category.id,
                        ),
                      child: CategoryPage(categoryWithLastRecord.category),
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
                      categoryWithLastRecord.category.icon,
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
                          if (categoryWithLastRecord.category.isPinned)
                            Icon(
                              Icons.pin_drop_outlined,
                              color: Theme.of(context).accentColor,
                              size: Theme.of(context)
                                  .textTheme
                                  .headline5
                                  .fontSize,
                            ),
                          Text(
                            categoryWithLastRecord.category.name,
                            style: Theme.of(context).textTheme.headline5,
                          ),
                        ],
                      ),
                      Text(
                        categoryWithLastRecord.lastRecord == null
                            ? 'No records. Tap to create first'
                            : categoryWithLastRecord
                                        .lastRecord.message?.isEmpty ??
                                    false
                                ? 'Image record'
                                : categoryWithLastRecord.lastRecord.message,
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
                      Text(
                        getFormattedCategoryDateTime(
                          categoryWithLastRecord,
                        ),
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

String getFormattedCategoryDateTime(
    CategoryWithLastRecord categoryWithLastRecord) {
  final dateTime = categoryWithLastRecord.lastRecord == null
      ? categoryWithLastRecord.category.createDateTime
      : categoryWithLastRecord.lastRecord.createDateTime;

  if (dateTime.day == DateTime.now().day) {
    return DateFormat.Hm().format(dateTime);
  } else if (DateTime.now().difference(dateTime).inDays < 7) {
    return DateFormat.E().format(dateTime);
  } else if (DateTime.now().difference(dateTime).inDays < 365) {
    return DateFormat.Md().format(dateTime);
  } else {
    return DateFormat.y().format(dateTime);
  }
}
