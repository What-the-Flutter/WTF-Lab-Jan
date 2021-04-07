import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../model/category.dart';
import '../../main/tabs/home/cubit/categories_cubit.dart';
import '../cubit/records_cubit.dart';

class SendRecordsDialog extends StatelessWidget {
  final Category categoryFrom;

  const SendRecordsDialog({Key key, this.categoryFrom}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecordsCubit, RecordsState>(
      builder: (context, state) {
        return SimpleDialog(
          children: [
            ...context.read<CategoriesCubit>().state.categories.map(
              (category) {
                if (category.category == categoryFrom) {
                  return Container(
                    height: 0,
                  );
                }
                return ListTile(
                  title: Text(category.category.name),
                  onTap: () async {
                    await context.read<RecordsCubit>().sendAll(
                          state.records
                              .where(
                                (element) => element.record.isSelected,
                              )
                              .map((e) => e.record)
                              .toList(),
                          categoryId: categoryFrom.id,
                          categoryToId: category.category.id,
                        );
                    await context.read<RecordsCubit>().unselectAll(
                          categoryId: category.category.id,
                        );
                    await context.read<RecordsCubit>().unselectAll(
                          categoryId: categoryFrom.id,
                        );
                    Navigator.of(context).pop();
                  },
                );
              },
            ),
          ],
        );
      },
    );
  }
}

Future showSendRecordsDialog(BuildContext context,
    {@required Category category}) {
  return showDialog(
    context: context,
    builder: (newContext) {
      return BlocProvider.value(
        value: context.read<CategoriesCubit>(),
        child: BlocProvider.value(
          value: context.read<RecordsCubit>(),
          child: SendRecordsDialog(
            categoryFrom: category,
          ),
        ),
      );
    },
  );
}
